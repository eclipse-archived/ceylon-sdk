/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a URI path segment or query parameter"
by("Stéphane Épardaud")
shared class Parameter(name, val = null) {
    shared String name;
    shared String? val;

    "Returns either an externalisable (percent-encoded) or human (non parseable) representation of this part"
    shared String toRepresentation(Boolean human) {
        if(exists String val = val) {
            return human then name + "=" + val
                else percentEncoder.encodePathSegmentParamName(name) + "=" + percentEncoder.encodePathSegmentParamName(val);
        }else{
            return percentEncoder.encodePathSegmentParamName(name);
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

    "Returns true if the given object is the same as this object"
    shared actual Boolean equals(Object that) {
        if(is Parameter that) {
            if(this === that) {
                return true;
            }
            return name == that.name
                && eq(val, that.val);
        }
        return false;
    }

    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + name.hash;
        hash = 31*hash + (val?.hash else 0);
        return hash;
    }
}
