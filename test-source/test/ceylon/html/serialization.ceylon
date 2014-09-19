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


shared test void testPrettyPrintSerialization() {
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

shared test void testMinifiedSerialization() {
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
        assertEquals(string.trimmed.replace("\n", operatingSystem.newline), serializeToString(node, prettyPrint));
    }
}

String serializeToString(Node node, Boolean prettyPrint) {
    value builder = StringBuilder();
    value serializer = NodeSerializer(builder.append, 
            SerializerConfig(prettyPrint));
    serializer.serialize(node);
    return builder.string;
}
