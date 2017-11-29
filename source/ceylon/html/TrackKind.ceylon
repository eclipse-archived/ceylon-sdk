/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute that defines how the text track is meant to be used."
tagged ("enumerated attribute")
shared class TrackKind
        of subtitles | captions | descriptions | chapters | metadata
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Subtitles provide translation of content that cannot be understood by the viewer. 
     For example dialogue or text that is not English in an English language film."
    shared new subtitles {
        attributeValue = "subtitles";
    }
    
    "Captions provide a transcription and possibly a translation of audio."
    shared new captions {
        attributeValue = "captions";
    }
    
    "Textual description of the video content."
    shared new descriptions {
        attributeValue = "descriptions";
    }
    
    "Chapter titles are intended to be used when the user is navigating the media resource."
    shared new chapters {
        attributeValue = "chapters";
    }
    
    "Tracks used by scripts. Not visible to the user."
    shared new metadata {
        attributeValue = "metadata";
    }
}
