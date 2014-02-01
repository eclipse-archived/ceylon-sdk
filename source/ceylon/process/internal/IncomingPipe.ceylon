import ceylon.file {
    Writer
}

import java.io {
    OutputStream,
    OutputStreamWriter
}

class IncomingPipe(OutputStream stream)
        satisfies Writer {
    
    value writer = OutputStreamWriter(stream);
    
    destroy() => writer.close();
    
    flush() => writer.flush();
    
    write(String string) => writer.write(string);
    
    shared actual void writeLine(String line) {
        write(line); write(operatingSystem.newline);
    }
    
}