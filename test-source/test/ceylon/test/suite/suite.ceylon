import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

import test.ceylon.test.stubs {
    ...
}
import test.ceylon.test.stubs.bugs {
    bugTestSuiteWithInvalidSource,
    bugTestSuiteWithTestAnnotation
}

test
void shouldRunTestSuite1() {
    value root = createTestRunner([`bazSuite`]).description;
    
    assert(root.children.size==1,
           exists bazSuiteDesc = root.children[0],
           bazSuiteDesc.children.size == 2,
           exists barDesc = bazSuiteDesc.children[0],
           barDesc.children.size == 2,
           exists fooDesc = bazSuiteDesc.children[1],
           bazSuiteDesc.functionDeclaration?.equals(`function bazSuite`) else false,
           barDesc.classDeclaration?.equals(`class Bar`) else false,
           fooDesc.functionDeclaration?.equals(`function foo`) else false); 
}

test
void shouldRunTestSuite2() {
    value result = createTestRunner([`bazSuite`]).run();
    assertResultCounts {
        result;
        successCount = 3;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `Bar.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `Bar.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = TestState.success;
        source = `Bar`;
    };
    assertResultContains {
        result;
        index = 3;
        state = TestState.success;
        source = `foo`;
    };
    assertResultContains {
        result;
        index = 4;
        state = TestState.success;
        source = `bazSuite`;
    };
}

test
void shouldRunTestSuiteNested1() {
    value root = createTestRunner([`bazSuiteNested`]).description;
    
    assert(root.children.size==1,
           exists bazSuiteNestedDesc = root.children[0],
           bazSuiteNestedDesc.children.size == 1,
           exists bazSuiteDesc = bazSuiteNestedDesc.children[0],
           bazSuiteDesc.children.size == 2,
           exists barDesc = bazSuiteDesc.children[0],
           barDesc.children.size == 2,
           exists fooDesc = bazSuiteDesc.children[1],
           bazSuiteNestedDesc.functionDeclaration?.equals(`function bazSuiteNested`) else false,
           bazSuiteDesc.functionDeclaration?.equals(`function bazSuite`) else false,
           barDesc.classDeclaration?.equals(`class Bar`) else false,
           fooDesc.functionDeclaration?.equals(`function foo`) else false);
}

test
void shouldRunTestSuiteNested2() {
    value result = createTestRunner([`bazSuiteNested`]).run();
    assertResultCounts {
        result;
        successCount = 3;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `Bar.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `Bar.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = TestState.success;
        source = `Bar`;
    };
    assertResultContains {
        result;
        index = 3;
        state = TestState.success;
        source = `foo`;
    };
    assertResultContains {
        result;
        index = 4;
        state = TestState.success;
        source = `bazSuite`;
    };
    assertResultContains {
        result;
        index = 5;
        state = TestState.success;
        source = `bazSuiteNested`;
    };
}

test
void shouldVerifyTestSuiteWithInvalidSource() {
    value result = createTestRunner([`bugTestSuiteWithInvalidSource`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.error;
        message = "declaration test.ceylon.test.stubs.bugs::i is invalid test suite source (only functions, classes, packages and modules are allowed)";
    };    
}

test
void shouldVerifyTestSuiteWithTestAnnotation() {
    value result = createTestRunner([`bugTestSuiteWithTestAnnotation`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.error;
        source = `bugTestSuiteWithTestAnnotation`;
        message = "function test.ceylon.test.stubs.bugs::bugTestSuiteWithTestAnnotation is annotated ambiguously, there can be only one of these annotation test or testSuite";
    };    
}