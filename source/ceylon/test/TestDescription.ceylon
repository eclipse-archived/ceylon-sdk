"Represent a description of the test or group of tests."
shared interface TestDescription {

    "The user friendly name of this test."
    shared formal String name;

    "The source program element of this test, if exists."
    shared formal TestSource? source;

    "The children of this test, if any."
    shared formal TestDescription[] children;

}