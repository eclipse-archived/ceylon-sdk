import ceylon.collection {
    LinkedList,
    StringBuilder
}

"Represents a URI Path part"
by("Stéphane Épardaud")
shared class Path(
    Boolean initialAbsolute = false, 
    PathSegment* initialSegments) {
    
    "The list of path segments"
    shared LinkedList<PathSegment> segments 
            = LinkedList<PathSegment>();
    
    "True if this URI is absolute (begins with a `/`)"
    shared variable Boolean absolute = initialAbsolute;
    
    for(s in initialSegments) {
        segments.add(s);
    }

    "Adds a path segment"
    shared void add(String segment, Parameter* parameters) {
        PathSegment part = PathSegment(segment);
        for(p in parameters) {
            part.parameters.add(p);
        }
        segments.add(part);
    }
    
    "Adds a raw (percent-encoded) segment, with optional 
     parameters to be parsed"
    shared void addRawSegment(String part) {
        Integer? sep = part.firstOccurrence(';');
        String name;
        if(exists sep) {
            name = part[0..sep-1];
        }else{
            name = part;
        }
        PathSegment path = PathSegment(decodePercentEncoded(name));
        if(exists sep) {
            for(param in part[sep+1...].split((Character ch) => ch == ';', true, false)) {
                path.parameters.add(parseParameter(param));
            }
        }
        segments.add(path);
    }

    "Returns a path segment"    
    shared PathSegment? get(Integer i) {
        return segments[i];
    }

    "Remove a path segment"
    shared void remove(Integer i) {
        segments.delete(i);
    }

    "Removes every path segment"
    shared void clear() {
        segments.clear();
    }

    "Returns true if the given object is the same as this 
     object"
    shared actual Boolean equals(Object that) {
        if(is Path that) {
            if(this === that) {
                return true;
            }
            return absolute == that.absolute
                && segments == that.segments; 
        }
        return false;
    }
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + absolute.hash;
        hash = 31*hash + segments.hash;
        return hash;
    }
    
    "Returns either an externalisable (percent-encoded) or 
     human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) { 
        if(segments.empty) {
            return "";
        }
        value b = StringBuilder();
        if(absolute) {
            b.appendCharacter('/');
        }
        variable Integer i = 0;
        for(segment in segments) {
            if(i++ > 0) {
                b.appendCharacter('/');
            }
            b.append(segment.toRepresentation(human));
        }
        return b.string;
    }

    "Returns an externalisable (percent-encoded) 
     representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }

    "Returns a human (non parseable) representation of this 
     part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }
}
