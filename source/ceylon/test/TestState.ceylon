"The result state of test execution."
shared class TestState
    of success | failure | error | ignored | aborted {
    
    String name;
    
    "A test state is _success_, if it complete normally (that is, does not throw an exception)."
    shared new success {
        name = "success";
    }
    
    "A test state is _failure_, if it propagates an [[AssertionError]]."
    shared new failure {
        name = "failure";
    }
    
    "A test state is _error_, if it propagates any exception which is not an [[AssertionError]]."
    shared new error {
        name = "error";
    }
    
    "A test state is _ignored_, if it is marked with [[ignore]] annotation."
    shared new ignored {
        name = "ignored";
    }

    "A test state is _aborted_, if its assumption is not met, see e.g. [[assumeTrue]] and it propagates an [[ceylon.test.core::TestAbortedException]]."
    shared new aborted {
        name = "aborted";
    }
    
    string => name;

}