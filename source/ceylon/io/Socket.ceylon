
"Represents a network socket."
by("Stéphane Épardaud")
shared sealed interface Socket 
        satisfies SelectableFileDescriptor {}

"Represents an SSL network socket."
shared sealed interface SslSocket 
        satisfies Socket {}