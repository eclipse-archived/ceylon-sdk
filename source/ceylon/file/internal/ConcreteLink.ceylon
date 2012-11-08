import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { readSymbolicLink } }

class ConcreteLink(JPath jpath) 
        extends ConcreteExistingResource(jpath)
        satisfies Link {
    shared actual Path linkedPath {
        return ConcretePath(readSymbolicLink(jpath));
    }
}