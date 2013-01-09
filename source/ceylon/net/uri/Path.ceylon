import ceylon.collection { LinkedList }

doc "Represents a URI Path part"
by "Stéphane Épardaud"
shared class Path(Boolean initialAbsolute = false, PathSegment... initialSegments) {
    
    doc "The list of path segments"
    shared LinkedList<PathSegment> segments = LinkedList<PathSegment>();
    
    doc "True if this URI is absolute (begins with a `/`)"
    shared variable Boolean absolute = initialAbsolute;
    
    for(PathSegment s in initialSegments){
        segments.add(s);
    }

    doc "Adds a path segment"
    shared void add(String segment, Parameter... parameters) {
        PathSegment part = PathSegment(segment);
        for(Parameter p in parameters){
            part.parameters.add(p);
        }
        segments.add(part);
    }
    
    doc "Adds a raw (percent-encoded) segment, with optional parameters to be parsed"
    shared void addRawSegment(String part){
        Integer? sep = part.firstCharacterOccurrence(`;`);
        String name;
        if(exists sep){
            name = part[0..sep-1];
        }else{
            name = part;
        }
        PathSegment path = PathSegment(decodePercentEncoded(name));
        if(exists sep){
            for(String param in part[sep+1...].split((Character ch) ch == `;`, true, false)){
                path.parameters.add(parseParameter(param));
            }
        }
        segments.add(path);
    }

    doc "Returns a path segment"    
    shared PathSegment? get(Integer i){
        return segments[i];
    }

    doc "Remove a path segment"
    shared void remove(Integer i){
        segments.remove(i);
    }

    doc "Removes every path segment"
    shared void clear(){
        segments.clear();
    }

    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Path that){
            if(this === that){
                return true;
            }
            return absolute == that.absolute
                && segments.equalsTemp(that.segments); 
        }
        return false;
    }
    
    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) { 
        if(segments.empty){
            return "";
        }
        StringBuilder b = StringBuilder();
        if(absolute){
            b.appendCharacter(`/`);
        }
        variable Integer i = 0;
        for(PathSegment segment in segments){
            if(i++ > 0){
                b.appendCharacter(`/`);
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
}
