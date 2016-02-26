import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared StringBuilder bazTestListenerLog = StringBuilder();
shared variable Integer bazTestListenerCounter = 0;

shared abstract class BazTestListenerAbstract() satisfies TestListener {
    
    shared actual void testRunStarted(TestRunStartedEvent event) => log(event);
    
    shared actual void testRunFinished(TestRunFinishedEvent event) => log(event);
    
    shared actual void testStarted(TestStartedEvent event) => log(event);
    
    shared actual void testFinished(TestFinishedEvent event) => log(event);
    
    shared actual void testSkipped(TestSkippedEvent event) => log(event);
    
    shared actual void testError(TestErrorEvent event) => log(event);
    
    shared default void log(Object event) => bazTestListenerLog.append(event.string).appendNewline();
    
}

shared class BazTestListener() extends BazTestListenerAbstract() {
    
    bazTestListenerCounter++;

}

shared class BazTestListenerWithOrder() extends BazTestListenerAbstract() {
    
    order = 100;
    
    log(Object event) => super.log("!! ``event``");
    
}


test
testExtension(`class BazTestListener`)
shared void bazWithCustomListener() {
}

testExtension(`class BazTestListener`)
shared class BazWithCustomListener() {
    
    test
    testExtension(`class BazTestListener`)
    shared void baz1() {}
    
}

shared object bazAnonymousTestListener extends BazTestListenerAbstract() {    
}

test
testExtension(`class bazAnonymousTestListener`)
shared void bazWithAnonymousTestListener() {
}

test
testExtension(`class BazTestListener`, `class BazTestListenerWithOrder`)
shared void bazWithCustomOrderedListeners1() {
}

test
testExtension(`class BazTestListenerWithOrder`, `class BazTestListener`)
shared void bazWithCustomOrderedListeners2() {
}