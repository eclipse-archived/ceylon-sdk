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
    assertEquals
}


void testHtmlSerialization() {
    testPrettyPrintSerialization();
    testMinifiedSerialization();
}

object testData {
    
    shared Html emptyPage = Html();
    
    shared Html pageWithContent = Html {
        html5;
        Head {
            title = "page title";
        };
        Body {
            Div("page content")
        };
    };

}


void testPrettyPrintSerialization() {
    value expectedOutput = {
        testData.emptyPage ->
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
                   """,
        testData.pageWithContent ->
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
                   """
    };
    doTestExpectedOutput(expectedOutput, true);
}

void testMinifiedSerialization() {
    value expectedOutput = {
        testData.emptyPage ->
                "<!DOCTYPE html>
                 <html><head><title></title></head><body></body></html>",
        testData.pageWithContent ->
                "<!DOCTYPE html>
                 <html><head><title>page title</title></head>" +
                "<body><div>page content</div></body></html>"
    };
    doTestExpectedOutput(expectedOutput);
}

void doTestExpectedOutput(
        {<Node->String>+} expectedResults,
        Boolean prettyPrint = false) {
    for (node->string in expectedResults) {
        assertEquals(string.trimmed, serializeToString(node, prettyPrint));
    }
}

String serializeToString(Node node, Boolean prettyPrint) {
    value builder = StringBuilder();
    object serializer extends NodeSerializer(SerializerConfig(prettyPrint)) {
        print(String string) => builder.append(string);
    }
    serializer.serialize(node);
    return builder.string;
}
