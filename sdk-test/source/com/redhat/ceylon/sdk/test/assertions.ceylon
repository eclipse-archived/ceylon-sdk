shared class AssertionFailed(String message) extends Exception(message, null) {}

doc "Fails the test."
shared void fail(String message = "Failed") {
    throw AssertionFailed(message);
}

doc "Fails the test if the assertion is false"
shared void assert(Boolean assertion, String message=", expected " + assertion.string) {
    if (!assertion) {
        throw AssertionFailed("assertion failed: " message "");
    }
}

// Simply because Stef's tests used assertTrue rather than assert
doc "Fails the test if the assertion is false"
shared void assertTrue(Boolean assertion, String message=", expected " + assertion.string) = assert;

doc "Fails the test if the assertion is true"
shared void assertFalse(Boolean assertion, String message=", expected " + assertion.string) {
    if (assertion) {
        throw AssertionFailed("assertion failed: " message "");
    }
}

Boolean nullSafeCompare(Object? a, Object? b){
    if(exists a){
        if(exists b){
            return a == b;
        }
        return false;
    }
    return !exists b;
}

String str(Object? obj) {
    if (exists obj) {
        return obj.string;
    }
    return "null";
}

doc "Fails the test if the two objects are not equal"
shared void assertEquals(Object? expected, Object? got,
        String message="",
        Callable<Boolean, Object?, Object?> compare = nullSafeCompare) {
    // TODO Use type params
    function cmp(Object? expected, Object? got) = compare;
    if (!cmp(expected,got)) {
        throw AssertionFailed("assertion failed: " str(expected) " != " str(got) ": \"" message "\"");
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