import java.lang { AutoCloseable }

"
 Ceylon wrapper for java.lang.AutoCloseable to allow usage in try-with-resources, e.g.
 <pre>
 try (wrapper = CeylonWrapper(getInputStream()) {
     wrapper.resource.read();
     ...
 }
 </pre>
 "
shared class CeylonWrapper<Resource>(shared Resource resource) satisfies Closeable 
        given Resource satisfies AutoCloseable {
    
    shared actual void close(Exception? exception) {
        try {
            resource.close();
        } catch (Exception e) {
            if (exists exception) {
                // 'e' could be added as suppressed exception
                throw exception;
            } 
            throw e;
        }
    }
    
    shared actual void open() {}
}
