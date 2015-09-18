import ceylon.html {
    Node,
    Html,
    Element,
    TextNode,
    ParentNode,
    Snippet
}

shared class NodeSerializer(
    "A stream to direct output to"
    void print(String string),
    "Serialization options"
    SerializerConfig config = SerializerConfig()
) {
    value htmlSerializer = HtmlSerializer(
            print, config.prettyPrint, config.escapeNonAscii);

    shared void serialize(Node root) => visit(root);

    void visitAny(Node|String|{Node|String*}|Snippet<Node> child) {
        switch (child)
        case (is String) {
            visitString(child);
        }
        case (is Node) {
            visit(child);
        }
        else {
            switch (child)
            case (is Snippet<Node>) {
                if (exists content = child.content) {
                    visitAny(content);
                }
            }
            else { // is {Node|String*} 
                visitNodes(child);
            }
        }
    }

    void visitString(String string) {
        htmlSerializer.text(string);
    }

    void visit(Node node) {
        if (is Html node) {
            htmlSerializer.doctype(node.doctype.string);
        }
        openTag(node);
        if (is TextNode node) {
            htmlSerializer.text(node.text);
        }
        if (is ParentNode<Node> node) {
            for (child in node.children) {
                if (exists child) {
                    visitAny(child);
                }
            }
        }
        closeTag(node);
    }

    void openTag(Node node) {
        value attributes =
                if (is Element node)
                then node.attributes
                else {};

        // for now, duplicate bug that drops attributes
        // with empty value
        value nonEmptyAttributes = attributes
            .map((attribute) => attribute.key->attribute.item.string)
            .filter((attribute) => !attribute.item.empty);

        htmlSerializer.startElement(node.tag.name, nonEmptyAttributes);
    }

    void closeTag(Node node)
        =>  htmlSerializer.endElement();

    void visitNodes({Node|String*} nodes) {
        for (node in nodes) {
            switch (node)
            case (is String) {
                visitString(node);
            }
            case (is Node) {
                visit(node);
            }
        }
    }
}

"A [[NodeSerializer]] implementation that prints content on console."
shared NodeSerializer consoleSerializer = NodeSerializer(process.write);
