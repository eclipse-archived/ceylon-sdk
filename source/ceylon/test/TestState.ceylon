"The result state of test execution."
shared class TestState 
        of success | failure | error | skipped | aborted 
        satisfies Comparable<TestState> {
    
    String name;
    Integer priority;
    
    "A test state is _success_, if it complete normally (that is, does not throw an exception)."
    shared new success {
        name = "success";
        priority = 30;
    }
    
    "A test state is _failure_, if it propagates an [[AssertionError]]."
    shared new failure {
        name = "failure";
        priority = 40;
    }
    
    "A test state is _error_, if it propagates any exception which is not an [[AssertionError]]."
    shared new error {
        name = "error";
        priority = 50;
    }
    
    "A test state is _skipped_, if its condition is not fullfiled, see [[ceylon.test.engine.spi::TestCondition]] or e.g [[ignore]] annotation."
    shared new skipped {
        name = "skipped";
        priority = 10;
    }

    "A test state is _aborted_, if its assumption is not met, see e.g. [[assumeTrue]] and it propagates an [[ceylon.test.engine::TestAbortedException]]."
    shared new aborted {
        name = "aborted";
        priority = 20;
    }
    
    string => name;
    
    compare(TestState other) => priority <=> other.priority;

}