import ceylon.language.meta.declaration {
    Declaration
}

"Describes a test, or a group of tests, can be arranged in a tree."
shared class TestDescription(name, declaration = null, children = []) {

    "The user friendly name of this test."
    shared String name;

    "The program element of this test, if one exists."
    shared Declaration? declaration;

    "The children of this test, if any."
    shared TestDescription[] children;

    shared actual String string => name;

}