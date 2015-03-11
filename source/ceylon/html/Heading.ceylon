"Base class for heading (h1-6) elements.
 They represent headings and subheadings in a [[Document]].
 These elements rank in importance according to the number in their name
 ([[Heading.level]]).
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-h1-h2-h3-h4-h5-and-h6-elements)"
see(`class H1`)
shared abstract class Heading(text = "", String? id = null, CssClass classNames = [],
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
        satisfies TextNode & BlockElement & ParentNode<InlineElement> & Comparable<Heading> {

    shared actual String text;

    shared formal Integer level;

    shared actual {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children;

    tag => Tag("h``level``");

    shared actual Comparison compare(Heading other) => level.compare(other.level);

}

"This is the highest level heading."
shared class H1(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 1;

}

"This is the level two heading."
shared class H2(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 2;

}

"This is the level three heading."
shared class H3(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 3;

}

"This is the level four heading."
shared class H4(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 4;

}

"This is the level 5 heading."
shared class H5(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 5;

}

"This is the lowest level heading."
shared class H6(String text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty,
            {<String|InlineElement|{String|InlineElement*}|Snippet<InlineElement>|Null>*} children = {})
        extends Heading(text, id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data, children) {

    level = 6;

}
