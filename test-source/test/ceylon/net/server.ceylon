import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8, ascii }
import ceylon.net.uri { parse }
import ceylon.net.http.client { ClientRequest=Request }
import ceylon.net.http.server { createServer, StatusListener, Status, 
                                  started, AsynchronousEndpoint, 
                                  Endpoint, Response, Request, 
                                  startsWith, endsWith, Options }
import ceylon.net.http.server.endpoints { serveStaticFile }
import ceylon.test { assertEquals, assertTrue }
import java.lang { Runnable, Thread }
import ceylon.collection { LinkedList }
import ceylon.net.http { contentType }


by "Matej Lazar"

String fileContent = "The quick brown fox jumps over the lazy dog.\n";

doc "How many lines of default text to write to file."
Integer fileLines = 10;

String fileName = "lazydog.txt";

doc "Number of concurent requests"
Integer numberOfUsers=10;
Integer requestsPerUser = 10;

void testServer() {
    
    function name(Request request) => request.parameter("name") else "world";
    void serviceImpl(Request request, Response response) {
        response.addHeader(contentType { contentType = "text/html"; charset = ascii; });
        response.writeString("Hello ``name(request)``!");
    }

    value server = createServer {};

    server.addEndpoint(Endpoint {
        service => serviceImpl;
        path = startsWith("/echo"); //TODO endpoint overriding, first matching should be used
    });

    server.addEndpoint(Endpoint {
        service => void (Request request, Response response) {
                        response.addHeader(contentType("text/html", ascii));
                        response.writeString(request.header("Content-Type") else "");
                    };
        path = startsWith("/headerTest");
    });

    //add fileEndpoint
    creteTestFile();
    server.addEndpoint(AsynchronousEndpoint {
        service => serveStaticFile(".");
        path = (startsWith("/lazy") or startsWith("/blob")) 
                or endsWith(".txt");
    });
    
    object serverListerner satisfies StatusListener {
        shared actual void onStatusChange(Status status) {
            if (status.equals(started)) {
                try {
                    headerTest();
                    
                    executeEchoTest();
                    
                    concurentFileRequests(numberOfUsers);
                    
                    
                    
                } finally {
                    cleanUpFile();
                    server.stop();
                }
            }
        }
    }
    
    server.addListener(serverListerner);

    server.startInBackground {
        serverOptions = Options {defaultCharset = ascii;}; //TODO use utf8 instead of ascii once encoder/decoder issue fixed
    };
}

void executeEchoTest() {
    //TODO log debug
    print("Making request to Ceylon server...");
    
    String name = "Ceylon";
    
    value request = ClientRequest(parse("http://localhost:8080/echo?name=" + name));
    value response = request.execute();

    value echoMsg = response.contents;
    response.close();
    //TODO log
    print("Received message: ``echoMsg``");
    value expecting = "Hello ``name``!";
    assertEquals(expecting, echoMsg);
}

void headerTest() {
    String header = "multipart/form-data";
    
    value request = ClientRequest(parse("http://localhost:8080/headerTest"));
    request.setHeader("Content-Type", header);
    
    value response = request.execute();
    
    value contentTypeHeader = response.getSingleHeader("content-type");
    //assertEquals("text/html; charset=UTF-8", contentTypeHeader);
    assertEquals("text/html; charset=``ascii.name``", contentTypeHeader);
    
    value echoMsg = response.contents;
    response.close();
    //TODO log debug
    print("Received contents: ``echoMsg``");
    assertEquals(header, echoMsg);
}

void executeTestStaticFile(Integer executeRequests) {
    variable Integer request = 0;
    while(request < executeRequests) {
        value fileRequest = ClientRequest(parse("http://localhost:8080/``fileName``"));
        value fileResponse = fileRequest.execute();
        value fileCnt = fileResponse.contents;
        fileResponse.close();
        //TODO log trace
        print("Request N°``request``");
        //print("File content:``fileCnt``");
        assertEquals(produceFileContent(), fileCnt);
        request++;
    }
}

void concurentFileRequests(Integer concurentRequests) {
    variable Integer requestNumber = 0;
    
    object user satisfies Runnable {
        shared actual void run() {
            executeTestStaticFile(requestsPerUser);
        }
    }
    
    value users = LinkedList<Thread>();

    print ("Running ``concurentRequests `` concurent requests.");    
    while(requestNumber < concurentRequests) {
        value userThread = Thread(user);
        users.add(userThread);
        userThread.start();
        requestNumber++;
    }
    
    //wait for users to complete requests
    for (userThread in users) {
        userThread.join();
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

void testPathMatcher() {
    String requestPath = "/file/myfile.txt";
    
    value matcherStarts = startsWith("/file");
    assertTrue(matcherStarts.matches(requestPath));

    value matcherEnds = endsWith(".txt");
    assertTrue(matcherEnds.matches(requestPath));

    value matcher = startsWith("/file");
    assertEquals("/myfile.txt", matcher.relativePath(requestPath));
    
    value matcher2 = endsWith(".txt");
    assertEquals("/file/myfile.txt", matcher2.relativePath(requestPath));
    
    value matcher3 = startsWith("/file") and endsWith(".txt");
    assertEquals("/file/myfile.txt", matcher3.relativePath(requestPath));

    value matcher4 = endsWith(".txt") and startsWith("/file");
    assertEquals("/file/myfile.txt", matcher4.relativePath(requestPath));

    value matcher5 = (startsWith("/file") or startsWith("/blob")) 
                or endsWith(".txt");
    assertEquals("/myfile.txt", matcher5.relativePath(requestPath));

    value matcher6 = (startsWith("/blob") or startsWith("/file")) 
                and endsWith(".txt");
    assertEquals("/file/myfile.txt", matcher6.relativePath(requestPath));
    
    
}
