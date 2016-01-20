import ceylon.test.event {
    ...
}
import ceylon.test {
    TestRunner,
    TestDescription,
    TestRunResult,
    TestListener
}
import ceylon.test.annotation {
    TestExtensionAnnotation
}
import ceylon.language.meta.declaration {
    ClassDeclaration
}
import ceylon.test.engine.internal {
    TestEventEmitter
}
import ceylon.collection {
    ArrayList,
    HashMap,
    MutableMap,
    MutableList
}
import java.util.concurrent {
    Executors
}
import java.lang {
    Runnable
}

"Represents a context in which a test is executed, it's used by [[TestExecutor]]."
shared class TestExecutionContext {
    
    "The current test runner."
    shared TestRunner runner;
    
    "The summary result of the test run."
    shared TestRunResult result;
    
    "The current test description."
    shared TestDescription description;
    
    "The parent context."
    shared TestExecutionContext? parent;
    
    MutableList<TestExtension> extensionList;
    MutableMap<ClassDeclaration, TestExtension> extensionCache;
    TaskExecutor taskExecutor;
    
    "Constructor for root context."
    shared new root(TestRunner runner, TestRunResult result, Boolean async = false) {
        this.runner = runner;
        this.result = result;
        this.description = runner.description;
        this.parent = null;
        this.extensionList = ArrayList<TestExtension>();
        this.extensionCache = HashMap<ClassDeclaration,TestExtension>();
        this.taskExecutor = async then AsyncTaskExecutor() else TaskExecutor();
    }
    
    "Constructor for child context."
    new child(TestExecutionContext parent, TestDescription description) {
        this.runner = parent.runner;
        this.result = parent.result;
        this.parent = parent;
        this.description = description;
        this.extensionCache = parent.extensionCache;
        this.extensionList = findExtensions(description, parent.extensions<TestExtension>(), extensionCache);
        this.taskExecutor = parent.taskExecutor;
    }
    
    "Create child context for given test."
    shared TestExecutionContext childContext(TestDescription description)
            => child(this, description);
    
    "Schedule test tasks for execution."
    shared void execute(<Anything()|{Anything()*}>* tasks)
            => taskExecutor.execute(*tasks);
    
    "Returns implementation of test listener, which is firing registered listeners."
    shared TestListener fire()
            => TestEventEmitter(extensions<TestListener>());
    
    "Register given test extension."
    shared void registerExtension(TestExtension* extensions)
            => extensionList.addAll(extensions);
    
    "Returns all registered instances of test extensions with given type."
    shared TestExtensionType[] extensions<TestExtensionType>() given TestExtensionType satisfies TestExtension {
        return collect<TestExtensionType>().sort((e1, e2) => e1.order <=> e2.order).sequence();
    }
    
    "Returns last registered instance of test extension with given type."
    shared TestExtensionType extension<TestExtensionType>() given TestExtensionType satisfies TestExtension {
        assert(exists e = collect<TestExtensionType>().last);
        return e;
    }
    
    {TestExtensionType*} collect<TestExtensionType>() given TestExtensionType satisfies TestExtension
            => (parent?.collect<TestExtensionType>() else {}).chain(extensionList.narrow<TestExtensionType>());
    
}


MutableList<TestExtension> findExtensions(TestDescription description, {TestExtension*} existingExtensions, MutableMap<ClassDeclaration, TestExtension> extensionCache) {
    value extensionClasses = ArrayList<ClassDeclaration>();
    if( exists f = description.functionDeclaration ) {
        f.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
        if( f.toplevel ) {
            f.containingPackage.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
            f.containingModule.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
        }
    } 
    else if( exists c = description.classDeclaration ) {
        variable ClassDeclaration? var = c;
        while(exists c2 = var) {
            c2.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
            var = c2.extendedType?.declaration;                
        }
        c.containingPackage.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
        c.containingModule.annotations<TestExtensionAnnotation>().each((e) => extensionClasses.addAll(e.extensions));
    }

    
    value extensions = ArrayList<TestExtension>();
    for (extensionClass in extensionClasses) {
        if (extensionCache.keys.contains(extensionClass)) {
            assert (exists extension = extensionCache.get(extensionClass));
            if( !existingExtensions.contains(extension) ) {
                extensions.add(extension);
            }
        }
        else {
            if( extensionClass.anonymous ) {
                assert(is TestExtension extension = extensionClass.objectValue?.get());
                if( !existingExtensions.contains(extension) ) {
                    extensions.add(extension);
                }
            }
            else {
                assert (is TestExtension extension = extensionClass.instantiate());
                extensionCache.put(extensionClass, extension);
                if( !existingExtensions.contains(extension) ) {
                    extensions.add(extension);
                }
            }
        }
    }
    
    return extensions;
}


class TaskExecutor() {
    
    shared ArrayList<Anything()> taskStack = ArrayList<Anything()>();
    
    shared void execute(<Anything()|{Anything()*}>* tasks) {
        value startExecutionLoop = taskStack.empty;
        for (task in tasks.sequence().reversed) {
            if (is Anything() task) {
                taskStack.add(task);
            }
            if (is {Anything()*} task) {
                taskStack.addAll(task.sequence().reversed);
            }
        }
        if (startExecutionLoop) {
            executionLoop();
        }
    }
    
    shared default void executionLoop() {
        while(exists task = taskStack.pop()) {
            task();
        }
    }
    
}

native
class AsyncTaskExecutor() extends TaskExecutor() {
    
    shared actual void executionLoop() {
        if (exists task = taskStack.pop()) {
            executeTask(() {
                try {
                    task();
                } finally {
                    executionLoop();
                }
            });
        } else {
            shutdown();
        }
    }
    
    native
    void executeTask(Anything() task);
    
    native
    void shutdown();

}


native("jvm")
class AsyncTaskExecutor() extends TaskExecutor() {
    
    value jexecutor = Executors.newSingleThreadExecutor();
    
    native("jvm")
    void executeTask(Anything() task) {
        object jrunnable satisfies Runnable {
            shared actual void run() {
                task();
            }
        }
        jexecutor.submit(jrunnable);
    }
    
    native("jvm")
    void shutdown() {
        jexecutor.shutdown();
    }
    
}


native("js")
class AsyncTaskExecutor() extends TaskExecutor() {
    
    native("js")
    void executeTask(Anything() task) {
        dynamic {
            setTimeout(task, 1);
        }
    }
    
    native("js")
    void shutdown() {
        // noop
    }
    
}