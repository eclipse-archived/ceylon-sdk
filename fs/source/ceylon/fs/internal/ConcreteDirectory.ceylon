import ceylon.fs { ... }
import ceylon.fs.internal { Util { newPath, deletePath, movePath, 
                                   newDirectory, newFile } }
import java.nio.file { JPath=Path }

class ConcreteDirectory(JPath jpath)
        extends ConcreteResource(jpath) 
        satisfies Directory {
    shared actual Path[] childPaths {
        value sb = SequenceBuilder<Path>();
        for (s in jpath.toFile().list()) {
            sb.append(ConcretePath(newPath(s)));
        }
        return sb.sequence;
    }
    shared actual Empty|Sequence<File|Directory> children {
        value sb = SequenceBuilder<File|Directory>();
        for (p in childPaths) {
            if (is File|Directory r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
    }
    shared actual File[] files {
        value sb = SequenceBuilder<File>();
        for (p in childPaths) {
            if (is File r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
    }
    shared actual Directory[] childDirectories {
        value sb = SequenceBuilder<Directory>();
        for (p in childPaths) {
            if (is Directory r=p.resource) {
                sb.append(r);
            }
        }
        return sb.sequence;
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
    shared actual File rename(Nil nil) {
        value rp = movePath(jpath, asJPath(nil.path));
        if (is File result = ConcretePath(rp).resource) {
            return result;
        }
        else {
            throw Exception("rename failed");
        }
    }
    shared actual Directory createDirectory(String|Path name) {
        value d = newDirectory(jpath.resolve(asJPath(name)));
        if (is Directory dir = ConcretePath(d).resource) {
            return dir;
        }
        else {
            throw;
        }
    }
    shared actual File createFile(String|Path name) {
        value f = newFile(jpath.resolve(asJPath(name)));
        if (is File file = ConcretePath(f).resource) {
            return file;
        }
        else {
            throw;
        }
    }
}