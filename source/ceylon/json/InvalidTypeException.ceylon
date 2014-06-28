import ceylon.language { String }

"Represents the failure of a type conversion.  
 An instance is typically thrown as a result of trying to 
 get and convert an [[Object]] member or [[Array]] element 
 which cannot be converted to the requested or implied type."
shared class InvalidTypeException(String message) 
        extends Exception(message){
}