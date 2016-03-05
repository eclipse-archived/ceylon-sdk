"
 The __&lt;wbr&gt;__ element represents _word break opportunity_ a position within 
 text where the browser may optionally break a line, though its line-breaking rules 
 would not otherwise create a break at that location.
 
 Technical details about this element can be found on the
 [Official W3C reference](https://www.w3.org/TR/html5/text-level-semantics.html#the-wbr-element).
"
tagged("flow", "phrasing")
shared class Wbr() 
        extends Element("wbr") 
        satisfies FlowCategory & PhrasingCategory {
    "This element has no children."
    shared actual [] children = [];
}