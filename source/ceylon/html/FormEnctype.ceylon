/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute that represents type of content that is used to submit the form to the server."
tagged("enumerated attribute")
shared class FormEnctype
        of applicationFormUrlEncoded | multipartFormData | textPlain
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Default. All characters are encoded before sent (spaces are converted to \"+\" symbols, and special characters are converted to ASCII HEX values)."
    shared new applicationFormUrlEncoded {
        attributeValue = "application/x-www-form-urlencoded";
    }
    
    "No characters are encoded. This value is required when you are using forms that have a file upload control."
    shared new multipartFormData {
        attributeValue = "multipart/form-data";
    }
    
    "Spaces are converted to \"+\" symbols, but no special characters are encoded."
    shared new textPlain {
        attributeValue = "text/plain";
    }
    
}
