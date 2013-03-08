import ceylon.language {LanguageException = Exception}

by "Matej Lazar"
shared class InternalException(String description, LanguageException? cause = null) 
        extends Exception(description, cause) {}
