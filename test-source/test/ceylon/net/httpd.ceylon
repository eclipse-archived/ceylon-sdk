import ceylon.test { assertEquals }
import ceylon.net.httpd {  newInstance, StatusListener, Status, started, WebEndpointAsync }
import ceylon.net.httpd { WebEndpoint, HttpResponse, HttpRequest}
import ceylon.net.http { Request }
import ceylon.net.uri { parseURI }
import ceylon.net.httpd.endpoints { StaticFileEndpoint }
import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8 }

by "Matej Lazar"

String fileContent = "The quick brown fox jumps over the lazy dog.\n";
Integer fileLines = 10;
String fileName = "lazydog.txt";

//TODO closing file problem
Boolean loadTestEnabled = false;

void testServer() {
    
    function name(HttpRequest request) => request.parameter("name") else "world";
    void serviceImpl(HttpRequest request, HttpResponse response) {
        response.addHeader("content-type", "text/html");
        response.writeString("Hello ``name(request)``!");
    }

    value server = newInstance();

    server.addWebEndpoint(WebEndpoint {
        service => serviceImpl;
        path = "/echo";
    });

    //add fileEndpoint
    creteTestFile();
    StaticFileEndpoint staticFileEndpoint = StaticFileEndpoint();
    staticFileEndpoint.externalPath = ".";
    server.addWebEndpoint(WebEndpointAsync {
        service => staticFileEndpoint.service;
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
    
    value request = Request(parseURI("http://localhost:8080/echo?name=" + name));
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
        value fileRequest = Request(parseURI("http://localhost:8080/file/``fileName``"));
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
