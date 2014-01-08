import ceylon.file {
    Writer
}

import java.nio.charset {
    Charset
}
import java.nio.file {
    JPath=Path,
    Files {
        newBufferedWriter
    },
    StandardOpenOption {
        WRITE,
        APPEND,
        TRUNCATE_EXISTING
    }
}

class ConcreteWriter(JPath jpath, Charset charset) 
        satisfies Writer {
    
    value w = newBufferedWriter(jpath, charset, \iWRITE, 
            \iTRUNCATE_EXISTING);
    
    destroy() => w.close();
    
    write(String string) => w.write(string);
    
    shared actual void writeLine(String line) {
        w.write(line); w.newLine();
    }
    
    flush() => w.flush();
    
}

class ConcreteAppendingWriter(JPath jpath, Charset charset) 
        satisfies Writer {
    
    value w = newBufferedWriter(jpath, charset, \iWRITE, \iAPPEND);
    
    destroy() => w.close();
    
    write(String string) => w.write(string);
    
    shared actual void writeLine(String line) {
        w.write(line); w.newLine();
    }
    
    flush() => w.flush();
    
}
