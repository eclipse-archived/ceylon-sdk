import ceylon.net.iop { eq }

doc "Represents a URI path segment or query parameter"
by "Stéphane Épardaud"
shared class Parameter(name, val = null) {
    shared String name;
    shared String? val;
    
    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human){
        if(exists String val = val){
            return human then name + "=" + val
                else percentEncoder.encodePathSegmentParamName(name) + "=" + percentEncoder.encodePathSegmentParamName(val);
        }else{
            return percentEncoder.encodePathSegmentParamName(name);
        }
    }

    doc "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }

    doc "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }

    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Parameter that){
            if(this === that){
                return true;
            }
            return name == that.name
                && eq(val, that.val);
        }
        return false;
    }
}
