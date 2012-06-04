doc "Reads lines of text from a `File`."
see (File)
shared interface Reader /*satisfies Closeable*/ {
    
    doc "The next line of text in the file."
    shared formal String|Finished readLine();
    
    doc "Destroy this `Reader`."
    shared formal void close();
    
}