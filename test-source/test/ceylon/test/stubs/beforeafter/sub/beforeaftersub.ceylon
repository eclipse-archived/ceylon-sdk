import test.ceylon.test.stubs.beforeafter {
    ...
}
import ceylon.test { afterTest, beforeTest, test }

beforeTest
shared void barToplevelBefore() {
    callbackLogger.append("barToplevelBefore").appendNewline();
}

afterTest
shared void barToplevelAfter() {
    callbackLogger.append("barToplevelAfter").appendNewline();
}
 

shared class BarWithCallbacks() extends FooWithCallbacks() {
    
    beforeTest
    shared void barBefore() {
        callbackLogger.append("BarWithCallbacks.barBefore").appendNewline();
    }
    
    afterTest
    shared void barAfter() {
        callbackLogger.append("BarWithCallbacks.barAfter").appendNewline();
    }
    
    test
    shared void bar() {
        callbackLogger.append("BarWithCallbacks.bar").appendNewline();
    }
    
}