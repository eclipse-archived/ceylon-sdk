import ceylon.file { Writer }

import java.io { OutputStream, OutputStreamWriter }

class IncomingPipe(OutputStream stream)
        satisfies Writer {
    
    value writer = OutputStreamWriter(stream);
    
    shared actual void destroy() {
        writer.close();
    }
    shared actual void flush() {
        writer.flush();
    }
    shared actual void write(String string) {
        writer.write(string);
    }
    shared actual void writeLine(String line) {
        write(line); write(process.newline);
    }
    
}