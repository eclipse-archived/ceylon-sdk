import ceylon.file {
    ...
}

import java.nio.file {
    JPath=Path,
    Files {
        newDirectory=createDirectory,
        newDirectories=createDirectories,
        newFile=createFile
    }
}

class ConcreteNil(JPath jpath) 
        satisfies Nil {
    
    shared actual Directory createDirectory(Boolean includingParentDirectories) {
        if( includingParentDirectories ) {
            return ConcreteDirectory(newDirectories(jpath));
        } else {
            return ConcreteDirectory(newDirectory(jpath));
        }
    }
    
    shared actual File createFile(Boolean includingParentDirectories) {
        if( includingParentDirectories, exists parent = jpath.parent ) {
            newDirectories(parent);
        }
        return ConcreteFile(newFile(jpath));
    }
    
    path => ConcretePath(jpath); 
    
    linkedResource => this;
    
}