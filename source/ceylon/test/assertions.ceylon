import ceylon.language.meta {
    type
}
import ceylon.language.meta.model {
    Class,
    ClassModel
}

"Thrown to indicate that two values which should have been \"the 
 same\" (according to some comparison function) were in fact 
 different."
see(`function assertEquals`, `function assertNotEquals`)
shared class AssertionComparisonException(
    "The message describing the problem." 
    String message, 
    actualValue, expectedValue) 
        extends AssertionException(message) {

    "The actual string value."
    shared String actualValue;

    "The expected string value."
    shared String expectedValue;

}

"Throws an [[AssertionException]] to fail a test."
throws(`class AssertionException`, "always")
shared void fail("The message describing the problem." String? message = null) {
    throw AssertionException(message else "assertion failed");
}

"Fails the test if the _condition_ is false."
throws(`class AssertionException`, "When _condition_ is false.")
shared void assertTrue(
        "The condition to be checked." Boolean condition, 
        "The message describing the problem." 
        String? message = null)  {
    if (!condition) {
        throw AssertionException(message else "assertion failed: expected true");
    }
}

"Fails the test if the _condition_ is true."
throws(`class AssertionException`, "When _condition_ is true.")
shared void assertFalse(
        "The condition to be checked."
        Boolean condition, 
        "The message describing the problem."
        String? message = null) {
    if (condition) {
        throw AssertionException(message else "assertion failed: expected false");
    }
}

"Fails the test if the given _value_ is not null."
throws(`class AssertionException`, "When _val_ is not null.")
shared void assertNull(
        "The value to be checked." Object? val, 
        "The message describing the problem." String? message = null) {
    if (exists val) {
        throw AssertionException(message else "assertion failed: expected null, but was ``val``");
    }
}

"Fails the test if the given _value_ is null."
throws(`class AssertionException`, "When _val_ is null.")
shared void assertNotNull(
        "The value to be checked." Object? val, 
        "The message describing the problem." String? message = null) {
    if (! val exists) {
        throw AssertionException(message else "assertion failed: expected not null");
    }
}

"Fails the test if the given values are not equal according to the given compare function."
throws(`class AssertionComparisonException`, "When _actual_ != _expected_.")
shared void assertEquals(
        "The actual value to be checked." Object? actual, 
        "The expected value." Object? expected, 
        "The message describing the problem." String? message = null, 
        "The compare function." Boolean compare(Object? val1, Object? val2) => equalsCompare(actual, expected)) {
    if (!compare(actual, expected)) {
        value actualText = nullSafeString(actual);
        value expectedText = nullSafeString(expected);
        value exceptionMessage = "``message else "assertion failed"``: ``actualText`` != ``expectedText``";
        throw AssertionComparisonException(exceptionMessage, actualText, expectedText);
    }
}

"Fails the test if the given values are equal according to the given compare function."
throws(`class AssertionComparisonException`, "When _actual_ == _expected_.")
shared void assertNotEquals(
        "The actual value to be checked." Object? actual, 
        "The expected value." Object? expected, 
        "The message describing the problem." String? message = null, 
        "The compare function." Boolean compare(Object? val1, Object? val2) => equalsCompare(actual, expected)) {
    if (compare(actual, expected)) {
        value actualText = nullSafeString(actual);
        value expectedText = nullSafeString(expected);
        value exceptionMessage = "``message else "assertion failed"``: ``actualText`` == ``expectedText``";
        throw AssertionComparisonException(exceptionMessage, actualText, expectedText);
    }
}

"Fails the test if expected exception isn't thrown."
throws(`class AssertionException`, "When _exceptionSource()_ doesn't throw an Exception")
shared ExceptionAssert assertThatException(
        "The checked exception or callback which should throw exception." 
        Exception|Anything() exceptionSource) {
    if(is Exception exception = exceptionSource) {
        return ExceptionAssert(exception);
    }
    else {
        assert(is Anything() exceptionCallback = exceptionSource);
        try {
            exceptionCallback();
        } catch(Exception exception) {
            return ExceptionAssert(exception);
        }
        throw AssertionException("assertion failed: expected exception will be thrown");
    }
}

"An assertions applicable to exceptions, see [[assertThatException]]."
shared class ExceptionAssert(
        "The exception to be checked." Exception exception) {

    "Verifies that the actual _exception_ has expected type."
    throws(`class AssertionException`, "When _exception_ hasn't expected type.")
    shared ExceptionAssert hasType(
            "The expected type or type predicate." Class<Exception,Nothing>|Boolean(ClassModel<Exception,Nothing>) typeCondition) {
        if(is Class<Exception,Nothing> typeCondition) {
            value actualType = type(exception);
            if(actualType != typeCondition) {
                throw AssertionException("assertion failed: expected exception with type ``typeCondition``, but has ``actualType``");
            }
        } else if ( is Boolean(ClassModel<Exception,Nothing>) typeCondition) {
            if( !typeCondition(type(exception)) ) {
                throw AssertionException("assertion failed: expected exception with different type than ``type(exception)``");
            }
        }
        return this;
    }

    "Verifies that the actual _exception_ has expected message."
    throws(`class AssertionException`, "When _exception_ hasn't expected message.")
    shared ExceptionAssert hasMessage(
            "The expected message or message predicate." String|Boolean(String) messageCondition) {
        switch(messageCondition)
        case(is String) {
            if(exception.message != messageCondition) {
                throw AssertionException("assertion failed: expected exception with message ``messageCondition``, but has ``exception.message``");
            }
        }
        case(is Boolean(String)) {
            if(!messageCondition(exception.message)) {
                throw AssertionException("assertion failed: expected different exception message than ``exception.message``");
            }
        }
        return this;
    }

    "Verifies that the actual _exception_ does not have a cause."
    throws(`class AssertionException`, "When _exception_ has some cause.")
    shared ExceptionAssert hasNoCause() {
        if(exists cause = exception.cause) {
            throw AssertionException("assertion failed: expected exception without cause, but has ``cause``");
        }
        return this;
    }

}

"Compares two things. Returns true if both are null or both are non-null and 
 are the same according to [[Object.equals]]."
shared Boolean equalsCompare(Object? obj1, Object? obj2) {
    if (exists obj1) {
        if (exists obj2) {
            return obj1 == obj2;
        }
    }
    return obj1 exists == obj2 exists;
}

String nullSafeString(Object? obj) {
    if (exists obj) {
        return obj.string;
    }
    return "null";
}