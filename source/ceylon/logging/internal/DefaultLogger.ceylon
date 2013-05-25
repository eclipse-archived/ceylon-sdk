import ceylon.logging { Level, Writer, Logger }

by "Matej Lazar"
shared class DefaultLogger(String name, Level level, Writer writer) extends Logger(name, level, writer) {

    shared actual void log(Level level, String message) {
        if (this.level <= level ) {
            writer.write(message);
        }
    }
}

