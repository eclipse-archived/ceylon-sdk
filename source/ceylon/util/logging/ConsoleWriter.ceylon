import ceylon.util.logging { LogWriter }

doc "Write log mesages to console."
by "Matej Lazar"
shared class ConsoleWriter() satisfies LogWriter {
    shared actual void write(String mesasge) {
        print(mesasge);
    }
}