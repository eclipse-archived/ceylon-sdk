import java.nio.file { JPath=Path }
import ceylon.fs { ... }
import ceylon.fs.internal { Util { newPath, 
                                   isDirectory, isRegularFile, isExisting,
                                   copyPath, deletePath, movePath, overwritePath,
                                   newDirectory, newFile } }

shared Path path(String pathString) {
    return ConcretePath(newPath(pathString));
}

class ConcretePath(jpath)
        extends Path() {
    shared JPath jpath;
    shared actual Path parent {
        return ConcretePath(jpath.parent);
    }
    shared actual Path childPath(String|Path subpath) {
        JPath p;
        switch (subpath)
        case (is String) {
            p = jpath.resolve(subpath);
        }
        case (is Path) {
            if (is ConcretePath subpath) {
                p = jpath.resolve(subpath.jpath);
            }
            else {
                p = jpath.resolve(subpath.string);
            }
        }
        return ConcretePath(p);
    }
    shared actual Path absolutePath {
        return ConcretePath(jpath.toAbsolutePath());
    }
    shared actual Path normalizedPath {
        return ConcretePath(jpath.normalize());
    }
    shared actual Path relativePath(String|Path path) {
        JPath p;
        switch (path)
        case (is String) {
            p = newPath(path);
        }
        case (is Path) {
            if (is ConcretePath path) {
                p = path.jpath;
            }
            else {
                p = newPath(path.string);
            }
        }
        return ConcretePath(this.jpath.relativize(p));
    }
    shared actual String string {
        return jpath.string;
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
        if (is ConcretePath other) {
            return jpath.compareTo(other.jpath)<=>0;
        }
        else {
            return string<=>other.string;
        }
    }
    shared actual Boolean equals(Object that) {
        if (is ConcretePath that) {
            return that.jpath==jpath;
        }
        else {
            return false;
        }
    }
    shared actual Integer hash {
        return jpath.hash;
    }
    shared actual Resource resource {
        abstract class ResourceWithPath() 
                satisfies Resource {
            shared actual Path path { 
                return ConcretePath(jpath); 
            }
            shared actual String string {
                return jpath.string;
            }
        }            
        if (isExisting(jpath)) {
            if (isRegularFile(jpath)) {
                object file 
                        extends ResourceWithPath() 
                        satisfies File {
                    shared actual File copy(Directory dir) {
                        if (is ConcretePath dirPath = dir.path) {
                            value cp = copyPath(jpath, dirPath.jpath);
                            if (is File file = ConcretePath(cp).resource) {
                                return file;
                            }
                            else {
                                throw;
                            }
                        }
                        else {
                            throw; //TODO!
                        }
                    }
                    shared actual File move(Directory dir) {
                        if (is ConcretePath dirPath = dir.path) {
                            value cp = movePath(jpath, dirPath.jpath);
                            if (is File file = ConcretePath(cp).resource) {
                                return file;
                            }
                            else {
                                throw;
                            }
                        }
                        else {
                            throw; //TODO!
                        }
                    }
                
                    shared actual File overwrite(File file) {
                        if (is ConcretePath filePath = file.path) {
                            value cp = overwritePath(jpath, filePath.jpath);
                            if (is File result = ConcretePath(cp).resource) {
                                return result;
                            }
                            else {
                                throw;
                            }
                        }
                        else {
                            throw; //TODO!
                        }
                    }
                
                    shared actual File rename(Nil nil) {
                        if (is ConcretePath filePath = nil.path) {
                            value cp = movePath(jpath, filePath.jpath);
                            if (is File result = ConcretePath(cp).resource) {
                                return result;
                            }
                            else {
                                throw;
                            }
                        }
                        else {
                            throw; //TODO!
                        }
                    }
                    shared actual Nil delete() {
                        deletePath(jpath);
                        if (is Nil nil = ConcretePath(jpath).resource) {
                            return nil;
                        }
                        else {
                            throw;
                        }
                    }
                    
                }
                return file;
            }
            else if (isDirectory(jpath)) {
                object dir 
                        extends ResourceWithPath() 
                        satisfies Directory {
                    shared actual Path[] childPaths {
                        value sb = SequenceBuilder<Path>();
                        for (s in jpath.toFile().list()) {
                            sb.append(ConcretePath(newPath(s)));
                        }
                        return sb.sequence;
                    }
                    shared actual Resource[] children {
                        return childPaths[].resource;
                    }
                }
                return dir;
            }
            else {
                throw;
            }
        }
        else {
            object nil extends ResourceWithPath()
                    satisfies Nil {
                shared actual Directory createDirectory() {
                    value cp = newDirectory(jpath);
                    if (is Directory dir = ConcretePath(cp).resource) {
                        return dir;
                    }
                    else {
                        throw;
                    }
                }
                shared actual File createFile() {
                    value cp = newFile(jpath);
                    if (is File file = ConcretePath(cp).resource) {
                        return file;
                    }
                    else {
                        throw;
                    }
                }
            }
            return nil;
        }
    }
}