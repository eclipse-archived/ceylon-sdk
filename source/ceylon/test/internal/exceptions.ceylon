import ceylon.language.meta {
    type
}

class IgnoreException(shared String reason) extends Exception(reason) {
}

class MultipleFailureException(shared Exception[] exceptions) extends Exception() {
    
    shared actual String message {
        value message = StringBuilder();
        message.append("There were ``exceptions.size`` exceptions:");
        for(Exception e in exceptions) {
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
