
doc "Represents a URI Path part"
by "Stéphane Épardaud"
shared class Path(absolute = false, segments) {
    
    doc "The list of path segments"
    PathSegment* segments;
    
    doc "True if this Path is absolute (begins with a `/`)"
    shared Boolean absolute;
    
    //doc "Adds a path segment"
    //shared void add(String segment, Parameter* parameters) {
    //    PathSegment part = PathSegment(segment);
    //    for(Parameter p in parameters){
    //        part.parameters.add(p);
    //    }
    //    segments.add(part);
    //}
    


    doc "Returns a path segment"    
    shared PathSegment? get(Integer i){
        return segments[i];
    }

//    doc "Remove a path segment"
//    shared void remove(Integer i){
//        segments.remove(i);
//    }
//
//    doc "Removes every path segment"
//    shared void clear(){
//        segments.clear();
//    }

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
        if(absolute){
            b.appendCharacter('/');
        }
        variable Integer i = 0;
        for(PathSegment segment in segments){
            if(i++ > 0){
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
}
