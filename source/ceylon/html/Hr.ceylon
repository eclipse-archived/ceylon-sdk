"
 The __&lt;hr&gt;__ element represents a thematic break between paragraph-level 
 elements (for example, a change of scene in a story, or a shift of topic with a section). 
 In previous versions of HTML, it represented a horizontal rule. It may still be 
 displayed as a horizontal rule in visual browsers, but is now defined in semantic 
 terms, rather than presentational terms.
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/text-level-semantics.html#the-hr-element).
"
tagged("flow")
shared class Hr() 
        extends Element("hr") 
        satisfies FlowCategory {
    "This element has no children."
    shared actual [] children = [];
}