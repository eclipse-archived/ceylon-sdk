import ceylon.collection { LinkedList }

doc "Represents a URI Path part.\n
     Segments represent / (slash) separated elements.
     To define an absolute path, the first segment must have empty name. 
     To create absolute path, use [[absolutePath]], it adds an empty named segment in front of given path segments.\n
     To define folder like path (ending with slash), the last segment must have empty name. 
     To crete folder like paths, use [[absoluteFolderPath]] or [[relativeFolderPath]], they add an empty named segment at the end."
by ("Stéphane Épardaud", "Matej Lazar")
shared class Path(segments) {
    doc "The list of path segments"
    shared PathSegment* segments;
    
    doc "True if this Path is absolute (begins with a `/`)"
    shared Boolean absolute {
        if (exists first = segments.first) {
            return first.name.equals("");
        }
        return false;
    }
    
    shared Boolean specified = segments.size > 0;
    
    doc "Returns new Path object with path segment added."
    shared Path add(String segment, Parameter* parameters) {
        LinkedList<PathSegment> newSegments = LinkedList<PathSegment>();
        newSegments.addAll(*segments);
        newSegments.add(PathSegment(segment, *parameters));
        return Path(*newSegments);
    }

    doc "Returns new Path object without removed path segment."
    shared Path remove(Integer i) {
        LinkedList<PathSegment> newSegments = LinkedList<PathSegment>();
        newSegments.addAll(*segments);
        newSegments.remove(i);
        return Path(*newSegments);
    }
    
    doc "Returns a path segment"    
    shared PathSegment? get(Integer i) {
        return segments[i];
    }
    
    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Path that){
            if(this === that){
                return true;
            }
            return absolute == that.absolute
                && segments.equals(that.segments); 
        }
        return false;
    }
    
    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) { 
        if(segments.empty){
            return "";
        }
        StringBuilder b = StringBuilder();
        for(i -> segment in entries(segments)){
            if(i > 0){
                b.appendCharacter('/');
            }
            b.append(segment.toRepresentation(human));
        }
        return b.string;
    }

    doc "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }

    doc "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }
    
    doc "Returns new Path with resolved dot segments."
    shared Path noDotSegments {
        LinkedList<PathSegment> noDotSegments = LinkedList<PathSegment>();
        for (i -> segment in entries(segments)) {
            if (segment.name.equals(".")) {
                //if last
                if (i == segments.size-1) {
                    noDotSegments.add(folder);
                }
                continue;
            }
            if (segment.name.equals("..")) {
                if (exists lastIndex = noDotSegments.lastIndex) {
                    //do not remove first element, it must be absolute marker
                    if (lastIndex > 0) {
                        noDotSegments.remove(lastIndex);
                    }
                    //if last
                    if (i == segments.size-1) {
                        noDotSegments.add(folder);
                    }
                }  
                continue;
            }
            noDotSegments.add(segment);
        }
        return Path(*noDotSegments);
    }
    

    doc "Returns absolute Path by applying [[relative]] to this.
         If [[relative]] is absolute path, it is returned."
    shared Path resolve(Path relative) {
        if (!relative.absolute) {
            //remove last element as it is empty (folder flag) or "file"
            return Path(*join(segments[...segments.size-2], relative.segments)).noDotSegments;
        }
        return relative;
    }
    
    doc "Truncate given base from absolute Path.
         If this Path is relative, this is returned."
    shared Path relativePart(Path base) {
        if (!absolute) {
            return this;
        }
        
        Path baseFolderPath = base.noDotSegments.folderPath;

        variable Integer matchIndex = 0;
        for (i -> segment in entries(noDotSegments.segments)) {
            if (exists baseSegment = baseFolderPath.segments[i]) {
                if (!segment.equals(baseSegment)) {
                    matchIndex = i;
                    break;
                }
            }
        }
        
        LinkedList<PathSegment> upDirs = LinkedList<PathSegment>(); 
        //do not count last element (folder marker)
        variable Integer upDir = (baseFolderPath.segments.size - 1 ) - matchIndex;
        while (upDir > 0) {
            upDirs.add(PathSegment(".."));
            upDir--;
        }
        
        return Path(*join(upDirs, segments[matchIndex...]));
    }
    
    shared Path folderPath {
        if (exists last = segments.last) {
            if (last.name.empty) {
                return Path(*segments);
            } else {
                return Path(*join(segments[...segments.size], {folder}));
            }
        } else {
            return Path(folder);
        }
    }
}

doc "Creates absolute path, begining with /(slash)."
shared Path absolutePath(PathSegment* segments) => Path(*join({absolute}, segments));

doc "Creates relative path, begining and ending without /(slash)."
shared Path relativePath(PathSegment* segments) => Path(*segments);

doc "Creates absolute folder path, begining with /(slash) and ending with /(slash)."
shared Path absoluteFolderPath(PathSegment* segments) => Path(*join({absolute}, segments, {folder}));

doc "Creates folder path, ending with /(slash)."
shared Path relativeFolderPath(PathSegment* segments) => Path(*join(segments, {folder}));
