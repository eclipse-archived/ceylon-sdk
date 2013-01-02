shared class TestUnit(name, callable) {
    
    shared String name;
    shared Void() callable;
    shared variable TestState state := undefined;
    shared variable Exception? exception := null;
    shared variable Integer elapsedTimeInMilis := -1;
    
}