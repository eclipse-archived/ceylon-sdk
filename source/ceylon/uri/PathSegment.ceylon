/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a URI Path segment part"
by("Stéphane Épardaud")
shared class PathSegment(
        "The path segment name"
        shared String name,
        "The path segment parameters"
        shared Parameter* parameters) {

    "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is PathSegment that) {
            if(this === that) {
                return true;
            }
            return name == that.name
                && parameters == that.parameters;
        }
        return false;
    }

    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + name.hash;
        hash = 31*hash + parameters.hash;
        return hash;
    }

    String serialiseParameter(Parameter param, Boolean human) {
        if(human) {
            return param.toRepresentation(true);
        }
        if(exists String val = param.val) {
            return percentEncoder.encodePathSegmentParamName(param.name)
                    + "=" + percentEncoder.encodePathSegmentParamValue(val);
        }else{
            return percentEncoder.encodePathSegmentParamName(param.name);
        }
    }

    "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"
    shared String toRepresentation(Boolean human) {
        if(parameters.empty) {
            return human then name else percentEncoder.encodePathSegmentName(name);
        }else{
            StringBuilder b = StringBuilder();
            b.append(human then name else percentEncoder.encodePathSegmentName(name));
            for(Parameter param in parameters) {
                b.appendCharacter(';');
                b.append(serialiseParameter(param, human));
            }
            return b.string;
        }
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
