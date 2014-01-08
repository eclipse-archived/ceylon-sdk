import ceylon.file {
    ...
}

import java.io {
    IOException
}
import java.net {
    URI {
        newURI=create
    }
}
import java.nio.file {
    JPath=Path,
    Paths {
        newPath=get
    },
    FileVisitor,
    FileVisitResult {
        CONTINUE,
        TERMINATE,
        SKIP_SUBTREE
    },
    FileSystems {
        defaultFileSystem=default
    },
    Files {
        isDirectory,
        isRegularFile,
        isExisting=\iexists,
        isSymbolicLink,
        walkFileTree
    }
}
import java.nio.file.attribute {
    BasicFileAttributes
}

shared Path parsePath(String pathString) =>
        ConcretePath(newPath(pathString));

shared Path parseURI(String uriString) =>
        ConcretePath(newPath(newURI(uriString)));

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
    
    parent => ConcretePath(jpath.parent);
    
    childPath(String|Path subpath) =>
            ConcretePath(jpath.resolve(asJPath(subpath)));
    
    siblingPath(String|Path subpath) =>
            ConcretePath(jpath.resolveSibling(asJPath(subpath)));
    
    absolute => jpath.absolute;
    
    absolutePath => ConcretePath(jpath.toAbsolutePath());
    
    normalizedPath => ConcretePath(jpath.normalize());
    
    parentOf(Path path) => asJPath(path).startsWith(jpath);
    
    childOf(Path path) => jpath.startsWith(asJPath(path));
    
    relativePath(String|Path path) =>
            ConcretePath(asJPath(path).relativize(jpath));
    
    system => ConcreteSystem(jpath.fileSystem);
    
    string => jpath.string;
    
    uriString => jpath.toUri().string;
    
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
    
    compare(Path other) => jpath.compareTo(asJPath(other))<=>0;
    
    shared actual Boolean equals(Object that) {
        if (is Path that) {
            return asJPath(that)==jpath;
        }
        else {
            return false;
        }
    }
    
    hash => jpath.hash;
    
    separator => jpath.fileSystem.separator;
    
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
                throw Exception("unknown file type: " +
                        jpath.string);
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
