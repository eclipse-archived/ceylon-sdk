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
        return ConcreteNil(jpath);
    }
    shared actual File move(Directory dir) {
        return ConcreteFile( movePath(jpath, 
                asJPath(dir.path).resolve(jpath.fileName)) );
    }
    shared actual File rename(Nil nil) {
        return ConcreteFile( movePath(jpath, asJPath(nil.path)) );
    }
    shared actual Directory createDirectory(String|Path name) {
        return ConcreteDirectory( newDirectory(jpath.resolve(asJPath(name))) );
    }
    shared actual File createFile(String|Path name) {
        return ConcreteFile( newFile(jpath.resolve(asJPath(name))) );
    }
}