import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}
import test.ceylon.test.stubs.ignored {
    ...
}

test
shared void shouldDetectIgnoreOnFunction() {
    value result = createTestRunner([`fooWithIgnore`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        result;
        state = ignored;
        source = `fooWithIgnore`;
        message = "ignore function foo";
    };
}

test
shared void shouldDetectIgnoreOnClass() {
    value result = createTestRunner([`BarWithIgnore`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        ignoreCount = 2;
    };
    assertResultContains {
        result;
        index = 0;
        state = ignored;
        source = `BarWithIgnore.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = ignored;
        source = `BarWithIgnore.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = ignored;
        source = `BarWithIgnore`;
    };
}

test
shared void shouldDetectIgnoreOnPackage() {
    value result = createTestRunner([`bazInIgnoredPackage`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        result;
        state = ignored;
        source = `bazInIgnoredPackage`;
        message = "ignore whole package";
    };
}

test
shared void shouldDetectInheritedIgnore() {
    value result = createTestRunner([`BarWithInheritedIgnore.bar3`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = ignored;
        source = `BarWithInheritedIgnore.bar3`;
    };
}