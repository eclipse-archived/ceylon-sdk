/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    ArrayList
}
import ceylon.language.meta {
    type
}
import ceylon.language.meta.model {
    Class,
    ClassModel,
    ClassOrInterface
}
import ceylon.test.engine {
    AssertionComparisonError,
    MultipleFailureException
}


"Throws an [[AssertionError]] to fail a test."
throws (`class AssertionError`, "always")
shared void fail(
    "The message describing the problem."
    String? message = null) {
    throw AssertionError(message else "assertion failed");
}


"Fails the test if the _condition_ is false."
throws (`class AssertionError`, "When _condition_ is false.")
shared void assertTrue(
    "The condition to be checked."
    Boolean condition,
    "The message describing the problem."
    String? message = null) {
    if (!condition) {
        throw AssertionError(message else "assertion failed: expected true");
    }
}


"Fails the test if the _condition_ is true."
throws (`class AssertionError`, "When _condition_ is true.")
shared void assertFalse(
    "The condition to be checked."
    Boolean condition,
    "The message describing the problem."
    String? message = null) {
    if (condition) {
        throw AssertionError(message else "assertion failed: expected false");
    }
}


"Fails the test if the given _value_ is not null."
throws (`class AssertionError`, "When _val_ is not null.")
shared void assertNull(
    "The value to be checked."
    Anything val,
    "The message describing the problem."
    String? message = null) {
    if (exists val) {
        throw AssertionError(message else "assertion failed: expected null, but was ``val``");
    }
}


"Fails the test if the given _value_ is null."
throws (`class AssertionError`, "When _val_ is null.")
shared void assertNotNull(
    "The value to be checked."
    Anything val,
    "The message describing the problem."
    String? message = null) {
    if (!val exists) {
        throw AssertionError(message else "assertion failed: expected not null");
    }
}


"Fails the test if the given values are not equal according to the given compare function."
throws (`class AssertionComparisonError`, "When _actual_ != _expected_.")
shared void assertEquals(
    "The actual value to be checked."
    Anything actual,
    "The expected value."
    Anything expected,
    "The message describing the problem."
    String? message = null,
    "The compare function."
    Boolean compare(Anything val1, Anything val2) => equalsCompare(actual, expected)) {
    if (!compare(actual, expected)) {
        value actualText = nullSafeString(actual);
        value expectedText = nullSafeString(expected);
        value exceptionMessage = "`` message else "assertion failed" ``: expected <``expectedText``> but was <``actualText``>";
        throw AssertionComparisonError(exceptionMessage, actualText, expectedText);
    }
}


"Fails the test if the given values are equal according to the given compare function."
throws (`class AssertionError`, "When _actual_ == _unexpected_.")
shared void assertNotEquals(
    "The actual value to be checked."
    Anything actual,
    "The expected value."
    Anything unexpected,
    "The message describing the problem."
    String? message = null,
    "The compare function."
    Boolean compare(Anything val1, Anything val2) => equalsCompare(actual, unexpected)) {
    if (compare(actual, unexpected)) {
        value actualText = nullSafeString(actual);
        value exceptionMessage = "`` message else "assertion failed" ``: expected not equals <``actualText``>";
        throw AssertionError(exceptionMessage);
    }
}


"Verify all given assertions and any failures will be reported together.
 
 Example:
 
     assertAll([
         () => assertEquals(agent.id, \"007\"),
         () => assertEquals(agent.firstName, \"James\"),
         () => assertEquals(agent.lastName, \"Bond\")]);
 
"
throws (`class MultipleFailureException`, "When any assertiones fails.")
shared void assertAll(
    "The group of assertions."
    Anything()[] assertions,
    "The message describing the problem."
    String? message = null) {
    value failures = ArrayList<AssertionError>();
    for (assertion in assertions) {
        try {
            assertion();
        } catch (AssertionError failure) {
            failures.add(failure);
        }
    }
    if (!failures.empty) {
        value description = message else "assertions failed (``failures.size`` of ``assertions.size``) :";
        throw MultipleFailureException(failures.sequence(), description);
    }
}


"Fails the test if expected exception isn't thrown.
 
 Example:
 
     assertThatException(() => gandalf.castLightnings()).hasType(\`NotEnoughMagicPowerException\`);
 
"
throws (`class AssertionError`, "When _exceptionSource()_ doesn't throw an Exception")
shared ExceptionAssert assertThatException(
    "The checked exception or callback which should throw exception."
    Throwable|Anything() exceptionSource) {
    if (is Throwable exception = exceptionSource) {
        return ExceptionAssert(exception);
    } else {
        assert (is Anything() exceptionCallback = exceptionSource);
        try {
            exceptionCallback();
        } catch (Throwable exception) {
            return ExceptionAssert(exception);
        }
        throw AssertionError("assertion failed: expected exception will be thrown");
    }
}


"An assertions applicable to exceptions, see [[assertThatException]]."
shared class ExceptionAssert(
    "The exception to be checked."
    Throwable exception) {
    
    "Verifies that the actual _exception_ has expected type."
    throws (`class AssertionError`, "When _exception_ hasn't expected type.")
    shared ExceptionAssert hasType(
        "The expected type or type predicate."
        Class<Throwable,Nothing>|Boolean(ClassModel<Throwable,Nothing>) typeCondition) {
        if (is Class<Throwable,Nothing> typeCondition) {
            value actualType = type(exception);
            if (actualType != typeCondition) {
                throw AssertionError("assertion failed: expected exception with type ``typeCondition``, but has ``actualType``");
            }
        } else {
            if (!typeCondition(type(exception))) {
                throw AssertionError("assertion failed: expected exception with different type than ``type(exception)``");
            }
        }
        return this;
    }
    
    "Verifies that the actual _exception_ has expected message."
    throws (`class AssertionError`, "When _exception_ hasn't expected message.")
    shared ExceptionAssert hasMessage(
        "The expected message or message predicate."
        String|Boolean(String) messageCondition) {
        switch (messageCondition)
        case (String) {
            if (exception.message != messageCondition) {
                throw AssertionError("assertion failed: expected exception with message ``messageCondition``, but has ``exception.message``");
            }
        }
        case (Boolean(String)) {
            if (!messageCondition(exception.message)) {
                throw AssertionError("assertion failed: expected different exception message than ``exception.message``");
            }
        }
        return this;
    }
    
    "Verifies that the actual _exception_ does not have a cause."
    throws (`class AssertionError`, "When _exception_ has some cause.")
    shared ExceptionAssert hasNoCause() {
        if (exists cause = exception.cause) {
            throw AssertionError("assertion failed: expected exception without cause, but has ``cause``");
        }
        return this;
    }
}

"Fails the test if the given value does not satisfy the provided ClassOrInterface"
throws (`class AssertionError`, "When _actual_ does not satisfy _expected_.")
shared void assertIs(
        "The actual value to be checked."
        Anything val,
        "The class or interface to be satisfied."
        ClassOrInterface<> expected,
        "The message describing the problem."
        String? message = null){
    if (!expected.typeOf(val)){
        type(val);
        throw AssertionError(message else "assertion failed: expected type not satisfied. expected <``expected``> but was <``type(val)``>");
    }
}


"Compares two things. Returns true if both are null or both are non-null and 
 are the same according to [[Object.equals]]."
Boolean equalsCompare(Anything obj1, Anything obj2) {
    if (exists obj1) {
        if (exists obj2) {
            return obj1 == obj2;
        }
    }
    return obj1 exists == obj2 exists;
}


String nullSafeString(Anything obj) {
    if (exists obj) {
        return obj.string;
    }
    return "null";
}
