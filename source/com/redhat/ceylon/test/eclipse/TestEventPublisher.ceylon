import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
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

    shared actual void testRunStart(TestRunStartEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_RUN_STARTED;
        event.testElement = convertTestDescription(e.description, true);
        publishEvent(event);
    }

    shared actual void testRunFinish(TestRunFinishEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_RUN_FINISHED;
        publishEvent(event);
    }

    shared actual void testStart(TestStartEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_STARTED;
        TestElement element = convertTestDescription(e.description, false);
        element.state = State.\iRUNNING;
        event.testElement = element;
        publishEvent(event);
    }

    shared actual void testFinish(TestFinishEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(e.result);
        publishEvent(event);
    }

    shared actual void testError(TestErrorEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(e.result);
        publishEvent(event);
    }

    shared actual void testIgnore(TestIgnoreEvent e) {
        TestEvent event = TestEvent();
        event.type = Type.\iTEST_FINISHED;
        event.testElement = convertTestResult(e.result);
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