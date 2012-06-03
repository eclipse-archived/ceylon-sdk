import ceylon.fs { ... }
import ceylon.fs.internal { Util { newDirectory, newFile } }
import java.nio.file { JPath=Path }

class ConcreteNil(JPath jpath) 
        extends ConcreteResource(jpath)
        satisfies Nil {
    shared actual Directory createDirectory() {
        return ConcreteDirectory(newDirectory(jpath));
    }
    shared actual File createFile() {
        return ConcreteFile(newFile(jpath));
    }
}