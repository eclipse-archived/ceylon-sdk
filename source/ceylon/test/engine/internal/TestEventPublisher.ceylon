/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.engine {
    AssertionComparisonError
}

class TestEventPublisher(void publishEvent(String json)) satisfies TestListener {
    
    shared actual void testRunStarted(TestRunStartedEvent e) {
        value json = "{\"event\":\"testRunStarted\", \"element\":``convertTestDescription(e.description)``}";
        publishEvent(json);
    }
    
    shared actual void testRunFinished(TestRunFinishedEvent e) {
        value json = "{\"event\":\"testRunFinished\"}";
        publishEvent(json);
    }
    
    shared actual void testStarted(TestStartedEvent e) {
        value json = "{\"event\":\"testStarted\", \"element\":``convertTestDescription(e.description, false, "running")``}";
        publishEvent(json);
    }
    
    shared actual void testFinished(TestFinishedEvent e) {
        value json = "{\"event\":\"testFinished\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    shared actual void testError(TestErrorEvent e) {
        value json = "{\"event\":\"testError\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    shared actual void testSkipped(TestSkippedEvent e) {
        value json = "{\"event\":\"testSkipped\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    shared actual void testAborted(TestAbortedEvent e) {
        value json = "{\"event\":\"testAborted\", \"element\":``convertTestResult(e.result)``}";
        publishEvent(json);
    }
    
    StringBuilder convertTestDescription(TestDescription description, Boolean includeChildren = true, String state = "undefined", StringBuilder json = StringBuilder()) {
        json.append("{");
        json.append("\"name\":\"``escape(description.name)``\", ");
        json.append("\"state\":\"``state``\", ");
        if( exists variant = description.variant ) {
            json.append("\"variant\":\"``escape(variant)``\", ");
        }
        if( exists variantIndex = description.variantIndex ) {
            json.append("\"variantIndex\":``variantIndex``, ");
        }
        json.append("\"children\":[");
        if(includeChildren) {
            if (!description.children.empty) {
                for (child in description.children) {
                    convertTestDescription(child, includeChildren, state, json);
                    json.append(", ");
                }
                json.deleteTerminal(2);
            }
        }
        json.append("]");
        json.append("}");
        return json;
    }
    
    StringBuilder convertTestResult(TestResult result, StringBuilder json = StringBuilder()) {
        json.append("{");
        json.append("\"name\":\"``escape(result.description.name)``\", ");
        if( exists variant = result.description.variant ) {
            json.append("\"variant\":\"``escape(variant)``\", ");
        }
        if( exists variantIndex = result.description.variantIndex ) {
            json.append("\"variantIndex\":``variantIndex``, ");
        }
        json.append("\"state\":\"``escape(result.state.string)``\", ");
        json.append("\"combined\":``result.combined``, ");
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
