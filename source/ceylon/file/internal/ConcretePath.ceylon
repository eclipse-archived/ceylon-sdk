import ceylon.collection {
    ArrayList
}
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
    FileVisitResult,
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
    value sb = ArrayList<Path>();
    value iter = defaultFileSystem.rootDirectories.iterator();
    while (iter.hasNext()) {
        sb.add(ConcretePath(iter.next()));
    }
    return sb.sequence();
}

JPath asJPath(String|Path path, JPath systemPath) {
    if (is ConcretePath path) {
        return path.jpath;
    }
    else {
        return systemPath.fileSystem.getPath(path.string);
    }
}

class ConcretePath(jpath)
        satisfies Path {
    
    shared JPath jpath;
    
    shared actual ConcretePath parent {
        if (exists jparent = jpath.parent) {
            return ConcretePath(jparent);
        }
        else {
            return this;
        }
    }
    
    childPath(String|Path subpath) =>
            ConcretePath(jpath.resolve(asJPath(subpath, jpath)));
    
    siblingPath(String|Path subpath) =>
            ConcretePath(jpath.resolveSibling(asJPath(subpath, jpath)));
    
    root => jpath.nameCount==0;
    
    absolute => jpath.absolute;
    
    absolutePath => ConcretePath(jpath.toAbsolutePath());
    
    normalizedPath => ConcretePath(jpath.normalize());
    
    parentOf(Path path) => asJPath(path, jpath).startsWith(jpath);
    
    childOf(Path path) => jpath.startsWith(asJPath(path, jpath));
    
    relativePath(String|Path path) =>
            ConcretePath(asJPath(path, jpath).relativize(jpath));
    
    system => ConcreteSystem(jpath.fileSystem);
    
    string => jpath.string;
    
    uriString => jpath.toUri().string;
    
    shared actual Path[] elementPaths {
        value sb = ArrayList<Path>();
        value iter = jpath.iterator();
        while (iter.hasNext()){
            sb.add(ConcretePath(iter.next()));
        }
        return sb.sequence();
    }
    
    shared actual String[] elements {
        value sb = ArrayList<String>();
        value iter = jpath.iterator();
        while (iter.hasNext()){
            sb.add(iter.next().string);
        }
        return sb.sequence();
    }
    
    compare(Path other) => jpath.compareTo(asJPath(other, jpath))<=>0;
    
    shared actual Boolean equals(Object that) {
        if (is Path that) {
            return asJPath(that, jpath)==jpath;
        }
        else {
            return false;
        }
    }
    
    hash => jpath.hash;
    
    separator => jpath.fileSystem.separator;
    
    shared actual Resource resource {
        if (isExisting(jpath)) {
            // prefer ConcreteFile and ConcreteDirectory; only return a ConcreteLink
            // if it is 1) a link to nowhere, or 2) a link to another link.
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
        else if (isSymbolicLink(jpath)) {
            // a symbolic link that does not ultimately resolve
            // to a file or directory.
            return ConcreteLink(jpath);
        }
        else {
            return ConcreteNil(jpath);
        }
    }
    
    shared actual Link? link
        =>  if (isSymbolicLink(jpath))
            then ConcreteLink(jpath)
            else null;
    
    shared actual void visit(Visitor visitor) {
        object fileVisitor satisfies FileVisitor<JPath> {
            value result {
                return visitor.terminated 
                        then FileVisitResult.terminate
                        else FileVisitResult.\icontinue;
            }
            shared actual FileVisitResult preVisitDirectory(JPath? t, 
                    BasicFileAttributes? basicFileAttributes) {
                if (exists t) {
                    return visitor.beforeDirectory(ConcreteDirectory(t)) 
                            then result
                            else FileVisitResult.skipSubtree;
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
