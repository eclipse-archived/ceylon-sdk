import ceylon.language.meta.declaration {
    ClassDeclaration,
    OpenClassOrInterfaceType
}
import ceylon.test {
    createTestRunner,
    error,
    TestDescription
}

void runTestVerifying() {
    runTests(
        `shouldVerifyToplevelNonTestMethod`,
        `shouldVerifyToplevelNonVoidMethod`,
        `shouldVerifyToplevelMethodWithParameters`,
        `shouldVerifyToplevelMethodWithTypeParameters`,
        `shouldVerifyAbstractClass`,
        `shouldVerifyAbstractClass2`,
        `shouldVerifyAnonymousClass`,
        `shouldVerifyClassWithParameter`,
        `shouldVerifyClassWithTypeParameter`,
        `shouldVerifyClassWithoutTestableMethods`,
        `shouldVerifyInvalidTypeLiteral1`,
        `shouldVerifyInvalidTypeLiteral2`
    );
}

void shouldVerifyToplevelNonTestMethod() {
    value runResult = createTestRunner([`methodWithoutTestAnnotation`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `methodWithoutTestAnnotation`;
        message = "should be annotated with test";
    };
}

void shouldVerifyToplevelNonVoidMethod() {
    value runResult = createTestRunner([`methodWithReturnType`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `methodWithReturnType`;
        message = "should be void";
    };
}

void shouldVerifyToplevelMethodWithParameters() {
    value runResult = createTestRunner{
           sources=[`package test.ceylon.test`];
           filter=(TestDescription d)=>d.name.containsAny({"methodWithParameter", "methodWithParameters"});}.run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 2;
    };
    assertResultContains {
        runResult;
        index = 0; 
        state = error;
        source = `methodWithParameter`;
        message = "should have no parameters";
    };
    assertResultContains {
        runResult;
        index = 1; 
        state = error;
        source = `methodWithParameters`;
        message = "should have no parameters";
    };
}

void shouldVerifyToplevelMethodWithTypeParameters() {
    value runResult = createTestRunner{
           sources=[`package test.ceylon.test`];
           filter=(TestDescription d)=>d.name.contains("methodWithTypeParameter");}.run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `function methodWithTypeParameter`;
        message = "should have no type parameters";
     };
}

void shouldVerifyAbstractClass() {
    value runResult = createTestRunner([`ClassAbstract`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassAbstract`;
        message = "should not be abstract";
     };
}

void shouldVerifyAbstractClass2() {
    value runResult = createTestRunner([`ClassAbstract.methodFoo`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassAbstract`;
        message = "should not be abstract";
     };
}

void shouldVerifyAnonymousClass() {
    assert(is OpenClassOrInterfaceType objectFooType = `objectFoo`.declaration.openType);
    assert(is ClassDeclaration objectFooDecl = objectFooType.declaration);
    
    value runResult = createTestRunner([objectFooDecl]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = objectFooDecl;
        message = "should not be anonymous";
    };
}

void shouldVerifyClassWithParameter() {
    value runResult = createTestRunner{
           sources=[`package test.ceylon.test`];
           filter=(TestDescription d)=>d.name.contains("ClassWithParameter");}.run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithParameter`;
        message = "should have no parameters";
     };
}

void shouldVerifyClassWithTypeParameter() {
    value runResult = createTestRunner{
           sources=[`package test.ceylon.test`];
           filter=(TestDescription d)=>d.name.contains("ClassWithTypeParameter");}.run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `class ClassWithTypeParameter`;
        message = "should have no type parameters";
     };
}

void shouldVerifyClassWithoutTestableMethods() {
    value runResult = createTestRunner([`ClassWithoutTestableMethods`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithoutTestableMethods`;
        message = "should have testable methods";
     };
}

void shouldVerifyInvalidTypeLiteral1() {
    value runResult = createTestRunner(["function foo.bar::baz"]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        message = "invalid type literal: function foo.bar::baz";
    };
}

void shouldVerifyInvalidTypeLiteral2() {
    value runResult = createTestRunner(["class foo.bar::Baz"]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        message = "invalid type literal: class foo.bar::Baz";
    };
}