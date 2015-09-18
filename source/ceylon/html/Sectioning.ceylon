"Represents a section of a page that consists of a composition
 that forms an independent part of a document. This could be a forum post,
 a magazine or newspaper article for example.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-article-element)"
shared class Article(String? id = null, CssClass classNames = [],
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

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("article");

}

"Represents a section of a page consisting of content that is
 tangentially related to the content around the aside element,
 and which could be considered separate from that content.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-article-element)"
shared class Aside(String? id = null, CssClass classNames = [],
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

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("aside");

}

"Represents the \"header\" of a document or section of a document.
 The header element is typically used to group a set of h1–h6 elements
 to mark up a page's title with its subtitle or tagline.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-header-element)"
shared class Header(String? id = null, CssClass classNames = [],
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
    
    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
    
    tag = Tag("header");
    
}

"Represents the \"footer\" of a document or section of a document.
 The footer element typically contains metadata about its enclosing section,
 such as who wrote it, links to related documents, copyright data, etc.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-footer-element)"
shared class Footer(String? id = null, CssClass classNames = [],
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
    
    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
    
    tag = Tag("footer");
    
}

"Represents navigation for a document. The nav element is a section containing
 links to other documents or to parts within the current document.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-nav-element)"
shared class Nav(String? id = null, CssClass classNames = [],
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
    
    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
    
    tag = Tag("nav");
    
}

"Represents a generic document or application section. In this context,
 a section is a thematic grouping of content, typically with a [[Header]],
 possibly with a [[Footer]]. Examples include chapters in a book or the various
 tabbed pages in a tabbed dialog box.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-section-element)"
shared class Section(String? id = null, CssClass classNames = [],
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
    
    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
    
    tag = Tag("section");
    
}
