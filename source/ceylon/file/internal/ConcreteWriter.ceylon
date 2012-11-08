import ceylon.file { Writer }

import java.nio.file { JPath=Path, Files { newBufferedWriter },
                       StandardOpenOption { WRITE, APPEND, TRUNCATE_EXISTING } }
import java.nio.charset { Charset }

class ConcreteWriter(JPath jpath, Charset charset) 
        satisfies Writer {
    value w = newBufferedWriter(jpath, charset, \iWRITE, \iTRUNCATE_EXISTING);
    shared actual void destroy() {
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

class ConcreteAppendingWriter(JPath jpath, Charset charset) 
        satisfies Writer {
    value w = newBufferedWriter(jpath, charset, \iWRITE, \iAPPEND);
    shared actual void destroy() {
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
