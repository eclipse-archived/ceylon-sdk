"Thrown when a timeout occurs."
shared class TimeoutException(description = null, cause = null)
        extends Exception(description, cause) {
    "A description of the problem."
    String? description;
    "The underlying cause of this exception."
    Throwable? cause;
}

"Thrown when a acquire timeout occurs."
shared class AcquireTimeoutException(description = null, cause = null)
        extends Exception(description, cause) {
    "A description of the problem."
    String? description;
    "The underlying cause of this exception."
    Throwable? cause;
}

"Thrown when a thread is interrupted."
shared class InterruptedException(description = null, cause = null)
        extends Exception(description, cause) {
    "A description of the problem."
    String? description;
    "The underlying cause of this exception."
    Throwable? cause;
}
