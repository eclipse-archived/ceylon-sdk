import ceylon.file {
    ...
}

import java.nio.file {
    JPath=Path,
    Files {
        newDirectory=createDirectory,
        newFile=createFile
    }
}

class ConcreteNil(JPath jpath) 
        satisfies Nil {
    
    createDirectory() =>
            ConcreteDirectory(newDirectory(jpath));
    
    createFile() => ConcreteFile(newFile(jpath));
    
    path => ConcretePath(jpath); 
    
    linkedResource => this;
    
}