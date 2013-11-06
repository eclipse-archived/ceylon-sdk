import java.io { InputStream, IOException }

"
 Wraps a java.io.InputStream in a ceylon.language.Closeable, so it can be used in try-with-resources
 Sample usage:
 <pre>
 InputStream stream = ...;
 try (input = CeylonInputStream(stream)) {
     input.stream.read();
     ...
 } 
 </pre>
 or:
 <pre>
 value connection = ...
 try (input = CeylonInputStream( () => connection.getInputStream() ) {
     input.stream.read();
 }
 </pre>
 
"
shared class CeylonInputStream(InputStream|InputStream() resource) satisfies Closeable {
    
    variable InputStream? actualStream = null;
    
    shared InputStream stream {
        if (exists a = actualStream) {
            return a;
        }
        throw Exception("Stream was not opened");
    }
    
    shared actual void close(Exception? exception) {
        try {
            stream.close();
        } catch (IOException e) {
            if (exists exception) {
                //could be added as suppressed exception
                throw exception;
            } else {
                throw e;
            }
        }
    }
    
    shared actual void open() {
        if (is InputStream resource) {
            actualStream = resource;
        }
        if (is InputStream() resource) {
            actualStream = resource();
        }
    }
    
}
