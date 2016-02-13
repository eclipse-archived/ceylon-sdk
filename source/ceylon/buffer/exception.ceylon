shared class BufferException(description = null, cause = null)
        extends Exception(description, cause) {
    String? description;
    Throwable? cause;
}

shared class BufferUnderflowException(description = null, cause = null)
        extends BufferException(description, cause) {
    String? description;
    Throwable? cause;
}

shared class BufferOverflowException(description = null, cause = null)
        extends BufferException(description, cause) {
    String? description;
    Throwable? cause;
}
