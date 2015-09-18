"""This element has no special meaning, but it's very useful for
   semantic element grouping in a *inline* manner. Basically a `span`
   represents its children, using CSS classes to mark up semantics
   common to a group of consecutive elements (like a gallery of
   image thumbs, for example):

   ```
   Span {
       "Text";
       classNames = "label";
       Img {
           src = "images/close.png";
       }
   }
   ```

   If you want to group elements in a block, see [[Div]]

   Technical details about this element can be found on the
   [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-span-element)
   """
shared class Span(text = "", String? id = null, CssClass classNames = [],
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

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag = Tag("span");

}
