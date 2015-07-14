"Represents tabular data. It is advised against the use of tables
 for layout purposes (use [[Div]] instead).
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-table-element)
 "
shared class Table(header = {}, rows = {}, footer = null,
            String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty)
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies ParentNode<TableElement> & BlockElement {

    shared {Th?*} header;

    shared {<Tr|Snippet<Tr>?>*} rows;

    shared {Tr?*}|Null footer;

    shared actual {<TableElement|{TableElement*}|Null>*} children
            => {
                THead(header),
                TBody(rows),
                footer exists then TFoot(footer else {})
            };

    tag = Tag("table");

}

"Represents the row that consist of the column labels
 ([[Th]] elements) for the parent [[Table]] element.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-thead-element)"
see(`value Table.header`)
class THead({Th?*} headers = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {Tr?*} children => { Tr { children = headers; } };

    tag = Tag("thead");

}

"Represents a block of rows ([[Tr]]) that consist of a body of data for
 the parent [[Table]] element.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-tbody-element)"
see(`value Table.rows`)
class TBody({<Tr|Snippet<Tr>?>*} rows = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {<Tr|Snippet<Tr>?>*} children = rows;

    tag = Tag("tbody");

}

"Represents the block of rows ([[Tr]]) that consist of the column ([[Td]])
 summaries (footers) for the parent [[Table]] element.
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-tfoot-element)"
see(`value Table.footer`)
class TFoot({Tr?*} rows = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {Tr?*} children = rows;

    tag = Tag("tfoot");

}

"Represents a row of cells ([[Td]]) in a [[Table]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-tr-element)"
shared class Tr(String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty, children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies ParentNode<Th|Td> & TableElement {

    shared actual {<Th|Td|{<Th|Td>*}|Snippet<Th|Td>|Null>*} children;

    tag = Tag("tr");

}

"Represents a header cell in a [[Table]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-th-element)"
shared class Th(text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty, children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & ParentNode<BlockOrInline> & TableElement {

    shared actual String text;

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("th");

}

"Represents a data cell in a [[Table]].
 
 Technical details about this element can be found on the
 [Official W3C reference](http://dev.w3.org/html5/spec/Overview.html#the-td-element)"
shared class Td(text = "", String? id = null, CssClass classNames = [],
            String? style = null, String? accessKey = null,
            String? contextMenu = null, TextDirection? dir = null,
            Boolean? draggable = null, DropZone? dropZone = null,
            Boolean? inert = null, Boolean? hidden = null,
            String? lang = null, Boolean? spellcheck = null,
            Integer? tabIndex = null, String? title = null,
            Boolean? translate = null, Aria? aria = null,
            NonstandardAttributes nonstandardAttributes = empty,
            DataContainer data = empty, children = {})
        extends BaseElement(id, classNames, style, accessKey, contextMenu,
            dir, draggable, dropZone, inert, hidden, lang, spellcheck,
            tabIndex, title, translate, aria, nonstandardAttributes, data)
        satisfies TextNode & ParentNode<BlockOrInline> & TableElement {

    shared actual String text;

    shared actual {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;

    tag = Tag("td");

}
