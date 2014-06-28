import ceylon.collection { LinkedList, StringBuilder }

"Represents a URI Query part"
by("Stéphane Épardaud")
shared class Query(Parameter* initialParameters) {
    
    "The list of query parameters"
    shared LinkedList<Parameter> parameters = LinkedList<Parameter>();
    
    for(Parameter p in initialParameters){
        parameters.add(p);
    }

    "Adds a query parameter"
    shared void add(Parameter param){
        parameters.add(param);
    }

    "Adds a single raw (percent-encoded) query parameter, where name and value have to be parsed"
    shared void addRaw(String part){
        add(parseParameter(part));
    }

    "Returns true if we have any query parameter"
    shared Boolean specified {
        return !parameters.empty;
    }

    "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Query that){
            if(this === that){
                return true;
            }
            return parameters == that.parameters; 
        }
        return false;
    }
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + parameters.hash;
        return hash;
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

    "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"    
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

    "Returns an externalisable (percent-encoded) representation of this part"    
    shared actual String string {
        return toRepresentation(false);
    }
    
    "Returns a human (non parseable) representation of this part"    
    shared String humanRepresentation {
        return toRepresentation(true);
    }
}
