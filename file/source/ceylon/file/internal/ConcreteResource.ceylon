import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { getOwner, setOwner, 
                               deletePath=delete } }
import java.nio.file.attribute { UserPrincipalNotFoundException }

abstract class ConcreteResource(JPath jpath) 
        satisfies Resource {
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual File|Directory|Nil linkedResource {
        value res = this;
        switch (res)
        case (is Link) {
            return res.linkedPath.resource.linkedResource;
        }
        case (is File|Directory|Nil) {
            return res;
        }
    }
    shared actual String string {
        return jpath.string;
    }
}

abstract class ConcreteExistingResource(JPath jpath) 
        extends ConcreteResource(jpath)
        satisfies ExistingResource {
    
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