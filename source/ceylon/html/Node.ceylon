import ceylon.html.serializer { NodeSerializer }

"Represents a single node in the `Document` tree.
 This is the **base type** for the entire Document
 Object Model. More detailed info can be found at
 [DOM Level 2 Specification](http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/)"
see(`interface ParentNode`, `interface TextNode`, `interface Document`)
shared interface Node {

    "The tag name and type."
    shared formal Tag tag;

    shared actual String string {
        value builder = StringBuilder();
        NodeSerializer(builder.append).serialize(this);
        return builder.string;
    }

    shared default [<String->Object>*] attributes => empty;

}

"Marks a [[Node]] implementation as a possible parent of other nodes."
shared interface ParentNode<out Child>
        satisfies Node
            given Child satisfies Node {

    shared formal {<Child|String|{Child|String*}|Snippet<Child>|Null>*} children;

}

"Marks a [[Node]] implementation as a text container."
shared interface TextNode satisfies Node {

    shared formal String text;
    
}

"Represents the entire HTML document, this means that it holds
 the entire configuration and content.
 Conceptually, it is the root of the document tree."
shared interface Document of Html satisfies Node {

    "The Document Type Declaration associated with this document."
    shared formal Doctype doctype;

}
