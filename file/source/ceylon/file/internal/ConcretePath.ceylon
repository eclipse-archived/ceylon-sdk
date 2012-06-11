import ceylon.file { ... }

import java.net { URI { newURI=create } }
import java.io { IOException }
import java.nio.file { JPath=Path, Paths { newPath=get }, FileVisitor, 
                       FileVisitResult { CONTINUE, TERMINATE, SKIP_SUBTREE }, 
                       FileSystems { defaultFileSystem=default },
                       Files { isDirectory, isRegularFile, isExisting=\iexists,
                               isSymbolicLink, walkFileTree } }
import java.nio.file.attribute { BasicFileAttributes }

shared Path parsePath(String pathString) {
    return ConcretePath(newPath(pathString));
}

shared Path parseURI(String uriString) {
    return ConcretePath(newPath(newURI(uriString)));
}

shared Path[] rootPaths {
    value sb = SequenceBuilder<Path>();
    value iter = defaultFileSystem.rootDirectories.iterator();
    while (iter.hasNext()) {
        sb.append(ConcretePath(iter.next()));
    }
    return sb.sequence;
}

JPath asJPath(String|Path path) {
    if (is ConcretePath path) {
        return path.jpath;
    }
    else {
        return newPath(path.string);
    }
}

class ConcretePath(jpath)
        satisfies Path {
    shared JPath jpath;
    shared actual Path parent {
        return ConcretePath(jpath.parent);
    }
    shared actual Path childPath(String|Path subpath) {
        return ConcretePath(jpath.resolve(asJPath(subpath)));
    }
    shared actual Path siblingPath(String|Path subpath) {
        return ConcretePath(jpath.resolveSibling(asJPath(subpath)));
    }
    shared actual Path absolutePath {
        return ConcretePath(jpath.toAbsolutePath());
    }
    shared actual Path normalizedPath {
        return ConcretePath(jpath.normalize());
    }
    shared actual Boolean parentOf(Path path) {
        return asJPath(path).startsWith(jpath);
    }
    shared actual Boolean childOf(Path path) {
        return jpath.startsWith(asJPath(path));
    }
    shared actual Path relativePath(String|Path path) {
        return ConcretePath(asJPath(path).relativize(jpath));
    }
    shared actual System system {
        return ConcreteSystem(jpath.fileSystem);
    }
    shared actual String string {
        return jpath.string;
    }
    shared actual String uriString {
        return jpath.toUri().string;
    }
    shared actual Path[] elementPaths {
        value sb = SequenceBuilder<Path>();
        value iter = jpath.iterator();
        while (iter.hasNext()){
            sb.append(ConcretePath(iter.next()));
        }
        return sb.sequence;
    }
    shared actual String[] elements {
        value sb = SequenceBuilder<String>();
        value iter = jpath.iterator();
        while (iter.hasNext()){
            sb.append(iter.next().string);
        }
        return sb.sequence;
    }
    shared actual Boolean absolute {
        return jpath.absolute;
    }
    shared actual Comparison compare(Path other) {
        return jpath.compareTo(asJPath(other))<=>0;
    }
    shared actual Boolean equals(Object that) {
        if (is Path that) {
            return asJPath(that)==jpath;
        }
        else {
            return false;
        }
    }
    /*shared actual Integer hash {
        return jpath.hash;
    }*/
    shared actual String separator {
        return jpath.fileSystem.separator;
    }
    shared actual Resource resource {
        if (isExisting(jpath)) {
            if (isRegularFile(jpath)) {
                return ConcreteFile(jpath);
            }
            else if (isDirectory(jpath)) {
                return ConcreteDirectory(jpath);
            }
            else if (isSymbolicLink(jpath)) {
                return ConcreteLink(jpath);
            }
            else {
                throw;
            }
        }
        else {
            return ConcreteNil(jpath);
        }
    }
    shared actual void visit(Visitor visitor) {
        object fileVisitor satisfies FileVisitor<JPath> {
            value result {
                return visitor.terminated 
                        then \iTERMINATE else \iCONTINUE;
            }
            shared actual FileVisitResult preVisitDirectory(JPath? t, 
                    BasicFileAttributes? basicFileAttributes) {
                if (exists t) {
                    return visitor.beforeDirectory(ConcreteDirectory(t)) 
                            then result else \iSKIP_SUBTREE;
                }
                return result;
            }
            shared actual FileVisitResult postVisitDirectory(JPath? t, 
                    IOException? iOException) {
                if (exists t) {
                    visitor.afterDirectory(ConcreteDirectory(t));
                }
                return result;
            }
            shared actual FileVisitResult visitFile(JPath? t, 
                    BasicFileAttributes? basicFileAttributes) {
                if (exists t) {
                    visitor.file(ConcreteFile(t));
                }
                return result;
            }
            shared actual FileVisitResult visitFileFailed(JPath? t, 
                    IOException? iOException) {
                return result;
            }
        }
        walkFileTree(jpath, fileVisitor);
    }
}
