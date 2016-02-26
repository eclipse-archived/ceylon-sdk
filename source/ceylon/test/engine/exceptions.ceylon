import ceylon.language.meta {
    type
}
import ceylon.test {
    assertEquals,
    assertNotEquals
}


"Thrown to indicate that two values which should have been \"the 
 same\" (according to some comparison function) were in fact 
 different."
see (`function assertEquals`, `function assertNotEquals`)
shared class AssertionComparisonError(
    "The message describing the problem."
    String message,
    actualValue,
    expectedValue)
        extends AssertionError(message) {
    
    "The actual string value."
    shared String actualValue;
    
    "The expected string value."
    shared String expectedValue;
}


"Thrown when test is skipped."
shared class TestSkippedException(reason = null) extends Exception(reason) {
    
    "Reason why the test is skipped."
    shared String? reason;
    
}


"Thrown when the test assumption is not met, cause aborting of test execution."
shared class TestAbortedException(assumption = null) extends Exception(assumption) {
    
    "The message describing the assumption, which wasn't met."
    shared String? assumption;
    
}


"Thrown when multiple exceptions occurs."
shared class MultipleFailureException(exceptions, description = "multiple failures occurred (``exceptions.size``) :") extends Exception() {
    
    "The collected exceptions."
    shared Throwable[] exceptions;
    
    String description;
    
    shared actual String message {
        value message = StringBuilder();
        message.append(description);
        for (e in exceptions) {
            message.appendNewline();
            message.append("    ");
            message.append(type(e).declaration.qualifiedName);
            message.append("(");
            message.append(e.message);
            message.append(")");
        }
        return message.string;
    }
    
}
