import ceylon.file {
    ...
}

import java.nio.file {
    JPath=Path,
    Files {
        readSymbolicLink,
        deletePath=delete,
        getOwner,
        setOwner,
        getAttribute,
        setAttribute
    }
}

class ConcreteLink(JPath jpath)
        satisfies Link {
    
    linkedPath => ConcretePath(jpath.resolveSibling(readSymbolicLink(jpath)));
    
    path => ConcretePath(jpath); 
    
    linkedResource => linkedPath.resource.linkedResource;
    
    readAttribute(Attribute attribute) 
            => getAttribute(jpath, attributeName(attribute));
    
    writeAttribute(Attribute attribute, Object attributeValue)
            => setAttribute(jpath, attributeName(attribute), attributeValue);
    
    string => jpath.string;
    
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    
    shared actual String owner => getOwner(jpath).name;
        
    assign owner => setOwner(jpath, jprincipal(jpath,owner));
    
    deleteOnExit() => jpath.toFile().deleteOnExit();
}