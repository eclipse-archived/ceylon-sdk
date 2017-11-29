/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute indicating the directionality of the element's text."
tagged("enumerated attribute")
shared class Direction
        of ltr | rtl | auto
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Means left to right and is to be used for languages that are written 
     from the left to the right (like English)."
    shared new ltr {
        attributeValue = "ltr";
    }
    
    "Means right to left and is to be used for languages that are written 
     from the right to the left (like Arabic)."
    shared new rtl {
        attributeValue = "rtl";
    }
    
    "Let the user agent decides. It uses a basic algorithm as it parses 
     the characters inside the element until it finds a character with a strong 
     directionality, then apply that directionality to the whole element."
    shared new auto {
        attributeValue = "auto";
    }
    
}
