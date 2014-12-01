import ceylon.collection {
    LinkedList
}

"Represents a URI Path part"
by("Stéphane Épardaud")
shared class Path(String|{PathSegment*}? path = null, Boolean? initialAbsolute = null) {
    
    "The list of path segments"
    shared PathSegment[] segments;

    "True if this URI is absolute (begins with a `/`)"
    shared Boolean absolute;

    "Adds a raw (percent-encoded) segment, with optional 
     parameters to be parsed"
    void addRawSegment(String part, LinkedList<PathSegment> list) {
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
        list.add(path);
    }

    variable Boolean initAbsolute = false;
    switch (path)
    case (is Null) { segments = []; }
    case (is {PathSegment*}) { segments = path.sequence(); }
    case (is String) {
        if (path.empty) {
            segments = [];
        } else {
            value list = LinkedList<PathSegment>();
            variable Boolean first = true;
            for(String part in path.split((Character ch) => ch == '/', true, false)) {
                if(first && part.empty) {
                    initAbsolute = true;
                    first = false;
                    continue;
                }
                first = false;
                addRawSegment(part, list);
            }
            segments = list.sequence();
        }
    }
    absolute = initialAbsolute else initAbsolute;

    "Returns a path segment"
    shared PathSegment? get(Integer i) {
        return segments[i];
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
