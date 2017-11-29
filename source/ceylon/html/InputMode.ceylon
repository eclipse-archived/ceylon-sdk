/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Attribute represents a hint to the browser for which keyboard to display. 
 This attribute applies when the value of the type attribute is text, 
 password, email, or url."
tagged("enumerated attribute")
shared class InputMode
        of verbatim | latin | latinName | latinProse | fullWidthLatin | 
           kana | katakana | numeric | tel | email | url
        satisfies AttributeValueProvider {
    
    shared actual String attributeValue;
    
    "Alphanumeric, non-prose content such as usernames and passwords."
    shared new verbatim {
        attributeValue = "verbatim"; 
    }
    
    "Latin-script input in the user's preferred language with typing aids such as 
     text prediction enabled. For human-to-computer communication such as search boxes."
    shared new latin {
        attributeValue = "latin";
    }
    
    "As latin, but for human names."
    shared new latinName {
        attributeValue = "latin-name";
    }
    
    "As latin, but with more aggressive typing aids. For human-to-human communication 
     such as instant messaging or email."
    shared new latinProse {
        attributeValue = "latin-prose";
    }
    
    "As latin-prose, but for the user's secondary languages."
    shared new fullWidthLatin {
        attributeValue = "full-width-latin";
    }
    
    "Kana or romaji input, typically hiragana input, using full-width characters, with 
     support for converting to kanji. Intended for Japanese text input."
    shared new kana {
        attributeValue = "kana";
    }
    
    "Katakana input, using full-width characters, with support for converting to kanji. 
     Intended for Japanese text input."
    shared new katakana {
        attributeValue = "katakana";
    }
    
    "Numeric input, including keys for the digits 0 to 9, the user's preferred thousands 
     separator character, and the character for indicating negative numbers. Intended for 
     numeric codes, e.g. credit card numbers."
    shared new numeric {
        attributeValue = "numeric";
    }
    
    "Telephone input, including asterisk and pound key."
    shared new tel {
        attributeValue = "tel";
    }
    
    "Email input."
    shared new email {
        attributeValue = "email";
    }
    
    "URL input."
    shared new url {
        attributeValue = "url";
    }
    
}