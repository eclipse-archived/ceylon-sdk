import ceylon.html {
    Html,
    Node,
    Head,
    html5,
    Body,
    Div
}
import ceylon.html.serializer {
    NodeSerializer,
    SerializerConfig
}
import ceylon.test {
    assertEquals,
    test
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
            """
               <!DOCTYPE html>

               <html>
                   <head>
                       <title>
                       </title>
                   </head>
                   <body>
                   </body>
               </html>
               """;
    };

    runTest {
        prettyPrint = true;
        escapeNonAscii = false;
        actual = testData.pageWithContent;
        expected =
            """
               <!DOCTYPE html>

               <html>
                   <head>
                       <title>
                           page title
                       </title>
                   </head>
                   <body>
                       <div>
                           page content
                       </div>
                   </body>
               </html>
               """;
    };
}

shared test
void testSimple() {
    runTest {
        prettyPrint = true;
        escapeNonAscii = false;
        actual = testData.emptyPage;
        expected =
            "<!DOCTYPE html>
             <html><head><title></title></head><body></body></html>";
    };

    runTest {
        prettyPrint = true;
        escapeNonAscii = false;
        actual = testData.pageWithContent;
        expected =
            "<!DOCTYPE html>
             <html><head><title>page title</title></head>" +
            "<body><div>page content</div></body></html>";
    };
}

void runTest(Node actual, String expected, Boolean prettyPrint, Boolean escapeNonAscii) {
    assertEquals(serializeToString(actual, prettyPrint, escapeNonAscii), expected);
}

String serializeToString(Node node, Boolean prettyPrint, Boolean escapeNonAscii) {
    value builder = StringBuilder();
    value serializer = NodeSerializer(builder.append, 
            SerializerConfig(prettyPrint, html5, escapeNonAscii));
    serializer.serialize(node);
    return builder.string;
}
