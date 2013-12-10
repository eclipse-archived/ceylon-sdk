import ceylon.test {
    ...
}

shared StringBuilder callbackLogger = StringBuilder();

shared variable Boolean fooToplevelBeforeException = false;
shared variable Boolean fooMemberBeforeException = false;
shared variable Boolean fooToplevelAfterException = false;
shared variable Boolean fooMemberAfterException = false;

shared variable FooWithCallbacks? fooWithCallbacksInstanceInBefore = null;
shared variable FooWithCallbacks? fooWithCallbacksInstanceInAfter = null;
shared variable FooWithCallbacks? fooWithCallbacksInstanceInTest = null; 

beforeTest
shared void fooToplevelBefore() {
    callbackLogger.append("fooToplevelBefore").appendNewline();
    if( fooToplevelBeforeException ) {
        throw Exception("fooToplevelBeforeException");
    }
}

afterTest
shared void fooToplevelAfter() {
    callbackLogger.append("fooToplevelAfter").appendNewline();
    if( fooToplevelAfterException ) {
        throw Exception("fooToplevelAfterException");
    }
}

test
shared void fooWithCallbacks() {
    callbackLogger.append("fooWithCallbacks").appendNewline();
}

shared class FooWithCallbacks() {
    
    beforeTest
    shared void fooBefore() {
        callbackLogger.append("FooWithCallbacks.fooBefore").appendNewline();
        fooWithCallbacksInstanceInBefore = this;
        if( fooMemberBeforeException ) {
            throw Exception("fooMemberBeforeException");
        }
    }
    
    afterTest
    shared void fooAfter() {
        callbackLogger.append("FooWithCallbacks.fooAfter").appendNewline();
        fooWithCallbacksInstanceInAfter = this;
        if( fooMemberAfterException ) {
            throw Exception("fooMemberAfterException");
        }
    }
    
    test
    shared void foo() {
        callbackLogger.append("FooWithCallbacks.foo").appendNewline();
        fooWithCallbacksInstanceInTest = this;
    }
    
}