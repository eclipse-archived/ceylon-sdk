/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
interface EscapableType of
        name | attributeValue |
        text | rawText | escapableRawText {

    shared formal
    Map<Character, String> entities;
}

object name satisfies EscapableType {
    shared actual
    Map<Character, String> entities = emptyMap;

    // http://www.w3.org/TR/REC-xml/#NT-Name
    // much more liberal than the HTML5 spec, but more realistic
    shared
    Boolean isValid(String name)
        =>  if (exists first = name.first,
                xmlNameStartCharRanges.any((range)
                    =>  range.containsElement(first.integer)),
                name.rest.every((c)
                    =>  xmlNameCharRanges.any((range)
                        =>  range.containsElement(c.integer))))
            then true
            else false;
}

object attributeValue satisfies EscapableType {
    shared actual
    Map<Character, String> entities = map {
        '\'' -> "&#39;",
        '"' -> "&quot;",
        '&' -> "&amp;"};
}

"From <http://www.w3.org/TR/html5/syntax.html#elements-0>
 > Normal elements can have text, character references, other elements,
 and comments, but the text must not contain the character \"<\" (U+003C)
 or an ambiguous ampersand."
object text satisfies EscapableType {
    shared actual
    Map<Character, String> entities = map {
        '<' -> "&lt;",
        '&' -> "&amp;"};
}

"From <http://www.w3.org/TR/html5/syntax.html#elements-0>
 > Raw text elements can have text, though it has
 restrictions described below

 From <http://www.w3.org/TR/html5/syntax.html#cdata-rcdata-restrictions>
 > The text in raw text and escapable raw text elements must not contain
 any occurrences of the string \"&lt;/\" (U+003C LESS-THAN SIGN, U+002F SOLIDUS)
 followed by characters that case-insensitively match the tag name of the element
 followed by one of \"tab\" (U+0009), \"LF\" (U+000A), \"FF\" (U+000C),
 \"CR\" (U+000D), U+0020 SPACE, \">\" (U+003E), or \"/\" (U+002F).

 From <http://www.w3.org/TR/html5/scripting-1.html#restrictions-for-contents-of-script-elements>
 > Note: The easiest and safest way to avoid the rather strange restrictions
 described in this section is to always escape \"&lt;!--\" as \"&lt;\\!--\",
 \"<script\" as \"&lt;\\script\", and \"&lt;/script\" as \"&lt;\\/script\"
 when these sequences appear in literals in scripts..."
object rawText satisfies EscapableType {
    shared actual
    Map<Character, String> entities = emptyMap;
}

"From <http://www.w3.org/TR/html5/syntax.html#elements-0>
 > Escapable raw text elements can have text and character references, but
 the text must not contain an ambiguous ampersand. There are also further
 restrictions described below.

 We will treat escapableRawText as text, and escape '<', thereby
 avoiding the \"further restrictions\"."
object escapableRawText satisfies EscapableType {
    shared actual
    Map<Character, String> entities = map {
        '<' -> "&lt;",
        '&' -> "&amp;"};
}

\Itext | \IrawText | \IescapableRawText typeForElement(String element)
    =>  let (lower = element.lowercased)
        if (lower in rawTextElements)
            then rawText
        else if (lower in escapableRawTextElements)
            then escapableRawText
        else text;
