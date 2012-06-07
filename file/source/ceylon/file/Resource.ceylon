doc "Represents a file, link, or directory located at a 
     certain path, or the absence of a file or directory 
     at the path."
shared interface Resource 
        of ExistingResource|Nil {
    
    doc "The path of the file, link, or directory."
	shared formal Path path;
    
    doc "If this resource is a link, resolve the link."
    shared formal File|Directory|Nil linkedResource;
    
}

doc "A resource that actually exists, that is one that is
     not `Nil`."
shared interface ExistingResource 
        of File|Directory|Link
        satisfies Resource {
    
    doc "Delete this resource."
    shared formal Nil delete();
    
    doc "The owner of the file."
    throws (NoSuchPrincipalException)
    shared formal variable String owner;
    
}

doc "Thrown if there is no principal with the specified name."
shared class NoSuchPrincipalException(String name, Exception cause) 
        extends Exception(name, cause) {}
