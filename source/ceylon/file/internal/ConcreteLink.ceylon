import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { readSymbolicLink,
                               deletePath=delete,
                               getOwner, setOwner } }

class ConcreteLink(JPath jpath)
        satisfies Link {
    
    linkedPath => ConcretePath(readSymbolicLink(jpath));
    
    path => ConcretePath(jpath); 
    
    linkedResource => linkedPath.resource.linkedResource;
    
    string => jpath.string;
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    shared actual String owner {
        return getOwner(jpath).name;
    }
    assign owner {
        setOwner(jpath, jprincipal(jpath,owner));
    }
    
}