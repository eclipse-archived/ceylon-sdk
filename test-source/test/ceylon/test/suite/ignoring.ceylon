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
        skippedCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.skipped;
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
        skippedCount = 2;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.skipped;
        source = `BarWithIgnore.bar1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.skipped;
        source = `BarWithIgnore.bar2`;
    };
    assertResultContains {
        result;
        index = 2;
        state = TestState.skipped;
        source = `BarWithIgnore`;
    };
}

test
shared void shouldDetectIgnoreOnPackage() {
    value result = createTestRunner([`bazInIgnoredPackage`]).run();
    assertResultCounts {
        result;
        runCount = 0;
        skippedCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.skipped;
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
        skippedCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.skipped;
        source = `BarWithInheritedIgnore.bar3`;
    };
}