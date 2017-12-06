/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"The __&lt;!DOCTYPE&gt;__ declaration."
shared class Doctype {
    
    String content;
    
    "Constructor."
    shared new (String content) {
        this.content = content;
    }
    
    "HTML5 doctype declaration."
    shared new html5 {
        content = """<!DOCTYPE html>""";
    }
    
    "This DTD contains all HTML elements and attributes, but does NOT INCLUDE presentational or deprecated elements (like font). Framesets are not allowed."
    shared new html4Strict {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01EN" "http:www.w3.org/TR/html4/strict.dtd">""";
    }
    
    "This DTD contains all HTML elements and attributes, INCLUDING presentational and deprecated elements (like font). Framesets are not allowed."
    shared new html4Transitional {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01 TransitionalEN" "http:www.w3.org/TR/html4/loose.dtd">""";
    }
    
    "This DTD is equal to HTML 4.01 Transitional, but allows the use of frameset content."
    shared new html4Frameset {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD HTML 4.01 FramesetEN" "http:www.w3.org/TR/html4/frameset.dtd">""";
    }
    
    "This DTD contains all HTML elements and attributes, but does NOT INCLUDE presentational or deprecated elements (like font). Framesets are not allowed. The markup must also be written as well-formed XML."
    shared new xhtml1Strict {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 StrictEN" "http:www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">""";
    }
    
    "This DTD contains all HTML elements and attributes, INCLUDING presentational and deprecated elements (like font). Framesets are not allowed. The markup must also be written as well-formed XML."
    shared new xhtml1Transitional {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 TransitionalEN" "http:www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">""";
    }
    
    "This DTD is equal to XHTML 1.0 Transitional, but allows the use of frameset content."
    shared new xhtml1Frameset {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.0 FramesetEN" "http:www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">""";
    }
    
    "This DTD is equal to XHTML 1.0 Strict, but allows you to add modules (for example to provide ruby support for East-Asian languages)."
    shared new xhtml11 {
        content = """<!DOCTYPE HTML PUBLIC "-W3CDTD XHTML 1.1EN" "http:www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">""";
    }
    
    string => content;
    
}