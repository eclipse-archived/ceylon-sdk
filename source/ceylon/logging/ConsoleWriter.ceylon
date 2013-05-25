doc "Write log mesages to console."
by "Matej Lazar"
shared class ConsoleWriter() satisfies Writer {
    shared actual void write(String message) {
        print(message);
    }
}