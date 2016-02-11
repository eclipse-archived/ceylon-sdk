import ceylon.language.meta.declaration {
    ...
}

"Describes a test, or a group of tests, can be arranged in a tree."
shared class TestDescription {
    
    "The user friendly name of this test."
    shared String name;
    
    "The description of test variant in case, when test is executed multiple times, eg. with different argument values."
    shared String? variant;
    
    "The index of test variant in case, when test is executed multiple times, eg. with different argument values."
    shared Integer? variantIndex;
    
    "The function declaration of this test, if one exists."
    shared FunctionDeclaration? functionDeclaration;
    
    "The class declaration, which is container of this test, if one exists."
    shared ClassDeclaration? classDeclaration;
    
    "The children of this test, if any."
    shared TestDescription[] children;
    
    "Internal constructor."
    new create(String name, String? variant, Integer? variantIndex, FunctionDeclaration? functionDeclaration= null, ClassDeclaration? classDeclaration= null, TestDescription[] children= []) {
        this.name = name;
        this.variant = variant;
        this.variantIndex = variantIndex;
        this.functionDeclaration = functionDeclaration;
        this.classDeclaration = classDeclaration;
        this.children = children;
    }
    
    "Default constructor."
    shared new (String name, FunctionDeclaration? functionDeclaration= null, ClassDeclaration? classDeclaration= null, TestDescription[] children= [])
            extends create(name, null, null, functionDeclaration, classDeclaration, children) {}
    
    "Returns new description, derived from this one with specified variant."
    shared TestDescription forVariant(String variant, Integer variantIndex) {
        return create(name, variant, variantIndex, functionDeclaration, classDeclaration, children);
    }
    
    shared actual Boolean equals(Object that) {
        if (is TestDescription that) {
            return name == that.name
                    && equalsCompare(variant, that.variant)
                    && equalsCompare(variantIndex, that.variantIndex)
                    && equalsCompare(functionDeclaration, that.functionDeclaration)
                    && equalsCompare(classDeclaration, that.classDeclaration)
                    && children == that.children;
        }
        return false;
    }
    
    shared actual Integer hash => name.hash;
    
    shared actual String string => name + (variant else "");
    
}
