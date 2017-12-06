/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute that represents the type of identifiers an ordered list will display."
tagged ("enumerated attribute")
shared class OlType
        of decimal | lowerAlpha | lowerRoman | upperAlpha | upperRoman
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "An ordered list type that uses decimal identifiers (1, 2, 3…)."
    shared new decimal {
        attributeValue = "1";
    }
    
    "An ordered list type that uses lower-case, alphabetical identifiers (a, b, c, d…)."
    shared new lowerAlpha {
        attributeValue = "a";
    }
    
    "An ordered list type that uses lower-case, Roman numeral identifiers (i, ii, iii, iv…)."
    shared new lowerRoman {
        attributeValue = "i";
    }
    
    "An ordered list type that uses upper-case, alphabetical identifiers (A, B, C, D…)."
    shared new upperAlpha {
        attributeValue = "A";
    }
    
    "An ordered list type that uses upper-case, Roman numeral identifiers (I, II, III, IV…)."
    shared new upperRoman {
        attributeValue = "I";
    }
    
}