import ceylon.language.meta {
    type
}
import ceylon.test {
    ...
}

"Event fired by [[TestListener.testRunStart]]."
shared class TestRunStartEvent(runner, description) {

    "The current test runner."
    shared TestRunner runner;

    "The description of all tests to be run."
    shared TestDescription description;

    shared actual String string => toString(this);

}

"Event fired by [[TestListener.testRunFinish]]."
shared class TestRunFinishEvent(runner, result) {

    "The current test runner."
    shared TestRunner runner;

    "The summary result of the test run."
    shared TestRunResult result;

    shared actual String string => toString(this);

}

"Event fired by [[TestListener.testStart]]."
shared class TestStartEvent(description, instance = null) {

    "The description of the test."
    shared TestDescription description;

    "The instance on which the test method is invoked, if exists."
    shared Object? instance;

    shared actual String string => toString(this, description);

}

"Event fired by [[TestListener.testFinish]]."
shared class TestFinishEvent(result, instance = null) {

    "The result of the test."
    shared TestResult result;

    "The instance on which the test method is invoked, if exists."
    shared Object? instance;

    shared actual String string => toString(this, result);

}

"Event fired by [[TestListener.testIgnore]]."
shared class TestIgnoreEvent(result) {

    "The result of the test."
    shared TestResult result;

    shared actual String string => toString(this, result);

}

"Event fired by [[TestListener.testError]]."
shared class TestErrorEvent(result) {

    "The result of the test."
    shared TestResult result;

    shared actual String string => toString(this, result);

}

"Event fired by [[TestListener.testExclude]]."
shared class TestExcludeEvent(description) {

    "The description of the test."
    shared TestDescription description;

    shared actual String string => toString(this, description);

}

String toString(Object obj, Object?* attributes) {
    return type(obj).declaration.name + (!attributes.empty then "[" + ", ".join({ for (a in attributes) a?.string else "null" }) + "]" else "");
}