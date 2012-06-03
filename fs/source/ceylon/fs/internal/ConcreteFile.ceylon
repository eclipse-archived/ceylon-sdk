import ceylon.fs { ... }
import ceylon.fs.internal { Util { copyPath, deletePath, movePath, overwritePath,
                                   getLastModified } }
import java.nio.file { JPath=Path, Files { isReadable, isWritable, isExecutable, 
                                           getFileStore } }

class ConcreteFile(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies File {
    shared actual File copy(Directory dir) {
        value cp = copyPath(jpath, asJPath(dir.path));
        if (is File file = ConcretePath(cp).resource) {
            return file;
        }
        else {
            throw Exception("copy failed");
        }
    }
    shared actual File move(Directory dir) {
        value mp = movePath(jpath, 
                asJPath(dir.path).resolve(jpath.fileName));
        if (is File file = ConcretePath(mp).resource) {
            return file;
        }
        else {
            throw Exception("move failed");
        }
    }
    shared actual File overwrite(File file) {
        value op = overwritePath(jpath, asJPath(file.path));
        if (is File result = ConcretePath(op).resource) {
            return result;
        }
        else {
            throw Exception("overwrite failed");
        }
    }
    shared actual File rename(Nil nil) {
        value rp = movePath(jpath, asJPath(nil.path));
        if (is File result = ConcretePath(rp).resource) {
            return result;
        }
        else {
            throw Exception("rename failed");
        }
    }
    shared actual Nil delete() {
        deletePath(jpath);
        if (is Nil nil = ConcretePath(jpath).resource) {
            return nil;
        }
        else {
            throw Exception("delete failed");
        }
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