
"Represents a network socket."
by("Stéphane Épardaud")
shared interface Socket satisfies SelectableFileDescriptor {
}

shared interface SslSocket satisfies Socket {
}