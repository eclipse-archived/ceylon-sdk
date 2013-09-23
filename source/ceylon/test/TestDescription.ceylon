"Describes a test, or a group of tests. 
 Groups of tests can be arranged in a tree."
shared interface TestDescription {

    "The user friendly name of this test."
    shared formal String name;

    "The source program element of this test, if one exists."
    shared formal TestSource? source;

    "The children of this test, if any."
    shared formal TestDescription[] children;

}