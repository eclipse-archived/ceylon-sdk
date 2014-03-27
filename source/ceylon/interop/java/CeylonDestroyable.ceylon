import java.lang { AutoCloseable }

"Adapts an instance of Java's `AutoCloseable` to Ceylon's `Destroyable`,
 allowing it to be used as a `try` resource.

     try (inputStream = CeylonDestroyable(FileInputStream(file)) {
         Integer byte = inputStream.resource.read();
         ...
     }"
shared class CeylonDestroyable<Resource>(shared Resource resource) 
        satisfies Destroyable 
        given Resource satisfies AutoCloseable {
    
    shared actual void destroy(Throwable? exception) {
        try {
            resource.close();
        }
        catch (Exception e) {
            if (exists exception) {
                //TODO: add to suppressedExceptions
                throw exception;
            }
            throw e;
        }
    }
}
