import ceylon.language.meta.declaration {
    ...
}
import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}
import test.ceylon.test.stubs.bugs {
    ...
}

test
shared void shouldVerifyToplevelNonTestMethod() {
    TestRunResult runResult = createTestRunner([`bugFunctionWithoutTestAnnotation`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `bugFunctionWithoutTestAnnotation`;
        message = "function test.ceylon.test.stubs.bugs::bugFunctionWithoutTestAnnotation should be annotated with test or testSuite";
    };
}

test
shared void shouldVerifyToplevelNonVoidMethod() {
    TestRunResult runResult = createTestRunner([`bugFunctionWithReturnType`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `bugFunctionWithReturnType`;
        message = "function test.ceylon.test.stubs.bugs::bugFunctionWithReturnType should be void";
    };
}

test
shared void shouldVerifyToplevelMethodWithParameters() {
    TestRunResult runResult = createTestRunner([`function bugFunctionWithParameter`, `function bugFunctionWithParameters`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 2;
    };
    assertResultContains {
        runResult;
        index = 0; 
        state = error;
        source = `bugFunctionWithParameter`;
        message = "function test.ceylon.test.stubs.bugs::bugFunctionWithParameter should have no parameters";
    };
    assertResultContains {
        runResult;
        index = 1; 
        state = error;
        source = `bugFunctionWithParameters`;
        message = "function test.ceylon.test.stubs.bugs::bugFunctionWithParameters should have no parameters";
    };
}
    
test
shared void shouldVerifyToplevelMethodWithTypeParameters() {
    TestRunResult runResult = createTestRunner([`function bugFunctionWithTypeParameter`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `function bugFunctionWithTypeParameter`;
        message = "function test.ceylon.test.stubs.bugs::bugFunctionWithTypeParameter should have no type parameters";
    };
}

test
shared void shouldVerifyMethodFromInterface() {
    TestRunResult runResult = createTestRunner([`function BugInterface.f`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `function BugInterface.f`;
        message = "function test.ceylon.test.stubs::BugInterface.f should be toplevel function or class method";
    };
}

test
shared void shouldVerifyAbstractClass() {
    TestRunResult runResult = createTestRunner([`BugAbstractClass.f`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugAbstractClass.f`;
        message = "class test.ceylon.test.stubs.bugs::BugAbstractClass should not be abstract";
    };
}

test
shared void shouldVerifyToplevelClass() {
    TestRunResult runResult = createTestRunner([`function BugClassOuter.BugClassInner.f`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugClassOuter.BugClassInner.f`;
        message = "class test.ceylon.test.stubs.bugs::BugClassOuter.BugClassInner should be toplevel";
    };
}

test
shared void shouldVerifyClassWithParameter() {
    TestRunResult runResult = createTestRunner([`class BugClassWithParameter`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugClassWithParameter.f`;
        message = "class test.ceylon.test.stubs.bugs::BugClassWithParameter should have no parameters";
    };
}

test
shared void shouldVerifyClassWithTypeParameter() {
    TestRunResult runResult = createTestRunner([`class BugClassWithTypeParameter`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `function BugClassWithTypeParameter.f`;
        message = "class test.ceylon.test.stubs.bugs::BugClassWithTypeParameter should have no type parameters";
    };
}

test
shared void shouldVerifyInvalidTypeLiteral1() {
    TestRunResult runResult = createTestRunner(["function foo.bar::baz"]).run();
    
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

test
shared void shouldVerifyInvalidTypeLiteral2() {
    TestRunResult runResult = createTestRunner(["class foo.bar::Baz"]).run();
    
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

test
shared void shouldVerifyInvalidTestSuite1() {
    TestRunResult runResult = createTestRunner([`bugTestSuiteWithInterface`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        name = `interface BugInterface`.qualifiedName;
        message = "declaration test.ceylon.test.stubs::BugInterface is invalid test suite source";
    };
}

test
shared void shouldVerifyInvalidTestSuite2() {
    TestRunResult runResult = createTestRunner([`bugTestSuiteWithEmptyPackage`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        message = "test suite test.ceylon.test.stubs::bugTestSuiteWithEmptyPackage does not contains any tests";
    };
}