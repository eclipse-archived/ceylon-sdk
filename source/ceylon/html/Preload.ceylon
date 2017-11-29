/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute is intended to provide a hint to the browser about what the author thinks 
 will lead to the best user experience."
tagged("enumerated attribute")
shared class Preload
        of none | metadata | auto 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Indicates that the audio should not be preloaded."
    shared new none {
        attributeValue = "none";
    }
    
    "Indicates that only audio metadata (e.g. length) is fetched."
    shared new metadata {
        attributeValue = "metadata";
    }
    
    "Indicates that the whole audio file could be downloaded, even 
     if the user is not expected to use it."
    shared new auto {
        attributeValue = "auto";
    }
    
}