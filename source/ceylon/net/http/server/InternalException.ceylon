by("Matej Lazar")
shared class InternalException(String description, 
    Exception? cause = null) 
        extends ServerException(description, cause) {}
