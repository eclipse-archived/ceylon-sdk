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
shared void shouldRunTestSuite1() {
    value root = createTestRunner([`bazSuite`]).description;
    
    assert(root.children.size==1,
           exists bazSuiteDesc = root.children[0],
           bazSuiteDesc.children.size == 2,
           exists barDesc = bazSuiteDesc.children[0],
           barDesc.children.size == 2,
           exists fooDesc = bazSuiteDesc.children[1],
           bazSuiteDesc.declaration?.equals(`function bazSuite`) else false,
           barDesc.declaration?.equals(`class Bar`) else false,
           fooDesc.declaration?.equals(`function foo`) else false); 
}

test
shared void shouldRunTestSuite2() {
    value result = createTestRunner([`bazSuite`]).run();
    assertResultCounts {
        result;
        successCount = 3;
    };
    assertResultContains {
        result;
        index = 0;
        state = success;
        source = `Bar.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = success;
        source = `Bar.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = success;
        source = `Bar`;
    };
    assertResultContains {
        result;
        index = 3;
        state = success;
        source = `foo`;
    };
    assertResultContains {
        result;
        index = 4;
        state = success;
        source = `bazSuite`;
    };
}

test
shared void shouldRunTestSuiteNested1() {
    value root = createTestRunner([`bazSuiteNested`]).description;
    
    assert(root.children.size==1,
           exists bazSuiteNestedDesc = root.children[0],
           bazSuiteNestedDesc.children.size == 1,
           exists bazSuiteDesc = bazSuiteNestedDesc.children[0],
           bazSuiteDesc.children.size == 2,
           exists barDesc = bazSuiteDesc.children[0],
           barDesc.children.size == 2,
           exists fooDesc = bazSuiteDesc.children[1],
           bazSuiteNestedDesc.declaration?.equals(`function bazSuiteNested`) else false,
           bazSuiteDesc.declaration?.equals(`function bazSuite`) else false,
           barDesc.declaration?.equals(`class Bar`) else false,
           fooDesc.declaration?.equals(`function foo`) else false);
}

test
shared void shouldRunTestSuiteNested2() {
    value result = createTestRunner([`bazSuiteNested`]).run();
    assertResultCounts {
        result;
        successCount = 3;
    };
    assertResultContains {
        result;
        index = 0;
        state = success;
        source = `Bar.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = success;
        source = `Bar.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = success;
        source = `Bar`;
    };
    assertResultContains {
        result;
        index = 3;
        state = success;
        source = `foo`;
    };
    assertResultContains {
        result;
        index = 4;
        state = success;
        source = `bazSuite`;
    };
    assertResultContains {
        result;
        index = 5;
        state = success;
        source = `bazSuiteNested`;
    };
}