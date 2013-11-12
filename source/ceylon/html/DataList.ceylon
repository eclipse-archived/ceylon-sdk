"Represents a set of option elements that represent predefined
 options for other controls. In the rendering, the datalist element
 represents nothing and it, along with its children, should be hidden.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-datalist-element)"
shared class DataList(String? id = null, CssClass classNames = [],
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
        satisfies InlineElement & ParentNode<Select|Option> {

    shared actual {<Select|Option|{<Select|Option>*}|Snippet<Select|Option>|Null>*} children;

    tag = Tag("datalist");

}
