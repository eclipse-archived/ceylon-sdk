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

    shared actual void testRunStart(TestRunStartEvent event) => log(event);

    shared actual void testRunFinish(TestRunFinishEvent event) => log(event);

    shared actual void testStart(TestStartEvent event) => log(event);

    shared actual void testFinish(TestFinishEvent event) => log(event);

    shared actual void testIgnore(TestIgnoreEvent event) => log(event);

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