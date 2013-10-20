

""
shared class Html(doctype = html5, head = Head(), body = Body(), String? id = null)
        extends Element(id)
        satisfies ParentNode<Head|Body> & Document {
    
    shared actual Doctype doctype;
    
    shared Head head;
    
    shared Body body;
    
    shared actual {<Head|Body>*} children = { head, body };
    
    tag = Tag("html");
    
}
