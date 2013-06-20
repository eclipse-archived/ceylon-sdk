"Thrown when assertion failures"
shared class AssertException(String message) extends Exception(message, null) {
}

"Subclass of `AssertException` for assertion failures dues to two things 
     not being equal"
//TODO see(assertEquals)
shared class AssertComparisonException(String message, expectedValue, actualValue) extends AssertException(message) {
    
    shared String expectedValue;
    shared String actualValue;
    
}

"Fails the test."
shared void fail(String message = "Failed") {
    throw AssertException(message);
}

"Fails the test if the assertion is false"
shared void assertTrue(Boolean condition, String message = " expected " + condition.string)  {
    if (!condition) {
        throw AssertException("assertion failed: `` message ``");
    }
}

"Fails the test if the assertion is true"
shared void assertFalse(Boolean condition, String message = " expected " + condition.string) {
    if (condition) {
        throw AssertException("assertion failed: `` message ``");
    }
}

"Fails the test if the given result is not null"
shared void assertNull(Object? got, String message = "") {
    if (exists got) {
        throw AssertException("accertion failed: expected null but got `` got ``");
    }
}

"Fails the test if the given result is null"
shared void assertNotNull(Object? got, String message = "") {
    if (! got exists) {
        throw AssertException("accertion failed: expected not null but got null");
    }
}

"Fails the test if the given objects are not equal according to the given `compare` function."
shared void assertEquals(Object? expected, Object? actual, String? message = null,
        Boolean compare(Object? expected, Object? actual) => nullSafeEquals(expected, actual)) {
    if (!compare(expected,actual)) {
        value expectedText = nullSafeString(expected);
        value actualText = nullSafeString(actual);
        if (exists message) {
            throw AssertComparisonException("assertion failed: `` expectedText `` != `` actualText ``: \"`` message ``\"", expectedText, actualText);
        }
        else {
            throw AssertComparisonException("assertion failed: `` expectedText `` != `` actualText ``", expectedText, actualText);
        }
    }
}

"Fails the test if the given objects are equal according to the given `compare` function."
shared void assertNotEquals(Object? expected, Object? actual, String? message = null,
        Boolean compare(Object? expected, Object? actual) => nullSafeEquals(expected, actual)) {
    if (compare(expected,actual)) {
        value expectedText = nullSafeString(expected);
        value actualText = nullSafeString(actual);
        if (exists message) {
            throw AssertComparisonException("assertion failed: `` expectedText `` == `` actualText ``: \"`` message ``\"", expectedText, actualText);
        }
        else {
            throw AssertComparisonException("assertion failed: `` expectedText `` == `` actualText ``", expectedText, actualText);
        }
    }
}

"A compare function for `assertEquals()`"
//TODO see(assertEquals)
Boolean nullSafeEquals(Object? expected, Object? actual) {
    if (exists expected) {
        if (exists actual) {
            return expected==actual;
        }
    }
    return actual exists == expected exists;
}

"Like `Object.string`, but handles null."
String nullSafeString(Object? obj) {
    if (exists obj) {
        return obj.string;
    }
    return "null";
}