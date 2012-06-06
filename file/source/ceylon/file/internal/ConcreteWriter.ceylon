import ceylon.file { Writer }
import ceylon.file.internal { Util { newWriter, newAppendingWriter } }

import java.nio.file { JPath=Path }

class ConcreteWriter(JPath jpath, String encoding) 
        satisfies Writer {
    value w = newWriter(jpath, encoding);
    //shared actual void open() {}
    shared actual void close(/*Exception? exception*/) {
        w.close();
    }
    shared actual void write(String string) {
        w.write(string);
    }
    shared actual void writeLine(String line) {
        w.write(line); w.newLine();
    }
    shared actual void flush() {
        w.flush();
    }
}

class ConcreteAppendingWriter(JPath jpath, String encoding) 
        satisfies Writer {
    value w = newAppendingWriter(jpath, encoding);
    //shared actual void open() {}
    shared actual void close(/*Exception? exception*/) {
        w.close();
    }
    shared actual void write(String string) {
        w.write(string);
    }
    shared actual void writeLine(String line) {
        w.write(line); w.newLine();
    }
    shared actual void flush() {
        w.flush();
    }
}
