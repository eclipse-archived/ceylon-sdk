import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

import test.ceylon.test.stubs {
    ...
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