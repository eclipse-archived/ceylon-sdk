import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration,
    Package,
    Module
}
import ceylon.language.meta.model {
    Class,
    Function,
    Method
}
import ceylon.test {
    Test,
    TestSource,
    TestListener,
    TestDescription,
    TestRunner,
    TestRunResult,
    TestFilter,
    TestComparator
}

shared class TestRunnerImpl(
        TestSource[] sources,
        TestListener[] listeners,
        TestFilter filter,
        TestComparator comparator) satisfies TestRunner {

    Boolean isTestableClass(ClassDeclaration classDecl)
        => !classDecl.abstract && !classDecl.anonymous && !classDecl.annotatedMemberDeclarations<FunctionDeclaration, Test>().empty;

    Boolean isTestableFunction(FunctionDeclaration funcDecl)
        => !funcDecl.annotations<Test>().empty;

    void initExecutorForPackage(SequenceBuilder<TestExecutor> executors, Package pgk) {
        for(ClassDeclaration classDecl in pgk.members<ClassDeclaration>()) {
            if( isTestableClass(classDecl) ) {
                executors.append(ClassTestExecutor(classDecl, null, filter, comparator));
            }
        }
        for(FunctionDeclaration funcDecl in pgk.members<FunctionDeclaration>()) {
            if( isTestableFunction(funcDecl) ) {
                executors.append(FunctionTestExecutor(funcDecl));
            }
        }
    }

    void initExecutorForModule(SequenceBuilder<TestExecutor> executors, Module mod) {
        for(pgk in mod.members) {
            initExecutorForPackage(executors, pgk);
        }
    }

    TestExecutor[] initExecutors() {
        value executors = SequenceBuilder<TestExecutor>();
        for(source in sources) {
            if( is Module source ) {
                initExecutorForModule(executors, source);
            }
            else if( is Package source ) {
                initExecutorForPackage(executors, source);
            }
            else if( is ClassDeclaration source ) {
                executors.append(ClassTestExecutor(source, null, filter, comparator));
            }
            else if( is Class<Anything, []> source ) {
                executors.append(ClassTestExecutor(source.declaration, null, filter, comparator));
            }
            else if( is FunctionDeclaration source ) {
                if( source.toplevel ) {
                    executors.append(FunctionTestExecutor(source));
                }
                else {
                    assert(is ClassDeclaration cd = source.container);
                    executors.append(ClassTestExecutor(cd, source, filter, comparator));
                }
            }
            else if( is Function<Anything,[]> source ) {
                executors.append(FunctionTestExecutor(source.declaration));
            }
            else if( is Method<Nothing, Anything, []> source ) {
                assert(is ClassDeclaration cd = source.declaration.container);
                executors.append(ClassTestExecutor(cd, source.declaration, filter, comparator));
            }
        }

        value filteredExecutors = filterExecutors(executors.sequence, filter); 
        value sortedExecutors = sortExecutors(filteredExecutors, comparator);

        return sortedExecutors;
    }

    TestExecutor[] executors = initExecutors();

    shared actual TestDescription description => TestDescriptionImpl("root", null, executors*.description);

    shared actual TestRunResult run() {
        value runResult = TestRunResultImpl();

        value listenersBuilder = SequenceBuilder<TestListener>();
        listenersBuilder.append(runResult.listener);
        listenersBuilder.appendAll(listeners);

        value notifier = TestNotifier(listenersBuilder.sequence);

        notifier.testRunStart(description);
        executors*.execute(notifier);
        notifier.testRunFinish(runResult);

        return runResult;
    }

}