
"Represents a network socket."
by("Stéphane Épardaud")
shared sealed interface Socket 
        satisfies SelectableFileDescriptor {}

"Represents an SSL network socket."
shared sealed interface SslSocket 
        satisfies Socket {}

"Thrown if a connect or read did not complete before a defined timeout period elapsed"
shared class SocketTimeoutException() extends Exception() {}
