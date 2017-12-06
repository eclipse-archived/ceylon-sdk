import ceylon.html {
    ...
}
import ceylon.test {
    ...
}

shared class TestEscaping() {
    
    test
    shared void text() {
        assertHtml(
            Div { "content" },
            "<div>content</div>"
        );
        assertHtml(
            Div { "content汉字" },
            "<div>content汉字</div>"
        );
        assertHtml(
            Div { "<" },
            "<div>&lt;</div>"
        );
        assertHtml(
            Div { "&" },
            "<div>&amp;</div>"
        );
        assertHtml(
            Div { ">'\" " },
            "<div>>'\" </div>"
        );
        assertHtml(
            Div { "<,>,&,',\", " },
            "<div>&lt;,>,&amp;,',\", </div>"
        );
    }
    
    test
    shared void rawText() {
        assertHtml(
            Script { "汉字" },
            "<script>汉字</script>"
        );
        assertHtml(
            Script { "<>&'\"" },
            "<script><>&'\"</script>"
        );
        
        assertInvalidHtml(
            Script { "xx </script xx" }
        );
        assertInvalidHtml(
            Script { "xx <!-- xx" }
        );
    }
    
    test
    shared void escapableRawText() {
        assertHtml(
            TextArea { "汉字" },
            "<textarea>汉字</textarea>"
        );
        assertHtml(
            TextArea { ">'\"" },
            "<textarea>>'\"</textarea>"
        );
        assertHtml(
            TextArea { "<&" },
            "<textarea>&lt;&amp;</textarea>"
        );
        assertHtml(
            TextArea { "xx </textarea xx" },
            "<textarea>xx &lt;/textarea xx</textarea>"
        );
        assertHtml(
            TextArea { "xx <!-- xx" },
            "<textarea>xx &lt;!-- xx</textarea>"
        );
    }
    
    test
    shared void ascii() {
        value div = Div { "汉字" };
        assertHtml {
            node = div;
            expected = "<div>&#27721;&#23383;</div>";
            escapeNonAscii = true;
        };
        assertHtml {
            node = div;
            expected = "<div>汉字</div>";
            escapeNonAscii = false;
        };
        
        value script = Script { "汉字" };
        assertInvalidHtml {
            node = script;
            escapeNonAscii = true;
        };
        assertHtml {
            node = script;
            expected = "<script>汉字</script>";
            escapeNonAscii = false;
        };
        
        value textarea = TextArea { "汉字" };
        assertHtml {
            node = textarea;
            expected = "<textarea>&#27721;&#23383;</textarea>";
            escapeNonAscii = true;
        };
        assertHtml {
            node = textarea;
            expected = "<textarea>汉字</textarea>";
            escapeNonAscii = false;
        };
    }
    
    test
    shared void newlines() {
        value input = "line1\nline2\rline3\r\rline5\r\nline6\r\r\nline9\n\rline12";
        value expected = "line1\nline2\nline3\n\nline5\nline6\n\nline9\n\nline12";
        
        assertHtml(
            Div { input },
            "<div>``expected``</div>"
        );
        assertHtml(
            Script { input },
            "<script>``expected``</script>"
        );
        assertHtml(
            TextArea { input },
            "<textarea>``expected``</textarea>"
        );
    }
    
    test
    shared void bug403() {
        value div = Div { id="»"; "»" };
        assertHtml {
            node = div;
            expected = """<div id="&#187;">&#187;</div>""";
            escapeNonAscii = true;
        };
        assertHtml {
            node = div;
            expected = """<div id="»">»</div>""";
            escapeNonAscii = false;
        };
    }
    
    void assertHtml(Node node, String expected, Boolean escapeNonAscii = false) 
            => assertEquals(render(node, escapeNonAscii), expected);
    
    void assertInvalidHtml(Node node, Boolean escapeNonAscii = false) 
            => assertThatException(() => render(node, escapeNonAscii));
    
    String render(Node node, Boolean escapeNonAscii) {
        value builder = StringBuilder();
        renderTemplate(node, builder.append, RenderingConfiguration(false, escapeNonAscii));
        return builder.string;
    }
    
}