import ceylon.collection {
    HashMap,
    unmodifiableMap
}

interface EscapableType of
        name, attributeValue,
        text, rawText, escapableRawText {

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
    Map<Character, String> entities = unmodifiableMap(HashMap {
        '\'' -> "&#39;",
        '"' -> "&quot;",
        '&' -> "&amp;"});
}

// "Normal elements can have text, character references, other elements,
//      and comments, but the text must not contain the character "<" (U+003C)
//      or an ambiguous ampersand. Some normal elements also have yet more
//      restrictions on what content they are allowed to hold, beyond the
//      restrictions imposed by the content model and those described in this
//      paragraph. Those restrictions are described below.
object text satisfies EscapableType {
    shared actual
    Map<Character, String> entities = unmodifiableMap(HashMap {
        '<' -> "&lt;",
        '&' -> "&amp;"});
}

// http://www.w3.org/TR/html5/scripting-1.html#restrictions-for-contents-of-script-elements
// http://www.w3.org/TR/html5/syntax.html#cdata-rcdata-restrictions
// "Raw text elements can have text, though it has restrictions described below"
object rawText satisfies EscapableType {
    shared actual
    Map<Character, String> entities = emptyMap;
}

// http://www.w3.org/TR/html5/syntax.html#cdata-rcdata-restrictions
// "Escapable raw text elements can have text and character references,
//      but the text must not contain an ambiguous ampersand. There are
//      also further restrictions described below"
// We will treat escapableRawText as text, and escape '<', thereby
// avoiding the "further restrictions".
// TODO: <textarea> and <title> actually cannot contain elements; open elements are parsed as text
object escapableRawText satisfies EscapableType {
    shared actual
    Map<Character, String> entities = unmodifiableMap(HashMap {
        '<' -> "&lt;",
        '&' -> "&amp;"});
}

\Itext | \IrawText | \IescapableRawText typeForElement(String element)
    =>  let (lower = element.lowercased)
        if (rawTextElements.contains(lower)) then
            rawText
        else if (escapableRawTextElements.contains(lower)) then
            escapableRawText
        else
            text;
