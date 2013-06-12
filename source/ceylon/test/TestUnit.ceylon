"A named piece of test code, and it's state."
shared class TestUnit(name, callable) {
    
    "The name of this test."
    shared String name;
    "The test code."
    shared Anything() callable;
    "The [[state|TestState]] of this unit."
    shared variable TestState state = undefined;
    "The exception thrown by this unit, if any."
    shared variable Exception? exception = null;
    "The time it took to execute this unit."
    shared variable Integer elapsedTimeInMilis = -1;
    
}