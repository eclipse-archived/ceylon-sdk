import java.lang { AutoCloseable }

"Adapts an instance of Java's `AutoCloseable` to Ceylon's `Closeable`,
 allowing it to be used as a `try` resource.

     try (inputStream = CeylonResource(FileInputStream(file)) {
         Integer byte = inputStream.resource.read();
         ...
     }"
shared class CeylonResource<Resource>(shared Resource resource) 
        satisfies Closeable 
        given Resource satisfies AutoCloseable {
    
    shared actual void close(Exception? exception) {
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
    
    shared actual void open() {}
}
