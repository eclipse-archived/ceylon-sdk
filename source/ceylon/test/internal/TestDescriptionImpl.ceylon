import ceylon.language.meta.declaration {
    FunctionDeclaration,
    ClassDeclaration
}
import ceylon.test {
    TestDescription
}

class TestDescriptionImpl(name, declaration = null, children = []) satisfies TestDescription {

    shared actual String name;

    shared actual <ClassDeclaration|FunctionDeclaration>? declaration;

    shared actual TestDescription[] children;

    shared actual String string => name;

}