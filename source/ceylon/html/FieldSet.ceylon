"Represents a group of form controls, optionally described by
 a [[FieldSet.legend]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-fieldset-element)"
shared class FieldSet(legend = null, String? id = null, CssClass classNames = [],
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
        satisfies BlockElement & ParentNode<BlockOrInline> {

    shared Legend? legend;

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("fieldset");

}

"Represents a caption for the rest of the contents
 of the parent [[FieldSet]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-legend-element)"
shared class Legend(text = "", String? id = null, CssClass classNames = [],
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
        satisfies TextNode & ParentNode<InlineElement> {

    shared actual String text;

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag = Tag("legend");

}
