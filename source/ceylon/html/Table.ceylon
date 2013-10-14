
shared class Table(header = {}, rows = {}, footer = null)
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

}

"Represents the header element of the HTML table."
class THead({Th?*} headers = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {Tr?*} children => { Tr(headers) };

}

"Represents the body element of the HTML table."
class TBody({<Tr|Snippet<Tr>?>*} rows = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {<Tr|Snippet<Tr>?>*} children = rows;

}

"Represents the footer element of the HTML table."
class TFoot({Tr?*} rows = {})
        satisfies ParentNode<Tr> & TableElement {

    shared actual {Tr?*} children = rows;

}

shared class Tr(children = {})
        satisfies ParentNode<Th|Td> & TableElement {

    shared actual {Th|Td?*} children;

}

shared class Th(text = "", children = {})
        satisfies TextNode & ParentNode<BlockElement> & TableElement {

    shared actual String text;

    shared actual {<BlockElement|{BlockElement*}?>*} children;

}

shared class Td(text = "", children = {})
        satisfies TextNode & ParentNode<BlockElement> & TableElement {

    shared actual String text;

    shared actual {<BlockElement|{BlockElement*}?>*} children;

}
