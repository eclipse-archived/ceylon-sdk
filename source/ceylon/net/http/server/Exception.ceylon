by("Matej Lazar")
shared class ServerException(String description, Throwable? cause = null) 
        extends Exception(description, cause) {}
