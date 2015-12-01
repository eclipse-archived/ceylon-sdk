import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared StringBuilder bazTestListenerLog = StringBuilder();
shared variable Integer bazTestListenerCounter = 0;

shared class BazTestListener() satisfies TestListener {
    
    bazTestListenerCounter++;

    shared actual void testRunStarted(TestRunStartedEvent event) => log(event);

    shared actual void testRunFinished(TestRunFinishedEvent event) => log(event);

    shared actual void testStarted(TestStartedEvent event) => log(event);

    shared actual void testFinished(TestFinishedEvent event) => log(event);

    shared actual void testSkipped(TestSkippedEvent event) => log(event);

    shared actual void testError(TestErrorEvent event) => log(event);

    void log(Object event) => bazTestListenerLog.append(event.string).appendNewline();

}

test
testListeners({`class BazTestListener`})
shared void bazWithCustomListener() {
}

testListeners({`class BazTestListener`})
shared class BazWithCustomListener() {
    
    test
    testListeners({`class BazTestListener`})
    shared void baz1() {}
    
}

shared object bazAnonymousTestListener extends BazTestListener() {    
}

test
testListeners({`class bazAnonymousTestListener`})
shared void bazWithAnonymousTestListener() {
}