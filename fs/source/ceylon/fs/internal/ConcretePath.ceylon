import java.nio.file { JPath=Path }
import ceylon.fs { ... }
import ceylon.fs.internal { Util { newPath, 
                                   isDirectory, isRegularFile, isExisting,
                                   copyPath, deletePath, movePath, overwritePath,
                                   newDirectory, newFile } }

shared Path path(String pathString) {
    return ConcretePath(newPath(pathString));
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
        extends Path() {
    shared JPath jpath;
    shared actual Path parent {
        return ConcretePath(jpath.parent);
    }
    shared actual Path childPath(String|Path subpath) {
        return ConcretePath(asJPath(subpath));
    }
    shared actual Path absolutePath {
        return ConcretePath(jpath.toAbsolutePath());
    }
    shared actual Path normalizedPath {
        return ConcretePath(jpath.normalize());
    }
    
    shared actual Path relativePath(String|Path path) {
        return ConcretePath(this.jpath.relativize(asJPath(path)));
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
                        value cp = copyPath(jpath, asJPath(dir.path));
                        if (is File file = ConcretePath(cp).resource) {
                            return file;
                        }
                        else {
                            throw Exception("copy failed");
                        }
                    }
                    shared actual File move(Directory dir) {
                        value mp = movePath(jpath, asJPath(dir.path));
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