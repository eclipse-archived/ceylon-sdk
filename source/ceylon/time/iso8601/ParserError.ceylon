"Represents the problem that occurred while parsing. It can be recovered from _message_ field"
shared class ParserError( message ) {
    shared String message;

    shared actual Boolean equals( Object other ) {
        if ( is ParserError other ) {
            return message == other.message; 
        }
        return false;
    }

    shared actual Integer hash {
        return message.hash;
    }

}