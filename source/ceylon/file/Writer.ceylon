"Writes text to a `File`."
see(`interface File`)
shared interface Writer 
        satisfies Destroyable {
    
    "Write text to the file."
    shared formal void write(String string);
    
    "Write a line of text to the file."
    shared formal void writeLine(String line = "");
    
    "Flush all written text to the underlying
     file system."
    shared formal void flush();
    
    "Close this `Writer`. Called 
     automatically by `destroy()`."
    see(`function destroy`)
    shared formal void close();

    "Closes this `Writer` after `flush` is called automatically."
    shared actual void destroy(Throwable? exception) =>
            close();
    
}
