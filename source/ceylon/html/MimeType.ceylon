/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute is used to define the MIME type of the content."
tagged("enumerated attribute")
shared class MimeType satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Constructor."
    shared new (String mimeType) {
        attributeValue = mimeType;
    }
    
    "text/css"
    shared new textCss {
        attributeValue = "text/css";
    }
    
    "text/html"
    shared new textJavascript {
        attributeValue = "text/javascript";
    }
    
}