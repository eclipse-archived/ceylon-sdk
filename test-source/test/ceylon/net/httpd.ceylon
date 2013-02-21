import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8 }
import ceylon.net.http { ClientRequest=Request }
import ceylon.net.httpd { createServer, StatusListener, Status, 
                          started, AsynchronousEndpoint, 
                          Endpoint, Response, Request }
import ceylon.net.httpd.endpoints { serveStaticFile }
import ceylon.net.uri { parseURI }
import ceylon.test { assertEquals }

by "Matej Lazar"

String fileContent = "The quick brown fox jumps over the lazy dog.\n";
Integer fileLines = 10;
String fileName = "lazydog.txt";

//TODO closing file problem
Boolean loadTestEnabled = false;

void testServer() {
    
    function name(Request request) => request.parameter("name") else "world";
    void serviceImpl(Request request, Response response) {
        response.addHeader("content-type", "text/html");
        response.writeString("Hello ``name(request)``!");
    }

    value server = createServer {};

    server.addEndpoint(Endpoint {
        service => serviceImpl;
        path = "/echo";
    });

    //add fileEndpoint
    creteTestFile();
    server.addEndpoint(AsynchronousEndpoint {
        service => serveStaticFile(".");
        path = "/file";
    });
    
    object httpdListerner satisfies StatusListener {
        shared actual void onStatusChange(Status status) {
            if (status.equals(started)) {
                try {
                    execuTestEcho();
                    
                    executeTestStaticFile(1);
                    if (loadTestEnabled) {
                        executeTestStaticFile(11000);
                    }
                } finally {
                    cleanUpFile();
                    server.stop();
                }
            }
        }
    }
    
    server.addListener(httpdListerner);
    server.startInBackground();
}

void execuTestEcho() {
    //TODO log debug
    print("Making request to Ceylon server...");
    
    String name = "Ceylon";
    
    value request = ClientRequest(parseURI("http://localhost:8080/echo?name=" + name));
    value response = request.execute();
    
    value contentTypeHeader = response.getSingleHeader("content-type");
    assertEquals("text/html", contentTypeHeader);
    
    value echoMsg = response.contents;
    //TODO log
    print("Received message: ``echoMsg``");
    assertEquals("Hello ``name``!", echoMsg);
}

void executeTestStaticFile(Integer executeRequests) {
    variable Integer request = 0;
    while(request < executeRequests) {
        value fileRequest = ClientRequest(parseURI("http://localhost:8080/file/``fileName``"));
        value fileResponse = fileRequest.execute();
        value fileCnt = fileResponse.contents;
        print("File content:``fileCnt``");
        assertEquals(produceFileContent(), fileCnt);
        request++;
    }
}

void creteTestFile() {
    Path path = parsePath(fileName);
    OpenFile file = newOpenFile(path.resource);
    file.writeFrom(stringToByteProducer(utf8, produceFileContent()));
    file.close();
}

String produceFileContent() {
    variable String content = "";
    variable value line = 0;
    while(line < fileLines) {
        content += "``line``. ``fileContent``";
        line++;
    }
    return content;
}

void cleanUpFile() {
    Path path = parsePath(fileName);
    if(is File f = path.resource){
        f.delete();
    }
}
