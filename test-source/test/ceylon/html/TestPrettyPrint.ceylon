import ceylon.html {
    ...
}
import ceylon.test {
    ...
}

shared class TestPrettyPrint() {
    
    test
    shared void shouldIndentBlockElements() {
        assertHtml(
            Div {
                Div {
                    Span { }
                }
            },
            "<div>
               <div>
                 <span></span>
               </div>
             </div>\n"
        );
    }
    
    test
    shared void shouldNotIndentInlineElements() {
        assertHtml(
            Span { Span { Span { } } },
            "<span><span><span></span></span></span>\n"
        );
    }
    
    test
    shared void shouldNotIndentCloseTagImmediatelyFollowingOpenTag() {
        assertHtml(
            Div {
                Div { }
            },
            "<div>
               <div></div>
             </div>\n"
        );
    }
    
    test
    shared void shouldNotIndentInlineElementsFollowingText() {
        assertHtml(
            Div {
                "foo", Span { "bar" }
            },
            "<div>foo<span>bar</span>
             </div>\n"
        );
    }
    
    test
    shared void shouldNotIndentNeighboringInlineElements() {
        assertHtml(
            Div {
                B { I { } }
            },
            "<div>
               <b><i></i></b>
             </div>\n"
        );
    }
    
    test
    shared void shouldNotEatWhitespace() {
        assertHtml(
            Span { Span { "a" }, Span { " " }, Span { "b" } },
            "<span><span>a</span><span> </span><span>b</span></span>\n"
        );
    }
    
    test
    shared void bug356() {
        assertHtml(
            Span { B { "Cey" }, I { "lon" } },
            "<span><b>Cey</b><i>lon</i></span>\n"
        );
        
        assertHtml(
            Div {
                B { "Cey" }, I { "lon" }
            },
            "<div>
               <b>Cey</b><i>lon</i>
             </div>\n"
        );
        
        assertHtml(
            Div {
                Pre { "a\nb  \nc" }
            },
            "<div>
               <pre>a
             b  
             c</pre>
             </div>\n"
        );
    }
    
    test
    shared void dontPrettifyWithinPre() {
        assertHtml(
            Div{ Pre { Code {"foo" } } },
            "<div>
               <pre><code>foo</code></pre>
             </div>\n"
        );
    }

    test
    shared void closeVoidElementsDefault() {
        value config = RenderingConfiguration { };
        value builder = StringBuilder();
        value node = Div { Br(),Hr(),Br() };
        renderTemplate(node, builder.append, config);
        assertEquals {
            expected = builder.string; 
            actual = 
               "<div>
                  <br>
                  <hr>
                  <br>
                </div>\n";
        };
    }

    test
    shared void closeVoidElementsTrue() {
        value config = RenderingConfiguration { closeVoidElements = true; };
        value builder = StringBuilder();
        value node = Div { Br(),Hr(),Br() };
        renderTemplate(node, builder.append, config);
        assertEquals {
            expected = builder.string; 
            actual = 
               "<div>
                  <br />
                  <hr />
                  <br />
                </div>\n";
        };
    }
    
    void assertHtml(Node node, String expected) 
            => assertEquals(node.string, expected);
    
}