import ceylon.test {
    TestListener,
    TestDescription,
    TestState,
    TestRunResult,
    TestResult,
    AssertionComparisonException,
    success,
    failure,
    error,
    ignored
}
import com.redhat.ceylon.test.eclipse {
    TestEvent {
        Type
    },
    TestElement {
        State
    },
    Util {
        convertThrowable,
        convertToArray
    }
}
import java.io {
    ObjectOutputStream
}
import java.util {
    ArrayList
}

shared class TestEventPublisher(ObjectOutputStream oos) satisfies TestListener {

    shared actual void testRunStart(TestDescription description) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_RUN_STARTED;
        event.testElement = convertTestDescription(description, true);
        publishEvent(event);
    }

    shared actual void testRunFinish(TestRunResult result) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_RUN_FINISHED;
        publishEvent(event);
    }

    shared actual void testStart(TestDescription description) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_STARTED;
        TestElement element = convertTestDescription(description, false);
        element.state = State.\iRUNNING;
        event.testElement = element;
        publishEvent(event);
    }

    shared actual void testFinish(TestResult result) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(result);
        publishEvent(event);
    }

    shared actual void testError(TestResult result) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(result);
        publishEvent(event);
    }

    shared actual void testIgnored(TestResult result) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(result);
        publishEvent(event);
    }

    TestElement convertTestDescription(TestDescription description, Boolean recursively) {
        TestElement testElement = TestElement();
        testElement.qualifiedName = description.name;
        testElement.state = State.\iUNDEFINED;

        if (recursively) {
            ArrayList<TestElement> children = ArrayList<TestElement>();
            for(child in description.children) {
                children.add(convertTestDescription(child, true));
            }
            if (!children.empty) {
                testElement.children = convertToArray(children);
            }
        }

        return testElement;
    }

    TestElement convertTestResult(TestResult result) {
        String? exc = convertThrowable(result.exception);
        TestElement testElement = TestElement();
        testElement.qualifiedName = result.description.name;
        testElement.state = convertTestState(result.state);
        testElement.exception = exc; 
        testElement.elapsedTimeInMilis = result.elapsedTime;

        if (is AssertionComparisonException ace = result.exception) {
            testElement.expectedValue = ace.expectedValue;
            testElement.actualValue = ace.actualValue;
        }

        return testElement;
    }

    State convertTestState(TestState testState) {
        switch(testState)
            case(success) { 
                return State.\iSUCCESS; 
            }
            case(failure) { 
                return State.\iFAILURE; 
            }
            case(error) { 
                return State.\iERROR; 
            }
            case(ignored) { 
                return State.\iIGNORED; 
            }
    }

    void publishEvent(TestEvent event) {
        oos.writeObject(event);
        oos.flush();
    }

}