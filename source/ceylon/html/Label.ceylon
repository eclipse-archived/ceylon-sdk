
"Represents a caption in a user interface. The caption can be
 associated with a specific form control (through the [[Label.forControl]]
 attribute).
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-label-element)"
shared class Label(text = "", forControl = null, form = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & InlineElement & ParentNode<InlineElement> {

    shared actual String text;

    "Specifies which form control a label is bound to."
    shared String? forControl;

    "Specifies one or more forms the label belongs to."
    shared String? form;

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag = Tag("label");

    shared actual [<String->Object>*] attributes {
        value attrs = AttributeSequenceBuilder();
        attrs.addAttribute("for", forControl);
        attrs.addAttribute("form", form);
        attrs.addAll(super.attributes);
        return attrs.sequence();
    }

}
