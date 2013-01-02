doc "A named piece of test code, and it's state."
shared class TestUnit(name, callable) {
    
    doc "The name of this test."
    shared String name;
    doc "The test code."
    shared Void() callable;
    doc "The [[state|TestState]] of this unit."
    shared variable TestState state := undefined;
    doc "The exception thrown by this unit, if any."
    shared variable Exception? exception := null;
    doc "The time it took to execute this unit."
    shared variable Integer elapsedTimeInMilis := -1;
    
}