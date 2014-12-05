"Represents a URI Path part"
by("Stéphane Épardaud")
shared class Path(
    absolute = false,
    PathSegment* initialSegments) {

    "The list of path segments"
    shared PathSegment[] segments = initialSegments.sequence();

    "True if this URI is absolute (begins with a `/`)"
    shared Boolean absolute;

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
