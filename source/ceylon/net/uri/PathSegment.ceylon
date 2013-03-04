import ceylon.collection { LinkedList }
doc "Represents a URI Path segment part"
by "Stéphane Épardaud"
shared class PathSegment(name, parameters) {
    
    doc "The path segment name"
    shared String name;
    
    doc "The path segment paramters"
    shared Parameter* parameters;
    
    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is PathSegment that){
            if(this === that){
                return true;
            }
            return name == that.name
                && parameters.equals(that.parameters);
        }
        return false;
    }
    
    String serialiseParameter(Parameter param, Boolean human){
        if(human){
            return param.toRepresentation(true);
        }
        if(exists String val = param.val){
            return percentEncoder.encodePathSegmentParamName(param.name)
                    + "=" + percentEncoder.encodePathSegmentParamValue(val);
        }else{
            return percentEncoder.encodePathSegmentParamName(param.name);
        }
    }
    
    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"
    shared String toRepresentation(Boolean human) { 
        if(parameters.empty){
            return human then name else percentEncoder.encodePathSegmentName(name);
        }else{
            StringBuilder b = StringBuilder();
            b.append(human then name else percentEncoder.encodePathSegmentName(name));
            for(Parameter param in parameters){
                b.appendCharacter(';');
                b.append(serialiseParameter(param, human));
            }
            return b.string;
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
}

doc "Parses a raw (percent-encoded) segment, with optional parameters"
shared PathSegment parseRaw(String part){

    Integer? sep = part.firstCharacterOccurrence(';');
    String name;
    if(exists sep){
        name = part[0..sep-1];
    }else{
        name = part;
    }
    
    LinkedList<Parameter> parameters = LinkedList<Parameter>();
    if(exists sep){
        for(String param in part[sep+1...].split((Character ch) => ch == ';', true, false)){
            parameters.add(parseParameter(param));
        }
    }
    return PathSegment(decodePercentEncoded(name), *parameters);
}
