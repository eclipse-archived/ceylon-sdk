import ceylon.html {
    ...
}
import ceylon.test {
    ...
}

shared class TestAttributes() {
    
    test
    shared void attributeName() {
        assertHtml(
            Div { attributes = ["att"->"0"]; },
            "<div att=\"0\"></div>\n");
        assertHtml(
            Div { attributes = ["a.tt"->"0"]; },
            "<div a.tt=\"0\"></div>\n");
        assertHtml(
            Div { attributes = ["汉字"->"0"]; },
            "<div 汉字=\"0\"></div>\n");
    }
    
    test
    shared void invalidAttributeName() {
        assertInvalidHtml(Div { attributes = ["att<"->"0"]; });
        assertInvalidHtml(Div { attributes = ["att>"->"0"]; });
        assertInvalidHtml(Div { attributes = ["att\'"->"0"]; });
        assertInvalidHtml(Div { attributes = [".att"->"0"]; });
    }
    
    test
    shared void attributeValue() {
        assertHtml(
            Div { attributes = ["att"->"content"]; }, 
            "<div att=\"content\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"汉字"]; }, 
            "<div att=\"汉字\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"<"]; }, 
            "<div att=\"<\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->">"]; }, 
            "<div att=\">\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"&"]; }, 
            "<div att=\"&amp;\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"'"]; }, 
            "<div att=\"&#39;\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"\""]; }, 
            "<div att=\"&quot;\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"multi\nline"]; }, 
            "<div att=\"multi\nline\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"trailing sp "]; }, 
            "<div att=\"trailing sp \"></div>\n");
        assertHtml(
            Div { attributes = ["att"->" leading sp"]; }, 
            "<div att=\" leading sp\"></div>\n");
        assertHtml(
            Div { attributes = ["att"->"line1\nline2\rline3\r\rline5\r\nline6\r\r\nline9\n\rline12"]; }, 
            "<div att=\"line1\nline2\nline3\n\nline5\nline6\n\nline9\n\nline12\"></div>\n");
    }
    
    test
    shared void emptyAttribute() {
        assertHtml(
            A { href = ""; },
            "<a href=\"\"></a>\n");
        assertHtml(
            Div { attributes = ["att"->""]; },
            "<div att=\"\"></div>\n");
    }
    
    test
    shared void asciiAttributeName() {
        value div = Div { attributes = ["汉字"->"10"]; };
        assertInvalidHtml{
            node = div; 
            escapeNonAscii = true;};
        assertHtml{
            node = div; 
            expected= "<div 汉字=\"10\"></div>\n"; 
            escapeNonAscii = false;};
    }
    
    test
    shared void asciiAttributeValue() {
        value div = Div { attributes = ["att"->"汉字"]; };
        assertHtml{
            node = div; 
            expected= "<div att=\"&#27721;&#23383;\"></div>\n"; 
            escapeNonAscii = true;};
        assertHtml{
            node = div; 
            expected= "<div att=\"汉字\"></div>\n"; 
            escapeNonAscii = false;};
    }
    
    test
    shared void booleanAttribute() {
        assertHtml(
            Div { draggable = true; spellcheck = true; translate = true; },
            "<div draggable=\"draggable\" spellcheck=\"true\" translate=\"yes\"></div>\n");
        assertHtml(
            Div { draggable = false; spellcheck = false; translate = false; },
            "<div spellcheck=\"false\" translate=\"no\"></div>\n");
    }
    
    test
    shared void enumeratedAttribute() {
        assertHtml(
            Div { dir = Direction.ltr; dropZone = DropZone.move; },
            "<div dir=\"ltr\" dropzone=\"move\"></div>\n");
    }
    
    test
    shared void lazyAttribute() {
        variable value clazz = "foo";
        variable value hidden = true;
        
        value div = Div { clazz = () => clazz; hidden = () => hidden; };
        
        assertHtml(div, "<div class=\"foo\" hidden=\"hidden\"></div>\n");
        
        clazz = "bar";
        hidden = false;
        
        assertHtml(div, "<div class=\"bar\"></div>\n");
    }
    
    test
    shared void dontHoldAttributesWithNullValue() {
        assert (Div { }.attributes == empty);
        assert (Div { id = null; }.attributes == empty);
    }
    
    void assertHtml(Node node, String expected, Boolean escapeNonAscii = false) 
            => assertEquals(render(node, escapeNonAscii), expected);
    
    void assertInvalidHtml(Node node, Boolean escapeNonAscii = false) 
            => assertThatException(() => render(node, escapeNonAscii));
    
    String render(Node node, Boolean escapeNonAscii) {
        value builder = StringBuilder();
        renderTemplate(node, builder.append, RenderingConfiguration(true, escapeNonAscii));
        return builder.string;
    }
    
}
