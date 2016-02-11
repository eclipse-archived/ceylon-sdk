import java.lang {
    AutoCloseable
}

"A Ceylon [[Destroyable]] that adapts an instance of Java's 
 [[AutoCloseable]], allowing it to be used as a resource in
 the `try` construct.

     try (inputStream = CeylonDestroyable(FileInputStream(file)) {
         Integer byte = inputStream.resource.read();
         ...
     }
     
 **Note**: Since Ceylon 1.2.1 it is possible to use 
 [[java.lang::AutoCloseable]] directly in a Ceylon `try` statement:
 
     try (inputStream = FileInputStream(file)) {
         ...
     }
 "
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
