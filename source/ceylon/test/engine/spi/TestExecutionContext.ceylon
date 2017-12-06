/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test.event {
    ...
}
import ceylon.test {
    TestRunner,
    TestDescription,
    TestRunResult,
    TestListener
}
import ceylon.test.engine.internal {
    TestEventEmitter
}
import ceylon.collection {
    ArrayList,
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
    TestExtensionResolver extensionResolver;
    TaskExecutor taskExecutor;
    
    "Constructor for root context."
    shared new root(TestRunner runner, TestRunResult result, TestExtensionResolver extensionResolver, Boolean async = false) {
        this.runner = runner;
        this.result = result;
        this.description = runner.description;
        this.parent = null;
        this.extensionList = ArrayList<TestExtension>();
        this.extensionResolver = extensionResolver;
        this.taskExecutor = async then AsyncTaskExecutor() else TaskExecutor();
    }
    
    "Constructor for child context."
    new child(TestExecutionContext parent, TestDescription description) {
        this.runner = parent.runner;
        this.result = parent.result;
        this.parent = parent;
        this.description = description;
        this.extensionResolver = parent.extensionResolver;
        this.extensionList = initExtensions(description, parent.extensions<TestExtension>(), extensionResolver);
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
        return collect<TestExtensionType>().sort(increasing).sequence();
    }
    
    "Returns last registered instance of test extension with given type."
    shared TestExtensionType extension<TestExtensionType>() given TestExtensionType satisfies TestExtension {
        assert(exists e = collect<TestExtensionType>().last);
        return e;
    }
    
    {TestExtensionType*} collect<TestExtensionType>() given TestExtensionType satisfies TestExtension
            => (parent?.collect<TestExtensionType>() else {}).chain(extensionList.narrow<TestExtensionType>());
    
}


MutableList<TestExtension> initExtensions(TestDescription description, {TestExtension*} existingExtensions, TestExtensionResolver extensionResolver) {
    value extensions = ArrayList<TestExtension>();
    extensions.addAll(extensionResolver.resolveExtensions<TestExtension>(description));
    extensions.removeAll(existingExtensions);
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