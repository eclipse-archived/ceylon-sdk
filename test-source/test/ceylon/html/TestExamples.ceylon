import ceylon.html {
    ...
}
import ceylon.test {
    ...
}
import ceylon.collection {
    ArrayList
}

shared class TestExamples() {
    
    test
    shared void emptyHtml() {
        assertHtml(
            Html {},
            "<!DOCTYPE html>
             <html></html>\n"
        );
    }
    
    test
    shared void simpleHtml() {
        assertHtml(
            Html {
                Head {
                    Title { "foo" }
                },
                Body {
                    Div { "bar" }
                }
            },
            "<!DOCTYPE html>
             <html>
               <head>
                 <title>foo</title>
               </head>
               <body>
                 <div>bar</div>
               </body>
             </html>\n"
        );
    }
    
    test
    shared void mixedContent() {
        assertHtml(
            Div { "Some text", Span{"world"}, "!" },
            "<div>Some text<span>world</span>!</div>\n"
        );
        assertHtml(
            P { "This is a paragraph containing ", B{"boldened"}, "text!" },
            "<p>This is a paragraph containing <b>boldened</b>text!</p>\n"
        );
        assertHtml(
            Div { "foo", Comment("bar"), "baz" },
            "<div>foo<!-- bar -->baz</div>\n"
        );
        assertHtml(
            Div { null },
            "<div></div>\n"
        );
        assertHtml(
            Div { () => "foo" },
            "<div>foo</div>\n"
        );
        assertHtml(
            Div { () => {"foo", Span {"bar"}, "baz" } },
            "<div>foo<span>bar</span>baz</div>\n"
        );
        assertHtml(
            Div { "Raw HTML:", Raw("<div></div>") },
            "<div>Raw HTML:<div></div></div>\n"
        );
    }
    
    test
    shared void lazyContent() {
        value list = ArrayList<String>();
        list.add("foo");
        
        value ul = Ul {
            list.map((e) => Li { e })
        };
        
        assertHtml(
            ul,
            "<ul>
               <li>foo</li>
             </ul>\n"
        );
        
        list.add("bar");
        
        assertHtml(
            ul,
            "<ul>
               <li>foo</li>
               <li>bar</li>
             </ul>\n"
        );
    }
    
    test
    shared void ifExpression() {
        value n = 1;
        assertHtml(
            Div {
                if (n == 1) then "one" else "bug"
            },
            "<div>one</div>\n"
        );
    }
    
    test
    shared void switchExpression() {
        value n = 2;
        assertHtml(
            Div {
                switch (n)
                    case (0) "zero"
                    case (1) "one"
                    else "many"
            },
            "<div>many</div>\n"
        );
    }
    
    test
    shared void comprehension() {
        assertHtml(
            Ul {
                for(n in 1..3 )
                    Li { n.string }
            },
            "<ul>
               <li>1</li>
               <li>2</li>
               <li>3</li>
             </ul>\n"
        );
    }
    
    test
    shared void layout() {
        function myPage(Content<FlowCategory> content) =>
            Html {
                Head {
                    Title { "MyApp" },
                    Meta { charset="utf-8"; },
                    Link { href = "/resources/style.css"; rel = "stylesheet"; }
                },
                Body {
                    Div { clazz="content";
                        content
                    },
                    Div { clazz="footer";
                        "All Rights Reserved."
                    }
                }
            };
        
        assertHtml(
            myPage(H1{"Welcome in MyApp!"}), 
            "<!DOCTYPE html>
             <html>
               <head>
                 <title>MyApp</title>
                 <meta charset=\"utf-8\">
                 <link href=\"/resources/style.css\" rel=\"stylesheet\">
               </head>
               <body>
                 <div class=\"content\">
                   <h1>Welcome in MyApp!</h1>
                 </div>
                 <div class=\"footer\">All Rights Reserved.</div>
               </body>
             </html>\n"
            );
    }
    
    void assertHtml(Node node, String expected)
            => assertEquals(node.string, expected);
    
}
