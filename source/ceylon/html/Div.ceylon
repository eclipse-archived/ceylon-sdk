"""This element has no special meaning, but it's very useful for
   semantic element grouping as a *block*. Basically a `div`
   represents its children, using CSS classes to mark up semantics
   common to a group of consecutive elements (like a gallery of
   image thumbs, for example):

   ```
   Div {
       classNames = "gallery";
       Div {
           classNames = "thumb";
       },
       // ... more thumbs
       Div {
           classNames = "thumb";
       }
   }

   ```
   If you want to group elements in a inline manner, see [[Span]]
   
   Technical details about this element can be found on the
   [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-div-element)
   """
shared class Div(text = "", String? id = null, CssClass classNames = [],
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
        satisfies TextNode & BlockElement & ParentNode<BlockOrInline> {

    shared actual String text;

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("div");

}
