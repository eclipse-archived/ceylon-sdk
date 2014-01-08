"Writes text to a `File`."
see(`interface File`)
shared interface Writer 
        satisfies Closeable {
    
    "Write text to the file."
    shared formal void write(String string);
    
    "Write a line of text to the file."
    shared formal void writeLine(String line = "");
    
    "Flush all written text to the underlying
     file system."
    shared formal void flush();
    
    "Destroy this `Writer`. Called 
     automatically by `close()`."
    see(`function close`)
    shared formal void destroy();
    
    shared actual void open() {}

    "Closes this `Writer` after `flush` is called automatically."    
    shared actual void close(Exception? exception) =>
            destroy();
    
}
