/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute indicating what types of content can be dropped on an element."
tagged("enumerated attribute")
shared class DropZone 
        of copy | move | link 
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Indicates that dropping will create a copy of the element that was dragged."
    shared new copy {
        attributeValue = "copy";
    }
    
    "Indicates that the element that was dragged will be moved to this new location."
    shared new move {
        attributeValue = "move";
    }
    
    "Create a link to the dragged data."
    shared new link {
        attributeValue = "link";
    }
    
}
