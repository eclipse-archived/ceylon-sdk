import ceylon.file {
    ...
}

import java.nio.file {
    JPath=Path,
    Files {
        newDirectory=createDirectory,
        newDirectories=createDirectories,
        newFile=createFile,
        newSymbolicLink=createSymbolicLink
    }
}

class ConcreteNil(JPath jpath) 
        satisfies Nil {
    
    createDirectory(Boolean includingParentDirectories) 
            => if (includingParentDirectories) 
            then ConcreteDirectory(newDirectories(jpath)) 
            else ConcreteDirectory(newDirectory(jpath));
    
    shared actual File createFile
            (Boolean includingParentDirectories) {
        if (includingParentDirectories, 
            exists parent = jpath.parent) {
            newDirectories(parent);
        }
        return ConcreteFile(newFile(jpath));
    }
    
    shared actual Link createSymbolicLink
            (Path linkedPath, Boolean includingParentDirectories) {
        if (includingParentDirectories,
            exists parent = jpath.parent) {
            newDirectories(parent);
        }
        assert (is ConcretePath linkedPath);
        return ConcreteLink(newSymbolicLink(jpath, linkedPath.jpath));
    }

    path => ConcretePath(jpath); 
    
    linkedResource => this;
    
}