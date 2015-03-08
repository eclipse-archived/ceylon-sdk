
"Represents an abbreviation or acronym. The optional
 [[Abbr.title]] attribute may be used to provide an
 expansion of the abbreviation.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-abbr-element)"
shared class Abbr(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("abbr");

}

"Represents a span of text to be stylistically offset from the normal
 prose without conveying any extra importance. Examples are key words
 in a document abstract, product names in a review, or other spans of
 text whose typical typographic presentation is bold.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-b-element)"
shared class B(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("b");

}

"represents the title of a work (e.g. a book, a paper, an essay, a poem, a score, a song,
 a script, a film, etc). This can be a work that is being quoted or referenced in detail
 (i.e. a citation), or it can just be a work that is mentioned in passing.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-cite-element)"
shared class Cite(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("cite");

}

"The code element represents a fragment of computer code.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-code-element)"
shared class Code(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("code");
    
}

"Represents a removal from the document. The del elements should not
 cross implied paragraph boundaries.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-del-element)"
see(`class Ins`)
shared class Del(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("del");

}

"Represents the defining instance of a term. The paragraph,
 description list group, or section that is the nearest ancestor
 of the `dfn` element must also contain the definition(s) for the
 term given by the `dfn` element.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-dfn-element)"
shared class Dfn(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("dfn");

}

"Represents stress emphasis of its contents.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-em-element)"
shared class Em(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("em");

}

"Represents a span of text in an alternate voice or mood, or otherwise
 offset from the normal prose.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-i-element)"
shared class I(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("i");

}

"Represents an addition to the document. The ins elements should
 not cross implied paragraph boundaries.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-ins-element)"
see(`class Del`)
shared class Ins(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("ins");

}

"Represents user input (typically keyboard input, although
 it may also be used to represent other input, such as voice commands).

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-kbd-element)"
shared class Kbd(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("kbd");

}

"Represents a run of text in one document marked or highlighted
 because of its relevance in another context.

 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-mark-element)"
shared class Mark(text = "", String? id = null, CssClass classNames = [],
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

    tag = Tag("mark");

}

"Represents some phrasing content quoted from another source.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-q-element)"
shared class Q(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("q");
    
}

"Represents contents that are no longer accurate or no longer relevant.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-s-element)"
shared class S(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("s");
    
}

"Represents (sample) output from a program or computing system.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-samp-element)"
shared class Samp(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("samp");
    
}

"Represents side comments such as small print. It is not intended to be presentational.
 It is only intended for short runs of text.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-small-element)"
shared class Small(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("small");
    
}

"Represents strong importance for its contents.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-strong-element)"
shared class Strong(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("strong");
    
}

"Represents a subscript of its contents.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-sub-and-sup-elements)"
shared class Sub(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("sub");
    
}

"Represents a superscript of its contents.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-sub-and-sup-elements)"
shared class Sup(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("sup");
    
}

"Represents a span of text with an unarticulated, though explicitly rendered,
 non-textual annotation, such as labeling the text as being a proper name
 in a foreign language.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-u-element)"
shared class U(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("u");
    
}

"Represents a variable. This could be an actual variable in a
 mathematical expression or programming context, or it could
 just be a term used as a placeholder in prose.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-var-element)"
shared class Var(text = "", String? id = null, CssClass classNames = [],
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
    
    tag = Tag("var");
    
}
