import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8 }
import ceylon.net.http { ClientRequest=Request }
import ceylon.net.httpd { createServer, StatusListener, Status, 
                          started, AsynchronousEndpoint, 
                          Endpoint, Response, Request, and, startsWith, endsWith, or }
import ceylon.net.httpd.endpoints { serveStaticFile }
import ceylon.net.uri { parseURI }
import ceylon.test { assertEquals }
import java.lang { Runnable, Thread }
import ceylon.collection { LinkedList }


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
        response.addHeader("content-type", "text/html");
        response.writeString("Hello ``name(request)``!");
    }

    value server = createServer {};

    server.addEndpoint(Endpoint {
        service => serviceImpl;
        path = and(startsWith("/echo")); //TODO endpoint overriding, first matching should be used
    });

    //add fileEndpoint
    creteTestFile();
    server.addEndpoint(AsynchronousEndpoint {
        service => serveStaticFile(".");
        path = or(startsWith("/file"), startsWith("/blob"), endsWith(".txt"));
    });
    
    object httpdListerner satisfies StatusListener {
        shared actual void onStatusChange(Status status) {
            if (status.equals(started)) {
                try {
                    execuTestEcho();
                    
                    concurentFileRequests(numberOfUsers);
                    
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
    response.close();
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
        fileResponse.close();
        //TODO log trace
        print("Request N°``request``");
        print("File content:``fileCnt``");
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
    
    while(requestNumber < concurentRequests) {
        print("User: ``requestNumber``");
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
