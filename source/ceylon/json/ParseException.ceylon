
"An Exception throw during parse errors"
shared class ParseException(String message, shared Integer line, shared Integer column) 
        extends Exception("``message`` at ``line``:``column`` (line:column)"){
}