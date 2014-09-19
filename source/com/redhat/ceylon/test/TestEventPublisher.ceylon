import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared class TestEventPublisher(void publishEvent(String json)) satisfies TestListener {
    
    shared actual void testRunStart(TestRunStartEvent e) {
        value json = "{\"event\":\"testRunStart\", \"element\":``convertTestDescription(e.description)``}";
        publishEvent(json);
    }
    
    shared actual void testRunFinish(TestRunFinishEvent e) {
        value json = "{\"event\":\"testRunFinish\"}";
        publishEvent(json);
    }
    
    shared actual void testStart(TestStartEvent e) {
        value json = "{\"event\":\"testStart\", \"element\":{\"name\":\"``e.description.name``\", \"state\":\"running\"}}";
        publishEvent(json);
    }
    
    shared actual void testFinish(TestFinishEvent e) {
        value json = "{\"event\":\"testFinish\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    shared actual void testError(TestErrorEvent e) {
        value json = "{\"event\":\"testError\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    shared actual void testIgnore(TestIgnoreEvent e) {
        value json = "{\"event\":\"testIgnore\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    StringBuilder convertTestDescription(TestDescription description, StringBuilder json = StringBuilder()) {
        json.append("{");
        json.append("\"name\":\"``escape(description.name)``\", ");
        json.append("\"state\":\"undefined\", ");
        json.append("\"children\":[");
        if (!description.children.empty) {
            for (child in description.children) {
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
        json.append("\"name\":\"``escape(result.description.name)``\", ");
        json.append("\"state\":\"``escape(result.state.string)``\", ");
        json.append("\"elapsedTime\":``result.elapsedTime``, ");
        if (exists e = result.exception) {
            json.append("\"exception\":\"");
            void appendStackTrace(String s) => json.append(escape(s));
            printStackTrace(e, appendStackTrace);
            json.append("\", ");
        }
        if (is AssertionComparisonError ace = result.exception) {
            json.append("\"expectedValue\":\"``escape(ace.expectedValue)``\", ");
            json.append("\"actualValue\":\"``escape(ace.actualValue)``\", ");
        }
        json.deleteTerminal(2);
        json.append("}");
        return json;
    }
    
    String escape(String s) {
        value sb = StringBuilder();
        for (c in s) {
            if (c == '\'' || c == '"' || c == '\\' || c == '/' ||
                c == '\{END OF TRANSMISSION}') {
                sb.appendCharacter('\\').appendCharacter(c);
            } else if (c == '\b') {
                sb.appendCharacter('\\').appendCharacter('b');
            } else if (c == '\f') {
                sb.appendCharacter('\\').appendCharacter('f');
            } else if (c == '\n') {
                sb.appendCharacter('\\').appendCharacter('n');
            } else if (c == '\r') {
                sb.appendCharacter('\\').appendCharacter('r');
            } else if (c == '\t') {
                sb.appendCharacter('\\').appendCharacter('t');
            } else {
                sb.appendCharacter(c);
            }
        }
        return sb.string;
    }
}
