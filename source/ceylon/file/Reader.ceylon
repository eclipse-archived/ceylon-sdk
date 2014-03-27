"Reads lines of text from a `File`."
see(`interface File`)
shared interface Reader 
        satisfies Destroyable {
    
    "The next line of text in the file,
     or `null` if there is no more text
     in the file."
    shared formal String? readLine();
    
    "Destroy this `Reader`. Called
     automatically by `destroy()`."
    see(`function destroy`)
    shared formal void close();
    
    shared actual void destroy(Throwable? exception) =>
            close();
    
}