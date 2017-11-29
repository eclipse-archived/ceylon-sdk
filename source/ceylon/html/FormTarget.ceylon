/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute is a keyword indicating where to display the response that is received after submitting the form."
tagged("enumerated attribute")
shared class FormTarget
        of self | blank | parent | top
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Load the response into the same browsing context as the current one. 
     This value is the default if the attribute is not specified."
    shared new self {
        attributeValue = "_self";
    }
    
    "Load the response into a new unnamed browsing context."
    shared new blank {
        attributeValue = "_blank";
    }
    
    "Load the response into the parent browsing context of the current one. 
     If there is no parent, this option behaves the same way as self."
    shared new parent {
        attributeValue = "_parent";
    }
    
    "Load the response into the top-level browsing context (that is, 
     the browsing context that is an ancestor of the current one, and has no parent). 
     If there is no parent, this option behaves the same way as self."
    shared new top {
        attributeValue = "_top";
    }
    
}
