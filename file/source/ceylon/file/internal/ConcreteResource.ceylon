import ceylon.file { Resource, Path }

import java.nio.file { JPath=Path }

abstract class ConcreteResource(JPath jpath) 
        satisfies Resource {
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual String string {
        return jpath.string;
    }
}