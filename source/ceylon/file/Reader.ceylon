"Reads lines of text from a `File`."
see (File)
shared interface Reader satisfies Closeable {
    
    "The next line of text in the file,
     or `null` if there is no more text
     in the file."
    shared formal String? readLine();
    
    "Destroy this `Reader`. Called
     automatically by `close()`."
    see (close)
    shared formal void destroy();
    
    shared actual void open() {}
    
    shared actual void close(Exception? exception) =>
            destroy();
    
}