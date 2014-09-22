import java.lang {
    AutoCloseable
}

"A Java [[AutoCloseable]] that adapts an instance of Ceylon's 
 [[Destroyable]], allowing it to be used as a resource in
 the `try` construct."
shared class JavaCloseable<Resource>(shared Resource resource) 
        satisfies AutoCloseable
        given Resource satisfies Destroyable {
    
    close() => resource.destroy(null);
}
