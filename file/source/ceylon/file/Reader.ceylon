doc "Reads lines of text from a `File`."
see (File)
shared interface Reader satisfies Closeable {
    
    doc "The next line of text in the file."
    shared formal String|Finished readLine();
    
    doc "Destroy this `Reader`. Called
         automatically by `close()`."
    see (close)
    shared formal void destroy();
    
    shared actual void open() {}
    
    shared actual void close(Exception? exception) {
        destroy();
    }
    
}