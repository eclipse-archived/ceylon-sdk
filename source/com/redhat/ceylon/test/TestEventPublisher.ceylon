import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared class TestEventPublisher(void publishEvent(String json)) satisfies TestListener {

    shared actual void testRunStart(TestRunStartEvent e) {
        value json = "{'event':'testRunStart', 'element':``convertTestDescription(e.description)``}";
        publishEvent(json);
    }

    shared actual void testRunFinish(TestRunFinishEvent e) {
        value json = "{'event':'testRunFinish'}";
        publishEvent(json);
    }

    shared actual void testStart(TestStartEvent e) {
        value json = "{'event':'testStart', 'element':{'name':``e.description.name``, 'state':'running'}}";
        publishEvent(json);
    }

    shared actual void testFinish(TestFinishEvent e) {
        value json = "{'event':'testFinish', 'element':``convertTestResult(e.result)``}";
        publishEvent(json);
    }

    shared actual void testError(TestErrorEvent e) {
        value json = "{'event':'testError', 'element':``convertTestResult(e.result)``}";
        publishEvent(json);
    }

    shared actual void testIgnore(TestIgnoreEvent e) {
        value json = "{'event':'testIgnore', 'element':``convertTestResult(e.result)``}";
        publishEvent(json);
    }

    StringBuilder convertTestDescription(TestDescription description, StringBuilder json = StringBuilder()) {
        json.append("{");
        json.append("'name':``description.name``, ");
        json.append("'state':'undefined', ");
        json.append("'children':[");
        if( !description.children.empty ) {
            for( child in description.children ) {
                convertTestDescription(child, json);
                json.append(", ");
            }
            json.deleteTerminal(2);
        }
        json.append("]");
        json.append("}");
        return json;
    }
    
    StringBuilder convertTestResult(TestResult result, StringBuilder json = StringBuilder()) {
        json.append("{");
        json.append("'name':'``result.description.name``', ");
        json.append("'state':'``result.state``', ");
        json.append("'elapsedTime':``result.elapsedTime``, ");
        if(exists e = result.exception) {
            json.append("'exception':'");
            void appendStackTrace(String s) => json.append(s);
            printStackTrace(e, appendStackTrace);
            json.append("', ");
        }
        if(is AssertionComparisonError ace = result.exception) {
            json.append("'expectedValue':'``ace.expectedValue``', ");
            json.append("'actualValue':'``ace.actualValue``', ");
        }
        json.deleteTerminal(2);
        json.append("}");
        return json;
    }

}