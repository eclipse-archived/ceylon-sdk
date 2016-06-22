import ceylon.file {
    ...
}

import java.nio.file {
    JPath=Path,
    Files {
        readSymbolicLink,
        deletePath=delete,
        isDirectory,
        isRegularFile,
        isNotExisting=\inotExists,
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
    
    shared actual Resource linkedResource {
        if (isDirectory(jpath) || isRegularFile(jpath) || isNotExisting(jpath)) {
            // this link ultimately resolves to a file, directory, or nil,
            // so there is no risk of infinite recursion.
            return linkedPath.resource.linkedResource;
        }
        // return the next link in the cycle
        return linkedPath.resource;
    }
    
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