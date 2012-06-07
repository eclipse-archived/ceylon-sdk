doc "Represents a file or directory located at a certain
     path, or the absence of a file or directory at the
     path."
shared interface Resource 
        of ExistingResource|Nil {
    
    doc "The path of the file or directory."
	shared formal Path path;
    
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
    shared formal variable Principal owner;
    
}

doc "Represents a filesystem identity, a user or group."
shared abstract class Principal(name) 
        of UserPrincipal|GroupPrincipal {
    shared String name;  
    shared actual String string {
        return name;
    }
}

doc "Represents a group identity."
shared class GroupPrincipal(String name) 
        extends Principal(name) {}

doc "Represents a user identity."
shared class UserPrincipal(String name) 
        extends Principal(name) {}

doc "Thrown if there is no principal with the specified name."
shared class NoSuchPrincipalException(String name, Exception cause) 
        extends Exception(name, cause) {}
