import ceylon.fs { ... }
import ceylon.fs.internal { Util { copyPath, deletePath, movePath, overwritePath,
                                   copyAndOverwritePath, getLastModified } }
import java.nio.file { JPath=Path, Files { isReadable, isWritable, isExecutable, 
                                           getFileStore, getSize=size } }

class ConcreteFile(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies File {
    shared actual File copy(Directory|File|Nil target) {
        switch (target)
        case (is Directory) {
            return ConcreteFile( copyPath(jpath, 
                    asJPath(target.path).resolve(jpath.fileName)) );
        }
        case (is File) {
            return ConcreteFile( copyAndOverwritePath(jpath, 
                    asJPath(target.path)) );            
        }
        case (is Nil) {
            return ConcreteFile( copyPath(jpath, asJPath(target.path)) );
        }
    }
    shared actual File copyInto(Directory target) {
        return copy(target);
    }
    shared actual File copyTo(File|Nil target) {
        return copy(target);
    }
    shared actual File move(Directory|File|Nil target) {
        switch (target)
        case (is Directory) {
            return ConcreteFile( movePath(jpath, 
                    asJPath(target.path).resolve(jpath.fileName)) );
        }
        case (is File) {
            return ConcreteFile( overwritePath(jpath, asJPath(target.path)) );            
        }
        case (is Nil) {
            return ConcreteFile( movePath(jpath, asJPath(target.path)) );
        }
    }
    shared actual File moveInto(Directory target) {
        return move(target);
    }
    shared actual File moveTo(File|Nil target) {
        return move(target);
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