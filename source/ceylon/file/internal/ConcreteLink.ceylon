import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { readSymbolicLink,
                               deletePath=delete,
                               getOwner, setOwner } }
import java.nio.file.attribute { UserPrincipalNotFoundException }

class ConcreteLink(JPath jpath)
        satisfies Link {
    shared actual Path linkedPath {
        return ConcretePath(readSymbolicLink(jpath));
    }
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual File|Directory|Nil linkedResource {
        return linkedPath.resource.linkedResource;
    }
    shared actual String string {
        return jpath.string;
    }
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    function jprincipal(String name) {
        value upls = jpath.fileSystem.userPrincipalLookupService;
        try {
            return upls.lookupPrincipalByName(name);
        }
        catch (UserPrincipalNotFoundException e) {
            throw NoSuchPrincipalException(name, e);
        }
    }
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(owner));
    }
}