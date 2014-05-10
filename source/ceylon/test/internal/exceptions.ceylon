import ceylon.language.meta {
    type
}

"Thrown when test is ignored."
shared class IgnoreException(reason) extends Exception(reason) {
    
    "Reason why the test is ignored."
    shared String reason;
    
}

"Thrown when multiple exceptions occurs."
shared class MultipleFailureException(exceptions) extends Exception() {
    
    "The collected exceptions."
    shared Throwable[] exceptions;
    
    shared actual String message {
        value message = StringBuilder();
        message.append("There were ``exceptions.size`` exceptions:");
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
