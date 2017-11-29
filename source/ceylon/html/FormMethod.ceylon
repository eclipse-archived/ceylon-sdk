/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute specifies the HTTP method that the browser uses to submit the form."
tagged("enumerated attribute")
shared class FormMethod
        of get | post 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "The data from the form are appended to the form attribute URI, with a '?' as a 
     separator, and the resulting URI is sent to the server. Use this method when 
     the form has no side-effects and contains only ASCII characters."
    shared new get {
        attributeValue = "get";
    }
    
    "The data from the form is included in the body of the form and is sent to the server."
    shared new post {
        attributeValue = "post";
    }
    
}
