import ceylon.fs { ... }
import ceylon.fs.internal { Util { copyPath, deletePath, movePath, overwritePath,
                                   getLastModified } }
import java.nio.file { JPath=Path, Files { isReadable, isWritable, isExecutable, 
                                           getFileStore } }

class ConcreteFile(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies File {
    shared actual File copy(Directory dir) {
        return ConcreteFile( copyPath(jpath, asJPath(dir.path)) );
    }
    shared actual File move(Directory dir) {
        return ConcreteFile( movePath(jpath, 
                asJPath(dir.path).resolve(jpath.fileName)) );
    }
    shared actual File overwrite(File file) {
        return ConcreteFile( overwritePath(jpath, asJPath(file.path)) );
    }
    shared actual File rename(Nil nil) {
        return ConcreteFile( movePath(jpath, asJPath(nil.path)) );
    }
    shared actual Nil delete() {
        deletePath(jpath);
        return ConcreteNil(jpath);
    }
    shared actual Boolean readable {
        return isReadable(jpath);
    }
    shared actual Boolean writable {
        return isWritable(jpath);
    }
    shared actual Boolean executable {
        return isExecutable(jpath);
    }
    shared actual Integer lastModifiedMilliseconds {
        return getLastModified(jpath);
    }
    shared actual String name {
        return jpath.fileName.string;
    }
    shared actual Store store {
        return ConcreteStore(getFileStore(jpath));
    }
}