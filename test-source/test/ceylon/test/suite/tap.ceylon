import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}
import ceylon.test.reporter {
    TapReporter
}

test
shared void shouldWriteTapWhenSuccess() {
    assertTap([`foo`], """TAP version 13
                          1..1
                          ok 1 - test.ceylon.test.stubs::foo 
                          """);
}

test
shared void shouldWriteTapWhenFailure() {
    assertTap([`fooThrowingAssertion`], """TAP version 13
                                           1..1
                                           not ok 1 - test.ceylon.test.stubs::fooThrowingAssertion 
                                             ---
                                           """);
}

test
shared void shouldWriteTapWhenIgnored() {
    assertTap([`fooWithIgnore`], """TAP version 13
                                    1..1
                                    not ok 1 - test.ceylon.test.stubs::fooWithIgnore # SKIP skipped
                                      ---
                                      reason: ignore function foo
                                      ...
                                    """);
}

test
shared void shouldWriteTapWhenError() {
    assertTap([`fooWithoutTestAnnotation`], """TAP version 13
                                               1..1
                                               not ok 1 - test.ceylon.test.stubs::fooWithoutTestAnnotation 
                                               """);
}

void assertTap(TestSource[] sources, String expectedProtocol) {
    StringBuilder protocolBuilder = StringBuilder();
    void printProtocol(String line) => protocolBuilder.append(line).appendNewline();

    createTestRunner(sources, [TapReporter(printProtocol)]).run();

    if( !protocolBuilder.string.contains(expectedProtocol) ) {
        throw AssertionComparisonError("", protocolBuilder.string, expectedProtocol);
    }
}