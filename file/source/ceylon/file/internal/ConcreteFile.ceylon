import ceylon.file { ... }
import ceylon.file.internal { Util { copyPath, deletePath, movePath, overwritePath,
                                   copyAndOverwritePath, getLastModified } }
import java.nio.file { JPath=Path, Files { isReadable, isWritable, isExecutable, 
                                           getFileStore, getSize=size } }

class ConcreteFile(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies File {
    shared actual File copy(Nil target) {
            return ConcreteFile( copyPath(jpath, asJPath(target.path)) );
    }
    shared actual File copyOverwriting(File|Nil target) {
            return ConcreteFile( copyAndOverwritePath(jpath, 
                    asJPath(target.path)) );            
    }
    shared actual File move(Nil target) {
            return ConcreteFile( movePath(jpath, asJPath(target.path)) );
    }
    shared actual File moveOverwriting(File|Nil target) {
            return ConcreteFile( overwritePath(jpath, asJPath(target.path)) );            
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
    shared actual Integer size {
        return getSize(jpath);
    }
    shared actual Directory directory {
        return ConcreteDirectory(jpath.parent);
    }
    shared actual Store store {
        return ConcreteStore(getFileStore(jpath));
    }
    shared actual Reader reader(String? encoding) {
        return ConcreteReader(jpath, encoding else "UTF-8");
    }
    shared actual Writer writer(String? encoding) {
        return ConcreteWriter(jpath, encoding else "UTF-8");
    }
    shared actual Writer appender(String? encoding) {
        return ConcreteAppendingWriter(jpath, encoding else "UTF-8");
    }
}