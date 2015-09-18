import ceylon.file {
    Writer
}

import java.io {
    OutputStream,
    OutputStreamWriter
}
import java.lang {
    ByteArray
}

class IncomingPipe(OutputStream stream)
        satisfies Writer {
    
    value writer = OutputStreamWriter(stream);
    
    close() => writer.close();
    
    flush() => writer.flush();
    
    write(String string) => writer.write(string);
    
    shared actual void writeLine(String line) {
        write(line); 
        write(operatingSystem.newline);
    }
    
    shared actual void writeBytes({Byte*} bytes) {
        value byteArray = ByteArray(bytes.size);
        variable value i=0;
        for (b in bytes) {
            byteArray.set(i++, b);
        }
        stream.write(byteArray);
    }
    
}