"Represents a file, link, or directory located at a 
 certain path, or the absence of a file or directory 
 at that path."
shared interface Resource 
        of ExistingResource|Nil {
    
    "The path of the file, link, or directory."
    shared formal Path path;
    
    "If this resource is a link, attempt to fully resolve
     the link.

     If the link cannot be fully resolved due to a cycle,
     return the next `Link` in the cycle."
    shared formal Resource linkedResource;
    
}

"A resource that actually exists&mdash;that is one that is
 not `Nil`."
shared interface ExistingResource 
        of File|Directory|Link
        satisfies Resource {
    
    "Delete this resource."
    shared formal Nil delete();
    
    "The principal name of the owner of the file."
    throws(`class NoSuchPrincipalException`,
            "If set to a name for which there is no 
             corresponding user.")
    shared formal variable String owner;
    
    "Get the value of a filesystem attribute."
    shared formal Object readAttribute(Attribute attribute);

    "Set the value of a filesystem attribute."
    shared formal void writeAttribute(Attribute attribute, 
                            Object attributeValue);
    
    "Request that this resource be deleted when the process terminates.

     Invoking [[deleteOnExit()]] does not guarantee that the resource will
     be deleted, and may have no effect on some [[System]]s or platforms.
     For filesystem resources on the JVM, `deleteOnExit()` delegates to
     `java.io.File.deleteOnExit()`."
    shared formal void deleteOnExit();
}

"Thrown if there is no principal with the specified name."
shared class NoSuchPrincipalException(name, Exception cause) 
        extends Exception(name, cause) {
    
    "The specified principal name."
    shared String name;
    
}
