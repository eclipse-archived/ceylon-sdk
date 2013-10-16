import ceylon.language.meta {
    modules
}
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

    TestExecutor[] initExecutors() {
        value executors = SequenceBuilder<TestExecutor>();
        for(source in sources) {
            initExecutorsForSource(executors, source, filter, comparator);
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

Boolean isTestableClass(ClassDeclaration classDecl)
        => !classDecl.abstract && !classDecl.anonymous && !classDecl.annotatedMemberDeclarations<FunctionDeclaration, Test>().empty;

Boolean isTestableFunction(FunctionDeclaration funcDecl)
        => !funcDecl.annotations<Test>().empty;

void initExecutorForPackage(SequenceBuilder<TestExecutor> executors, Package pkg, TestFilter filter, TestComparator comparator) {
    for(ClassDeclaration classDecl in pkg.members<ClassDeclaration>()) {
        if( isTestableClass(classDecl) ) {
            executors.append(ClassTestExecutor(classDecl, null, filter, comparator));
        }
    }
    for(FunctionDeclaration funcDecl in pkg.members<FunctionDeclaration>()) {
        if( isTestableFunction(funcDecl) ) {
            executors.append(FunctionTestExecutor(funcDecl));
        }
    }
}

void initExecutorForModule(SequenceBuilder<TestExecutor> executors, Module mod, TestFilter filter, TestComparator comparator) {
    for(pgk in mod.members) {
        initExecutorForPackage(executors, pgk, filter, comparator);
    }
}

void initExecutorsForTypeLiteral(SequenceBuilder<TestExecutor> executors, String typeLiteral, TestFilter filter, TestComparator comparator) {
    Package? findPackage(String pkgName) {
        Module? mod = modules.list.find((Module m) => pkgName.startsWith(m.name));
        Package? pgk = mod?.findPackage(pkgName);
        return pgk;
    }
    
    if( typeLiteral.startsWith("module ") ) {
        String modName = typeLiteral[7...];
        Module? mod = modules.list.find((Module m) => m.name == modName);
        if(exists mod) {
            initExecutorForModule(executors, mod, filter, comparator);
            return;
        }
    }
    else if( typeLiteral.startsWith("package ") ) {
        String pkgName = typeLiteral[8...];
        if(exists pgk = findPackage(pkgName)) {
            initExecutorForPackage(executors, pgk, filter, comparator);
            return;
        }
    }
    else if( typeLiteral.startsWith("class ") ) {
        String fqn = typeLiteral[6...];
        Integer? pkgDelimiter = fqn.firstInclusion("::");
        if(exists pkgDelimiter) {
            String pkgName = fqn[0..pkgDelimiter-1];
            String className = fqn[pkgDelimiter+2...];
            if(exists pkg = findPackage(pkgName)) {
                ClassDeclaration? clazz = pkg.getMember<ClassDeclaration>(className);
                if(exists clazz) {
                    initExecutorsForSource(executors, clazz, filter, comparator);
                    return;
                }
            }
        }
    }
    else if( typeLiteral.startsWith("function ") ) {
        String fqn = typeLiteral[9...];
        Integer? pkgDelimiter = fqn.firstInclusion("::");
        if(exists pkgDelimiter) {
            String pkgName = fqn[0..pkgDelimiter-1];
            if(exists pkg = findPackage(pkgName) ) {
                String rest = fqn[pkgDelimiter+2...];
                Integer? memberDelimiter = rest.firstInclusion(".");
                if(exists memberDelimiter) {
                    String className = rest[0..memberDelimiter-1];
                    String methodName = rest[memberDelimiter+1...];
                    ClassDeclaration? clazz = pkg.getMember<ClassDeclaration>(className);
                    if(exists clazz) {
                        FunctionDeclaration? method = clazz.getMemberDeclaration<FunctionDeclaration>(methodName);
                        if(exists method) {
                            initExecutorsForSource(executors, method, filter, comparator);
                            return;
                        }
                    }
                }
                else {
                    String fceName = rest;
                    FunctionDeclaration? fce = pkg.getMember<FunctionDeclaration>(fceName);
                    if(exists fce) {
                        initExecutorsForSource(executors, fce, filter, comparator);
                        return;
                    }                    
                }
            }
        }
    }
    
    executors.append(ErrorTestExecutor(typeLiteral, Exception("invalid type literal: ``typeLiteral``")));
}

void initExecutorsForSource(SequenceBuilder<TestExecutor> executors, TestSource source, TestFilter filter, TestComparator comparator) {
    if( is Module source ) {
        initExecutorForModule(executors, source, filter, comparator);
    }
    else if( is Package source ) {
        initExecutorForPackage(executors, source, filter, comparator);
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
    else if( is String source ) {
        initExecutorsForTypeLiteral(executors, source, filter, comparator);
    }
}
