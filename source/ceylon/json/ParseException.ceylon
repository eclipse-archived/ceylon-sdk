"An Exception throw during parse errors"
shared class ParseException(String message,
    "The error line (1-based)" 
    shared Integer line, 
    "The error column (1-based)" 
    shared Integer column) 
        extends Exception("``message`` at ``line``:``column`` (line:column)"){
}