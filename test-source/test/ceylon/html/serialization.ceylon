import ceylon.html {
    Html,
    Node,
    Head,
    html5,
    Body,
    Div,
    Element,
    Tag,
    blockTag,
    TextNode,
    Span,
    ParentNode,
    BlockOrInline,
    Snippet,
    InlineElement,
    I,
    B,
    Pre,
    Cite,
    Strong,
    P,
    A
}
import ceylon.html.serializer {
    NodeSerializer,
    SerializerConfig
}
import ceylon.test {
    assertEquals,
    test,
    assertThatException
}

object testData {
    shared
    Html emptyPage = Html();

    shared
    Html pageWithContent = Html {
        html5;
        Head { title = "page title"; };
        Body { Div("page content") };
    };
}

shared test
void testPrettyPrintSimple() {
    runTest {
        prettyPrint = true;
        escapeNonAscii = false;
        actual = testData.emptyPage;
        expected =
           "<!DOCTYPE html>

            <html>
              <head>
                <title></title>
              </head>
              <body></body>
            </html>\n";
    };

    runTest {
        prettyPrint = true;
        escapeNonAscii = false;
        actual = testData.pageWithContent;
        expected =
           "<!DOCTYPE html>

            <html>
              <head>
                <title>page title</title>
              </head>
              <body>
                <div>page content</div>
              </body>
            </html>\n";
    };
}

shared test
void testSimple() {
    runTest {
        prettyPrint = false;
        escapeNonAscii = false;
        actual = testData.emptyPage;
        expected =
            "<!DOCTYPE html>
             <html><head><title></title></head><body></body></html>";
    };

    runTest {
        prettyPrint = false;
        escapeNonAscii = false;
        actual = testData.pageWithContent;
        expected =
            "<!DOCTYPE html>
             <html><head><title>page title</title></head>" +
            "<body><div>page content</div></body></html>";
    };
}

shared test
void testPrettyPrint() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, true, false);

    // indent block elements
    test(Div { Div { Div() } },
        "<div>
           <div>
             <div></div>
           </div>
         </div>\n");

    // don't indent inline elements
    test(Span { Span { Span() } },
        "<span><span><span></span></span></span>\n");

    // don't indent close tag immediately following open tag
    test(Div { Div { } },
        "<div>
           <div></div>
         </div>\n");

    // indent block elements inside inline elements and vice-versa
    test(Span { Custom { "div"; { Span() } } },
       "<span>
          <div>
            <span></span>
          </div>
        </span>\n");

    // don't indent inline elements following text
    test(Span { Custom { "div"; "content"; { Span() } } },
       "<span>
          <div>content<span></span>
          </div>
        </span>\n");

    // don't indent block elements following text
    // increase indent depth even if some indents are suppressed
    test(Div { Div { "content"; { Div { Span { }} } } },
       "<div>
          <div>content<div>
              <span></span>
            </div>
          </div>
        </div>\n");

    // don't indent neighboring inline elements
    test(Div { B { I { } } },
       "<div>
          <b><i></i></b>
        </div>\n");

    // bug 356
    test(Span { B("Cey"), I("lon") },
       "<span><b>Cey</b><i>lon</i></span>\n");

    // bug 356
    test(Div { B("Cey"), I("lon") },
       "<div>
          <b>Cey</b><i>lon</i>
        </div>\n");

    // bug 356 #2
    test(Div { Pre("a\nb  \nc") },
        "<div>
           <pre>a
         b  
         c</pre>
         </div>\n");
}

shared test
void testNonPrettyPrint() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    // bug 356 #3 don't eat whitespace
    test(Span { Span("a"), Span(" "), Span("b") },
        "<span><span>a</span><span> </span><span>b</span></span>");
}

shared test
void testAttributeName() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    function testThrows(Node actual)
        =>  runTestException(actual, false, false);

    test(Div { nonstandardAttributes = [ "att" -> "0" ]; },
            "<div att=\"0\"></div>");

    test(Div { nonstandardAttributes = [ "汉字" -> "0" ]; },
            "<div 汉字=\"0\"></div>");

    // illegal name characters
    testThrows(Div { nonstandardAttributes = [ "att<" -> "0" ]; });
    testThrows(Div { nonstandardAttributes = [ "att>" -> "0" ]; });
    testThrows(Div { nonstandardAttributes = [ "att\'" -> "0" ]; });
    testThrows(Div { nonstandardAttributes = [ ".att" -> "0" ]; });
    test(Div { nonstandardAttributes = [ "a.tt" -> "0" ]; },
        "<div a.tt=\"0\"></div>");
}

shared test
void testText() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    test(Div("content"), "<div>content</div>");
    test(Div("content汉字"), "<div>content汉字</div>");
    test(Div("<"), "<div>&lt;</div>");
    test(Div("&"), "<div>&amp;</div>");
    test(Div(">'\" "), "<div>>'\" </div>");
    test(Div("<,>,&,',\", "), "<div>&lt;,>,&amp;,',\", </div>");
}

shared test
void testAttributeValue() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    test(Div { nonstandardAttributes = ["att"->"content"]; }, "<div att=\"content\"></div>");
    test(Div { nonstandardAttributes = ["att"->"汉字"]; }, "<div att=\"汉字\"></div>");
    test(Div { nonstandardAttributes = ["att"->"<"]; }, "<div att=\"<\"></div>");
    test(Div { nonstandardAttributes = ["att"->">"]; }, "<div att=\">\"></div>");
    test(Div { nonstandardAttributes = ["att"->"&"]; }, "<div att=\"&amp;\"></div>");
    test(Div { nonstandardAttributes = ["att"->"'"]; }, "<div att=\"&#39;\"></div>");
    test(Div { nonstandardAttributes = ["att"->"\""]; }, "<div att=\"&quot;\"></div>");
    test(Div { nonstandardAttributes = ["att"->"multi\nline"]; }, "<div att=\"multi\nline\"></div>");
    test(Div { nonstandardAttributes = ["att"->"trailing sp "]; }, "<div att=\"trailing sp \"></div>");
    test(Div { nonstandardAttributes = ["att"->" leading sp"]; }, "<div att=\" leading sp\"></div>");
}

shared test
void testEmptyAttribute() {
    function test(Node actual, String expected)
            =>  runTest(actual, expected, false, false);
    
    test(Div { nonstandardAttributes = ["att"->""]; }, "<div att=\"\"></div>");
    test(A { href = ""; }, "<a href=\"\"></a>");
}

shared test
void testRawText() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    function testThrows(Node actual)
        =>  runTestException(actual, false, false);

    // don't escape
    test(Custom("script", "汉字"), "<script>汉字</script>");
    test(Custom("script", "<>&'\""), "<script><>&'\"</script>");

    // don't allow "</tagName" or "<!--"
    testThrows(Custom("script", "xx </script xx"));
    testThrows(Custom("script", "xx <!-- xx"));
}

shared test
void testEscapableRawText() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    // only need to escape < and &
    test(Custom("textarea", "汉字"), "<textarea>汉字</textarea>");
    test(Custom("textarea", ">'\""), "<textarea>>'\"</textarea>");
    test(Custom("textarea", "<&"), "<textarea>&lt;&amp;</textarea>");

    // allow, but escape "</tagName" or "<!--"
    test(Custom("textarea", "xx </textarea xx"), "<textarea>xx &lt;/textarea xx</textarea>");
    test(Custom("textarea", "xx <!-- xx"), "<textarea>xx &lt;!-- xx</textarea>");
}

shared test
void testNewlines() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    value input = "line1\nline2\rline3\r\rline5\r\nline6\r\r\nline9\n\rline12";
    value expected = "line1\nline2\nline3\n\nline5\nline6\n\nline9\n\nline12";

    // attribute value
    test(Div { nonstandardAttributes = ["att"->input]; }, "<div att=\"``expected``\"></div>");

    // div text (text)
    test(Div(input), "<div>``expected``</div>");

    // script text (rawText)
    test(Custom("script", input), "<script>``expected``</script>");

    // textarea text (escapableRawText)
    test(Custom("textarea", input), "<textarea>``expected``</textarea>");
}

shared test
void testAscii() {
    function testAsciiThrows(Node actual)
        =>  runTestException(actual, false, true);

    function testAscii(Node actual, String expected)
        =>  runTest(actual, expected, false, true);

    function testUtf8(Node actual, String expected)
        =>  runTest(actual, expected, false, false);

    // non-ascii attribute name
    value t1 = Div { nonstandardAttributes = [ "汉字" -> "10" ]; };
    testAsciiThrows(t1);
    testUtf8(t1, "<div 汉字=\"10\"></div>");

    // non-ascii attribute value
    value t2 = Div { nonstandardAttributes = [ "att" -> "汉字" ]; };
    testAscii(t2, "<div att=\"&#27721;&#23383;\"></div>");
    testUtf8(t2, "<div att=\"汉字\"></div>");

    // non-ascii text (text)
    value t3 = Div("汉字");
    testAscii(t3, "<div>&#27721;&#23383;</div>");
    testUtf8(t3, "<div>汉字</div>");

    // non-ascii rawText (can't escape, don't allow)
    value t4 = Custom("script", "汉字");
    testAsciiThrows(t4);
    testUtf8(t4, "<script>汉字</script>");

    // non-ascii escapableRawText
    value t5 = Custom("textarea", "汉字");
    testAscii(t5, "<textarea>&#27721;&#23383;</textarea>");
    testUtf8(t5, "<textarea>汉字</textarea>");
}

shared test
void testMixedContent() {
    function test(Node actual, String expected)
        =>  runTest(actual, expected, true, false);

    // bug #344
    test(Div { "Some text", Cite("world"), "!" },
        "<div>Some text<cite>world</cite>!</div>\n");

    // bug #346
    test(P { "This is a paragraph containing ",
            Strong("boldened"), "text!" },
        "<p>This is a paragraph containing <strong>boldened</strong>text!</p>\n");
}

shared test
void testEscapingBug403Utf8() {
    runTest {
        prettyPrint = false;
        escapeNonAscii = false;
        actual = Div { id="»"; "»" };
        expected =
           """<div id="»">»</div>""";
    };
}

shared test
void testEscapingBug403Ascii() {
    runTest {
        prettyPrint = false;
        escapeNonAscii = true;
        actual = Div { id="»"; "»" };
        expected =
           """<div id="&#187;">&#187;</div>""";
    };
}

void runTest(Node actual, String expected, Boolean prettyPrint, Boolean escapeNonAscii) {
    assertEquals(serializeToString(actual, prettyPrint, escapeNonAscii), expected);
}

void runTestException(Node actual, Boolean prettyPrint, Boolean escapeNonAscii) {
    assertThatException(() => serializeToString(actual, prettyPrint, escapeNonAscii));
}

String serializeToString(Node node, Boolean prettyPrint, Boolean escapeNonAscii) {
    value builder = StringBuilder();
    value serializer = NodeSerializer(builder.append,
            SerializerConfig(prettyPrint, html5, escapeNonAscii));
    serializer.serialize(node);
    return builder.string;
}

class Custom(
        String tagName,
        shared actual String text = "",
        shared actual [<String->Object>*] attributes = [],
        String? id = null,
        children = {})
        extends Element(id)
        satisfies TextNode & InlineElement & ParentNode<BlockOrInline> {

    shared actual
    Tag tag = Tag(tagName, blockTag);

    shared actual
    {<String|BlockOrInline|{String|BlockOrInline*}|Snippet<BlockOrInline>|Null>*} children;
}
