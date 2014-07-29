
"Represents a network socket."
by("Stéphane Épardaud")
shared interface Socket 
        satisfies SelectableFileDescriptor {}

"Represents an SSL network socket."
shared interface SslSocket 
        satisfies Socket {}