import ceylon.file { Resource, Path, ExistingResource, NoSuchPrincipalException, 
                     Principal, UserPrincipal, GroupPrincipal }

import java.nio.file { JPath=Path, Files { getOwner, setOwner } }
import java.nio.file.attribute { UserPrincipalNotFoundException, 
                                 JGroupPrincipal=GroupPrincipal }

abstract class ConcreteResource(JPath jpath) 
        satisfies Resource {
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual String string {
        return jpath.string;
    }
}

abstract class ConcreteExistingResource(JPath jpath) 
        extends ConcreteResource(jpath)
        satisfies ExistingResource {
    
    function jprincipal(Principal principal) {
        value upls = jpath.fileSystem.userPrincipalLookupService;
        value name = principal.name;
        try {
            switch (principal)
                    case (is UserPrincipal) {
                return upls.lookupPrincipalByName(name);
            }
            case (is GroupPrincipal) {
                return upls.lookupPrincipalByGroupName(name);
            }
        }
        catch (Exception e) {
            if (!is UserPrincipalNotFoundException e) {
                throw e;
            }
            throw NoSuchPrincipalException(name, e);
        }
    }

    shared actual Principal owner {
        value principal = getOwner(jpath);
        if (principal is JGroupPrincipal) {
            return GroupPrincipal(principal.name);
        }
        else {
            return UserPrincipal(principal.name);
        }
    }
    assign owner {
        setOwner(jpath, jprincipal(owner));
    }
}