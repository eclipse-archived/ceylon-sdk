import ceylon.language {LanguageException = Exception}

by "Matej Lazar"
shared class Exception(String description, LanguageException? cause = null) 
        extends LanguageException(description, cause) {}
