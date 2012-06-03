import ceylon.fs { ... }
import ceylon.fs.internal { Util { newDirectory, newFile } }
import java.nio.file { JPath=Path }

class ConcreteNil(JPath jpath) 
        extends ConcreteResource(jpath)
        satisfies Nil {
    shared actual Directory createDirectory() {
        value d = newDirectory(jpath);
        if (is Directory dir = ConcretePath(d).resource) {
            return dir;
        }
        else {
            throw;
        }
    }
    shared actual File createFile() {
        value f = newFile(jpath);
        if (is File file = ConcretePath(f).resource) {
            return file;
        }
        else {
            throw;
        }
    }
}