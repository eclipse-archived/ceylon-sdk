import ceylon.language.meta {
    type
}

"Represents a node in the `Document` tree."
see(`interface ParentNode`, `interface TextNode`, `interface Document`)
shared interface Node {

    shared default String tagName {
        variable value tag = type(this).declaration.name;
        if (exists lastDot = tag.lastOccurrence(".")) {
            tag = tag[(lastDot + 1)...];
        }
        return tag.lowercased;
    }

    shared default Tag tag => Tag(tagName);

}

shared interface ParentNode<out Child>
        satisfies Node
            given Child satisfies Node {

    shared formal {<Child|{Child*}|Snippet<Child>|Null>*} children;

}


shared interface TextNode satisfies Node {
    
    shared formal String text;
    
}

""
shared interface Document satisfies Node {
    
    shared formal Doctype doctype;
    
    shared formal Node root;
    
}

//shared alias HtmlNode => Node|{Node*}|[Node*];

