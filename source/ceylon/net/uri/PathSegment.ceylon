import ceylon.collection { LinkedList }

doc "Represents a URI Path segment part"
by "Stéphane Épardaud"
shared class PathSegment(String initialName, Parameter* initialParameters) {
    
    doc "The path segment name"
    shared variable String name = initialName;
    
    doc "The path segment paramters"
    shared LinkedList<Parameter> parameters = LinkedList<Parameter>();
    
    for(Parameter p in initialParameters){
        parameters.add(p);
    }

    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is PathSegment that){
            if(this === that){
                return true;
            }
            return name == that.name
                && parameters.equalsTemp(that.parameters);
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
