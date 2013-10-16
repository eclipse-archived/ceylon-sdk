import ceylon.language.meta.declaration {
    FunctionDeclaration,
    ClassDeclaration
}

"Describes a test, or a group of tests, can be arranged in a tree."
shared interface TestDescription {

    "The user friendly name of this test."
    shared formal String name;

    "The program element declaration of this test, if one exists."
    shared formal <ClassDeclaration|FunctionDeclaration>? declaration;

    "The children of this test, if any."
    shared formal TestDescription[] children;

}