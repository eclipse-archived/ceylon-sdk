import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8 }
import ceylon.net.uri { parse, Parameter }
import ceylon.net.http.client { ClientRequest=Request }
import ceylon.net.http.server { createServer, StatusListener, Status, 
                                  started, AsynchronousEndpoint, 
                                  Endpoint, Response, Request, 
                                  startsWith, endsWith, Options }
import ceylon.net.http.server.endpoints { serveStaticFile }
import ceylon.test { assertEquals, assertTrue }
import java.lang { Runnable, Thread }
import ceylon.collection { LinkedList }
import ceylon.net.http { contentType, trace, connect, Method, parseMethod, post, get, put, delete, Header}


by("Matej Lazar")
String fileContent = "The quick brown fox jumps over the lazy dog.\n";

"How many lines of default text to write to file."
Integer fileLines = 10;

String fileName = "lazydog.txt";

"Number of concurent requests"
Integer numberOfUsers=10;
Integer requestsPerUser = 10;

void testServer() {
    
    function name(Request request) => request.parameter("name") else "world";
    void serviceImpl(Request request, Response response) {
        response.addHeader(contentType { contentType = "text/html"; charset = utf8; });
        response.writeString("Hello ``name(request)``!");
    }

    value server = createServer {};

    server.addEndpoint(Endpoint {
        service => serviceImpl;
        path = startsWith("/echo"); //TODO endpoint overriding, first matching should be used
    });

    server.addEndpoint(Endpoint {
        service => void (Request request, Response response) {
                        response.addHeader(contentType("text/html", utf8));
                        response.writeString(request.header("Content-Type") else "");
                    };
        path = startsWith("/headerTest");
    });

    server.addEndpoint(Endpoint {
        service => void (Request request, Response response) {
                        response.addHeader(contentType("text/html", utf8));
                        response.writeString(request.method.string);
                    };
        path = startsWith("/methodTest");
    });

    server.addEndpoint(Endpoint {
        service => void (Request request, Response response) {
                        response.addHeader(contentType("text/html", utf8));
                        response.writeString(request.method.string);
                    };
        path = startsWith("/acceptMethodTest");
        acceptMethod = {post, get};
    });

    server.addEndpoint(Endpoint {
        service => void (Request request, Response response) {
                        response.addHeader(contentType("text/html", utf8));
                        response.writeString(request.parameter("čšž") else "");
                    };
        path = startsWith("/paramTest");
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
                    
                    acceptMethodTest();
                    
                    methodTest();

                    parametersTest("čšž", "ČŠŽ ĐŽ");

                    //TODO multipart post
                    
                } finally {
                    cleanUpFile();
                    server.stop();
                }
            }
        }
    }
    
    server.addListener(serverListerner);

    server.startInBackground {
        serverOptions = Options {defaultCharset = utf8;};
    };
}

void executeEchoTest() {
    //TODO log debug
    print("Making request to Ceylon server...");
    
    String name = "Ceylon";
    value expecting = "Hello ``name``!";

    value request = ClientRequest(parse("http://localhost:8080/echo?name=" + name));
    value response = request.execute();

    value echoMsg = response.contents;
    response.close();
    //TODO log
    print("Received message: ``echoMsg``");
    assertEquals(expecting, echoMsg);
}

void headerTest() {
    String contentType = "application/x-www-form-urlencoded";
    
    value request = ClientRequest(parse("http://localhost:8080/headerTest"));
    request.setHeader("Content-Type", contentType);
    
    value response = request.execute();

    value echoMsg = response.contents;
    //TODO log debug
    print("Received contents: ``echoMsg``");
    
    value contentTypeHeader = response.getSingleHeader("Content-Type");
    response.close();

    assertEquals("text/html; charset=``utf8.name``", contentTypeHeader);
    assertEquals(contentType, echoMsg);
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

void methodTest() {
    methodTestRequest(post);
    methodTestRequest(post);
    methodTestRequest(post);
    methodTestRequest(post);
    methodTestRequest(put);
    methodTestRequest(put);
    methodTestRequest(put);
    methodTestRequest(put);
    methodTestRequest(get);
    methodTestRequest(get);
    methodTestRequest(get);
    methodTestRequest(get);
    methodTestRequest(delete);
    methodTestRequest(delete);
    methodTestRequest(delete);
    methodTestRequest(delete);

    methodTestRequest(trace);
    methodTestRequest(connect);
    methodTestRequest(parseMethod("CUSTOMMETHOD"));
    methodTestRequest(parseMethod("lowercasemethod"));
}

void methodTestRequest(Method method) {
    value request = ClientRequest(parse("http://localhost:8080/methodTest"));

    request.method = method;
    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertEquals(method.string, responseContent);
}

void acceptMethodTest() {
    //accept POST
    value request = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
    request.method = post;
    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));
    value response = request.execute();
    value responseStatus = response.status;
    value responseContent = response.contents;
    response.close();
    //TODO log
    assertEquals(200, responseStatus);
    assertEquals(post.string, responseContent);

    //accept GET
    value request1 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
    request1.method = post;
    request1.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request1.setParameter(Parameter("foo", "valueFoo"));
    value response1 = request1.execute();
    value response1Status = response1.status;
    response.close();
    //TODO log
    assertEquals(200, response1Status);

    //do NOT accept PUT 
    value request2 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
    request2.method = put;
    request2.setParameter(Parameter("foo", "valueFoo"));
    value response2 = request2.execute();
    value response2Status = response2.status;
    response2.close();
    //TODO log
    assertEquals(405, response2Status);
    if (exists Header allow = response2.headersByName["allow"]) {
        assertEquals(allow.values.get(0), "POST, GET");
    } else {
        throw AssertionException("Missing allow header.");
    }

    //accept all methods
    value request3 = ClientRequest(parse("http://localhost:8080/methodTest"));
    request3.method = post;
    request3.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request3.setParameter(Parameter("foo", "valueFoo"));
    value response3 = request3.execute();
    value response3Status = response3.status;
    response3.close();
    //TODO log
    assertEquals(200, response3Status);
}

void parametersTest(String paramKey, String paramValue) {
    value request = ClientRequest(parse("http://localhost:8080/paramTest"), post);

    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));
    request.setParameter(Parameter(paramKey, paramValue));

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertEquals(paramValue, responseContent);
}
