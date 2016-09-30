import ceylon.test {
    ...
}

shared StringBuilder callbackLogger = StringBuilder();

shared variable Boolean beforeTestRun1Exception = false;
shared variable Boolean beforeTest1Exception = false;
shared variable Boolean beforeTest2Exception = false;
shared variable Boolean afterTestRun1Exception = false;
shared variable Boolean afterTest1Exception = false;
shared variable Boolean afterTest2Exception = false;

shared variable TestWithCallbacks? testWithCallbacksInstanceInBefore = null;
shared variable TestWithCallbacks? testWithCallbacksInstanceInAfter = null;
shared variable TestWithCallbacks? testWithCallbacksInstanceInTest = null;


beforeTestRun
shared void beforeTestRun1() {
    callbackLogger.append("beforeTestRun1").appendNewline();
    if( beforeTestRun1Exception ) {
        throw Exception("beforeTestRun1Exception");
    }
}

afterTestRun
shared void afterTestRun1() {
    callbackLogger.append("afterTestRun1").appendNewline();
    if( afterTestRun1Exception ) {
        throw Exception("afterTestRun1Exception");
    }
}

beforeTest
shared void beforeTest1() {
    callbackLogger.append("beforeTest1").appendNewline();
    if( beforeTest1Exception ) {
        throw Exception("beforeTest1Exception");
    }
}

afterTest
shared void afterTest1() {
    callbackLogger.append("afterTest1").appendNewline();
    if( afterTest1Exception ) {
        throw Exception("afterTest1Exception");
    }
}

test
shared void testWithCallbacks() {
    callbackLogger.append("testWithCallbacks").appendNewline();
}

shared class TestWithCallbacks() {
    
    beforeTest
    shared void beforeTest2() {
        callbackLogger.append("TestWithCallbacks.beforeTest2").appendNewline();
        testWithCallbacksInstanceInBefore = this;
        if( beforeTest2Exception ) {
            throw Exception("beforeTest2Exception");
        }
    }
    
    afterTest
    shared void afterTest2() {
        callbackLogger.append("TestWithCallbacks.afterTest2").appendNewline();
        testWithCallbacksInstanceInAfter = this;
        if( afterTest2Exception ) {
            throw Exception("afterTest2Exception");
        }
    }
    
    test
    shared void test2() {
        callbackLogger.append("TestWithCallbacks.test2").appendNewline();
        testWithCallbacksInstanceInTest = this;
    }
    
}