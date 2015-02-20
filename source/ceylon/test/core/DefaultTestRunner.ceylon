import ceylon.language.meta {
    ...
}
import ceylon.language.meta.declaration {
    ...
}
import ceylon.language.meta.model {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.internal {
    ...
}
import ceylon.collection {
    ...
}

"Default implementation of [[TestRunner]]."
shared class DefaultTestRunner(
    TestSource[] sources,
    TestListener[] listeners,
    TestFilter filter,
    TestComparator comparator) satisfies TestRunner {
    
    function filterExecutor(TestExecutor e) {
        value result = filter(e.description);
        if (!result) {
            listeners*.testExclude(TestExcludeEvent(e.description));
        }
        return result;
    }
    
    function compareExecutors(TestExecutor e1, TestExecutor e2) {
        return comparator(e1.description, e2.description);
    }
    
    function initExecutors() {
        return createExecutors(sources, filterExecutor, compareExecutors);
    }
    
    TestExecutor[] executors = initExecutors();
    
    shared actual TestDescription description => TestDescription("root", null, null, executors*.description);
    
    shared actual TestRunResult run() {
        verifyCycle();
        try {
            runningRunners.add(this);
            
            value result = TestRunResultImpl();
            value context = TestRunContextImpl(this, result);
            
            context.addTestListener(result.listener, *listeners);
            context.fireTestRunStart(TestRunStartEvent(this, description));
            executors*.execute(context);
            context.fireTestRunFinish(TestRunFinishEvent(this, result));
            context.removeTestListener(result.listener, *listeners);
            
            return result;
        }
        finally {
            runningRunners.remove(this);
        }
        
    }
    
    void verifyCycle() {
        for(runningRunner in runningRunners) {
            if( runningRunner.description == description ) {
                throw Exception("cycle in TestRunner execution was detected, TestRunner.run() is probably invoked from inside test function");
            }
        }
    }
    
}

alias TestCandidate => [FunctionDeclaration, ClassDeclaration?]|ErrorTestExecutor;

TestExecutor[] createExecutors(TestSource[] sources, Boolean(TestExecutor) filter, Comparison(TestExecutor, TestExecutor) comparator) {
    TestCandidate[] candidates = findCandidates(sources);
    
    value executors = ArrayList<TestExecutor>();
    value executorsWithClasses = ArrayList<[ClassDeclaration, ArrayList<TestExecutor>]>();
    
    for (candidate in candidates) {
        switch (candidate)
        case (is [FunctionDeclaration, ClassDeclaration?]) {
            value funcDecl = candidate[0];
            value classDecl = candidate[1];
            
            if (exists suiteAnnotation = funcDecl.annotations<TestSuiteAnnotation>()[0]) {
                value suiteExecutor = createSuiteExecutor(funcDecl, suiteAnnotation, filter, comparator);
                if (filter(suiteExecutor)) {
                    executors.add(suiteExecutor);
                }
            } else {
                value executor = createExecutor(funcDecl, classDecl);
                if (filter(executor)) {
                    if (exists classDecl) {
                        value executorsWithClass = executorsWithClasses.sequence().find(([ClassDeclaration, ArrayList<TestExecutor>] elem) => elem[0] == classDecl);
                        if (exists executorsWithClass) {
                            executorsWithClass[1].add(executor);
                        } else {
                            value list = ArrayList<TestExecutor>();
                            list.add(executor);
                            executorsWithClasses.add([classDecl, list]);
                        }
                    } else {
                        executors.add(executor);
                    }
                }
            }
        }
        case (is ErrorTestExecutor) {
            executors.add(candidate);
        }
    }
    
    for (executorsWithClass in executorsWithClasses.sequence()) {
        value sorted = executorsWithClass[1].sequence().sort(comparator);
        executors.add(GroupTestExecutor(TestDescription(executorsWithClass[0].qualifiedName, null, executorsWithClass[0], sorted*.description), sorted));
    }
    
    return executors.sequence().sort(comparator);
}

TestExecutor createExecutor(FunctionDeclaration funcDecl, ClassDeclaration? classDecl) {
    value executorAnnotation = findAnnotation<TestExecutorAnnotation>(funcDecl, classDecl);
    value executorClass = executorAnnotation?.executor else `class DefaultTestExecutor`;
    value executor = executorClass.instantiate([], funcDecl, classDecl);
    assert (is TestExecutor executor);
    return executor;
}

TestExecutor createSuiteExecutor(FunctionDeclaration funcDecl, TestSuiteAnnotation suiteAnnotation, Boolean(TestExecutor) filter, Comparison(TestExecutor, TestExecutor) comparator) {
    value executors = ArrayList<TestExecutor>();
    value sources = ArrayList<TestSource>();
    
    for (source in suiteAnnotation.sources) {
        if (is ClassDeclaration source) {
            sources.add(source);
        } else if (is FunctionDeclaration source) {
            sources.add(source);
        } else if (is Package source) {
            sources.add(source);
        } else if (is Module source) {
            sources.add(source);
        } else {
            executors.add(ErrorTestExecutor(TestDescription(source.qualifiedName), Exception("declaration ``source.qualifiedName`` is invalid test suite source (only functions, classes, packages and modules are allowed)")));
        }
    }
    
    executors.addAll(createExecutors(sources.sequence(), filter, comparator));
    
    if (executors.empty) {
        return ErrorTestExecutor(TestDescription(funcDecl.qualifiedName, funcDecl), Exception("test suite ``funcDecl.qualifiedName`` does not contains any tests"));
    } else {
        return GroupTestExecutor(TestDescription(funcDecl.qualifiedName, funcDecl, null, executors*.description), executors.sequence());
    }
}

TestCandidate[] findCandidates(TestSource[] sources) {
    value candidates = ArrayList<TestCandidate>();
    for (source in sources) {
        if (is Module source) {
            findCandidatesInModule(candidates, source);
        } else if (is Package source) {
            findCandidatesInPackage(candidates, source);
        } else if (is ClassDeclaration source) {
            findCandidatesInClass(candidates, source);
        } else if (is Class<Anything,[]> source) {
            findCandidatesInClass(candidates, source.declaration);
        } else if (is FunctionDeclaration source) {
            findCandidatesInFunction(candidates, source);
        } else if (is FunctionModel source) {
            findCandidatesInFunction(candidates, source.declaration);
        } else if (is String source) {
            findCandidatesInTypeLiteral(candidates, source);
        }
    }
    return candidates.sequence();
}

void findCandidatesInModule(ArrayList<TestCandidate> candidates, Module mod) {
    for (pkg in mod.members) {
        findCandidatesInPackage(candidates, pkg);
    }
}

void findCandidatesInPackage(ArrayList<TestCandidate> candidates, Package pkg) {
    for (FunctionDeclaration funcDecl in pkg.annotatedMembers<FunctionDeclaration,TestAnnotation>()) {
        candidates.add([funcDecl, null]);
    }
    for (ClassDeclaration classDecl in pkg.members<ClassDeclaration>()) {
        findCandidatesInClass(candidates, classDecl);
    }
}

void findCandidatesInClass(ArrayList<TestCandidate> candidates, ClassDeclaration classDecl) {
    if (!classDecl.abstract) {
        for (funcDecl in classDecl.annotatedMemberDeclarations<FunctionDeclaration,TestAnnotation>()) {
            candidates.add([funcDecl, classDecl]);
        }
    }
}

void findCandidatesInFunction(ArrayList<TestCandidate> candidates, FunctionDeclaration funcDecl, ClassDeclaration? classDecl = null) {
    if (funcDecl.annotations<TestAnnotation>().empty && funcDecl.annotations<TestSuiteAnnotation>().empty) {
        candidates.add(ErrorTestExecutor(TestDescription(funcDecl.qualifiedName, funcDecl), Exception("function ``funcDecl.qualifiedName`` should be annotated with test or testSuite")));
        return;
    }
    
    if (funcDecl.toplevel) {
        candidates.add([funcDecl, null]);
    } else {
        if (exists classDecl) {
            candidates.add([funcDecl, classDecl]);
        } else if (is ClassDeclaration c = funcDecl.container) {
            candidates.add([funcDecl, c]);
        } else {
            candidates.add(ErrorTestExecutor(TestDescription(funcDecl.qualifiedName, funcDecl), Exception("function ``funcDecl.qualifiedName`` should be toplevel function or class method")));
        }
    }
}

void findCandidatesInTypeLiteral(ArrayList<TestCandidate> candidates, String typeLiteral) {
    if (typeLiteral.startsWith("module ")) {
        if (findCandidatesInModuleLiteral(candidates, typeLiteral[7...])) {
            return;
        }
    } else if (typeLiteral.startsWith("package ")) {
        if (findCandidatesInPackageLiteral(candidates, typeLiteral[8...])) {
            return;
        }
    } else if (typeLiteral.startsWith("class ")) {
        if (findCandidatesInClassLiteral(candidates, typeLiteral[6...])) {
            return;
        }
    } else if (typeLiteral.startsWith("function ")) {
        if (findCandidatesInFunctionLiteral(candidates, typeLiteral[9...])) {
            return;
        }
    } else {
        if (findCandidatesInFullQualifiedName(candidates, typeLiteral)) {
            return;
        }
    }
    candidates.add(ErrorTestExecutor(TestDescription(typeLiteral), Exception("invalid type literal: ``typeLiteral`` (allowed syntax is prefix function, class, package or module followed with qualified name of declaration)")));
}

Boolean findCandidatesInModuleLiteral(ArrayList<TestCandidate> candidates, String modName) {
    value mod = modules.list.find((Module m) => m.name == modName);
    if (exists mod) {
        findCandidatesInModule(candidates, mod);
        return true;
    }
    return false;
}

Boolean findCandidatesInPackageLiteral(ArrayList<TestCandidate> candidates, String pkgName) {
    value pgk = findPackage(pkgName);
    if (exists pgk) {
        findCandidatesInPackage(candidates, pgk);
        return true;
    }
    return false;
}

Boolean findCandidatesInClassLiteral(ArrayList<TestCandidate> candidates, String fqn) {
    Integer? pkgDelimiter = fqn.firstInclusion("::");
    if (exists pkgDelimiter) {
        String pkgName = fqn[0 .. pkgDelimiter - 1];
        String className = fqn[pkgDelimiter + 2 ...];
        if (exists pkg = findPackage(pkgName)) {
            ClassDeclaration? classDecl = pkg.getMember<ClassDeclaration>(className);
            if (exists classDecl) {
                findCandidatesInClass(candidates, classDecl);
                return true;
            }
        }
    }
    return false;
}

Boolean findCandidatesInFunctionLiteral(ArrayList<TestCandidate> candidates, String fqn) {
    Integer? pkgDelimiter = fqn.firstInclusion("::");
    if (exists pkgDelimiter) {
        String pkgName = fqn[0 .. pkgDelimiter - 1];
        if (exists pkg = findPackage(pkgName)) {
            String rest = fqn[pkgDelimiter + 2 ...];
            Integer? memberDelimiter = rest.firstInclusion(".");
            if (exists memberDelimiter) {
                String className = rest[0 .. memberDelimiter - 1];
                String methodName = rest[memberDelimiter + 1 ...];
                ClassDeclaration? classDecl = pkg.getMember<ClassDeclaration>(className);
                if (exists classDecl) {
                    FunctionDeclaration? funcDecl = classDecl.getMemberDeclaration<FunctionDeclaration>(methodName);
                    if (exists funcDecl) {
                        findCandidatesInFunction(candidates, funcDecl, classDecl);
                        return true;
                    }
                }
            } else {
                String fceName = rest;
                FunctionDeclaration? funcDecl = pkg.getMember<FunctionDeclaration>(fceName);
                if (exists funcDecl) {
                    findCandidatesInFunction(candidates, funcDecl);
                    return true;
                }
            }
        }
    }
    return false;
}

Boolean findCandidatesInFullQualifiedName(ArrayList<TestCandidate> candidates, String fqn) {
    Integer? pkgDelimiter = fqn.firstInclusion("::");
    if (exists pkgDelimiter) {
        value pkgName = fqn[0 .. pkgDelimiter - 1];
        value rest = fqn[pkgDelimiter + 2 ...];
        if (exists pkg = findPackage(pkgName)) {
            Integer? memberDelimiter = rest.firstInclusion(".");
            if (exists memberDelimiter) {
                String className = rest[0 .. memberDelimiter - 1];
                String methodName = rest[memberDelimiter + 1 ...];
                ClassDeclaration? classDecl = pkg.getMember<ClassDeclaration>(className);
                if (exists classDecl) {
                    FunctionDeclaration? funcDecl = classDecl.getMemberDeclaration<FunctionDeclaration>(methodName);
                    if (exists funcDecl) {
                        findCandidatesInFunction(candidates, funcDecl, classDecl);
                        return true;
                    }
                }
            } else {
                value decl = pkg.getMember<FunctionDeclaration|ClassDeclaration>(rest);
                if (is FunctionDeclaration decl) {
                    findCandidatesInFunction(candidates, decl);
                    return true;
                } else if (is ClassDeclaration decl) {
                    findCandidatesInClass(candidates, decl);
                    return true;
                }
            }
        }
    } else {
        if (findCandidatesInPackageLiteral(candidates, fqn)) {
            return true;
        }
    }
    return false;
}

Package? findPackage(String pkgName) {
    for(m in modules.list) {
        if( pkgName.startsWith(m.name) ) {
            if( exists p = m.findPackage(pkgName)) {
                return p;
            }
        }
    }
    return null;
}

A? findAnnotation<out A>(FunctionDeclaration funcDecl, ClassDeclaration? classDecl)
        given A satisfies Annotation {
    variable value a = funcDecl.annotations<A>()[0];
    if (!(a exists)) {
        if (exists classDecl) {
            a = findAnnotations<A>(classDecl)[0];
            if (!(a exists)) {
                a = classDecl.containingPackage.annotations<A>()[0];
                if (!(a exists)) {
                    a = classDecl.containingModule.annotations<A>()[0];
                }
            }
        } else {
            a = funcDecl.containingPackage.annotations<A>()[0];
            if (!(a exists)) {
                a = funcDecl.containingModule.annotations<A>()[0];
            }
        }
    }
    return a;
}

A[] findAnnotations<out A>(ClassDeclaration classDecl)
        given A satisfies Annotation {
    value annotationBuilder = ArrayList<A>();
    variable ClassDeclaration? declVar = classDecl;
    while (exists decl = declVar) {
        annotationBuilder.addAll(decl.annotations<A>());
        declVar = decl.extendedType?.declaration;
    }
    return annotationBuilder.sequence();
}

IdentitySet<DefaultTestRunner> runningRunners = IdentitySet<DefaultTestRunner>();