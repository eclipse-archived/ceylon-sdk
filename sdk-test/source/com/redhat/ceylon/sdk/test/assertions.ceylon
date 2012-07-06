shared class AssertionFailed(String message) extends Exception(message, null) {}

doc "Fails the test."
shared void fail(String message = "Failed") {
    throw AssertionFailed(message);
}

doc "Fails the test if the assertion is false"
shared void assertTrue(Boolean assertion, String message=", expected " + assertion.string)  {
    if (!assertion) {
        throw AssertionFailed("assertion failed: " message "");
    }
}

doc "Fails the test if the assertion is true"
shared void assertFalse(Boolean assertion, String message=", expected " + assertion.string) {
    if (assertion) {
        throw AssertionFailed("assertion failed: " message "");
    }
}

String str(Object? obj) {
    if (exists obj) {
        return obj.string;
    }
    return "null";
}

Boolean nullSafeEquals(Object? expected, Object? got) {
    if (exists expected) {
        if (exists got) {
            return expected==got;
        }
    }
    return exists got == exists expected;
}

doc "Fails the test if the two objects are not equal"
shared void assertEquals(Object? expected, Object? got, String? message=null,
        Boolean compare(Object? expected, Object? got) = nullSafeEquals) {
    if (!compare(expected,got)) {
        if (exists message) {
            throw AssertionFailed("assertion failed: " str(expected) " != " str(got) ": \"" message "\"");
        }
        else {
            throw AssertionFailed("assertion failed: " str(expected) " != " str(got) "");
        }
    }
}

doc "Fails the test if the given result is not null"
shared void assertNull(Object? got, String message = "") {
    if (exists got) {
        throw AssertionFailed("accertion failed: expected null but got " got "");
    }
}

doc "Fails the test if the given result is null"
shared void assertNotNull(Object? got, String message = "") {
    if (! got exists) {
        throw AssertionFailed("accertion failed: expected not null but got null");
    }
}