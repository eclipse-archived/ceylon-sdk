import ceylon.language.meta {
    type
}

"Represents a single node in the `Document` tree.
 This is the **base type** for the entire Document
 Object Model. More detailed info can be found at
 [DOM Level 2 Specification](http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/)"
see(`interface ParentNode`, `interface TextNode`, `interface Document`)
shared interface Node {

    "The tag name, which textually represents this node.
     The default implementation guess the tag name from the
     [[ceylon.language.meta.model::ClassModel]] declaration
     name in lowercase. So unless you need a name that doesn't
     match the class name, you don't need to overwrite it."
    shared default String tagName {
        variable value tag = type(this).declaration.name;
        if (exists lastDot = tag.lastOccurrence(".")) {
            tag = tag[(lastDot + 1)...];
        }
        return tag.lowercased;
    }

    "The tag name and type."
    shared default Tag tag => Tag(tagName);

}

""
shared interface ParentNode<out Child>
        satisfies Node
            given Child satisfies Node {

    shared formal {<Child|{Child*}|Snippet<Child>|Null>*} children;

}


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

