import ceylon.file { ... }

import java.nio.file { JPath=Path, 
                       Files { newDirectory=createDirectory, 
                               newFile=createFile } }

class ConcreteNil(JPath jpath) 
        satisfies Nil {
    shared actual Directory createDirectory() {
        return ConcreteDirectory(newDirectory(jpath));
    }
    shared actual File createFile() {
        return ConcreteFile(newFile(jpath));
    }
    shared actual Path path { 
        return ConcretePath(jpath); 
    }
    shared actual File|Directory|Nil linkedResource {
        return this;
    }
}