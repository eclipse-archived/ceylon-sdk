import ceylon.language {LanguageException = Exception}

by("Matej Lazar")
shared class Exception(String description, Throwable? cause = null) 
        extends LanguageException(description, cause) {}
