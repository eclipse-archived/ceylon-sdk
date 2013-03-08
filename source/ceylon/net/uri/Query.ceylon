
doc "Represents a URI Query part"
by "Stéphane Épardaud"
shared class Query(parameters) {
    
    doc "The list of query parameters"
    shared Parameter* parameters;
    
    doc "Returns true if we have any query parameter"
    shared Boolean specified {
        return !parameters.empty;
    }

    doc "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Query that){
            if(this === that){
                return true;
            }
            return parameters.equals(that.parameters); 
        }
        return false;
    }
    
    String serialiseParameter(Parameter param, Boolean human) {
        if(human){
            return param.toRepresentation(true);
        }
        if(exists String val = param.val){
            return percentEncoder.encodeQueryPart(param.name) + "=" + percentEncoder.encodeQueryPart(val);
        }else{
            return percentEncoder.encodeQueryPart(param.name);
        }
    }

    doc "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
    shared String toRepresentation(Boolean human) { 
        if(parameters.empty){
            return "";
        }
        StringBuilder b = StringBuilder();
        variable Integer i = 0;
        for(Parameter p in parameters){
            if(i++ > 0){
                b.appendCharacter('&');
            }
            b.append(serialiseParameter(p, human));
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
