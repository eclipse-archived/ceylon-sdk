import ceylon.language.meta.declaration {
    ...
}

"Describes a test, or a group of tests, can be arranged in a tree."
shared class TestDescription(name, functionDeclaration = null, classDeclaration = null, children = []) {

    "The user friendly name of this test."
    shared String name;

    "The function declaration of this test, if one exists."
    shared FunctionDeclaration? functionDeclaration;

    "The class declaration, which is container of this test, if one exists."
    shared ClassDeclaration? classDeclaration;

    "The children of this test, if any."
    shared TestDescription[] children;

    shared actual String string => name;

}