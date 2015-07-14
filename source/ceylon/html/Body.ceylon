"Represents the main content of the [[ceylon.html::Document]].
 
 Technical details about this element can be found on the
 [Official W3C reference] (http://dev.w3.org/html5/spec/Overview.html#the-body-element-0)"
shared class Body(String? id = null, CssClass classNames = [],
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
        satisfies ParentNode<BlockOrInline|Script> {

    shared actual {<String|BlockOrInline|Null|Script|Snippet<BlockOrInline>|
            {String|BlockOrInline*}|{Script*}>*} children;

    tag = Tag("body");

}
