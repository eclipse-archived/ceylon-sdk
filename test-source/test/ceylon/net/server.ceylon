import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile }
import ceylon.io.charset { stringToByteProducer, utf8 }
import ceylon.net.uri { parse, Parameter }
import ceylon.net.http.client { ClientRequest=Request }
import ceylon.net.http.server { Status, 
                                  started, AsynchronousEndpoint, 
                                  Endpoint, Response, Request, 
                                  startsWith, endsWith, Options, stopped, newServer,
                                  template }
import ceylon.net.http.server.endpoints { serveStaticFile,
    RepositoryEndpoint }
import ceylon.test { assertEquals, assertTrue, test }
import ceylon.collection { LinkedList, MutableList }
import ceylon.net.http { contentType, trace, connect, Method, parseMethod, post, get, put, delete, Header, contentLength}
import java.util.concurrent { Semaphore }
import java.lang { Runnable, Thread {threadSleep = sleep} }
import ceylon.html {
    Html,
    html5,
    Head,
    Body,
    P
}
import ceylon.html.serializer {
    NodeSerializer
}
import ceylon.io.buffer { newByteBuffer, ByteBuffer,
    newByteBufferWithData }
import test.ceylon.net.multipartclient {
    MultipartRequest,
    FilePart
}

by("Matej Lazar")
String fileContent = "The quick brown fox jumps over the lazy dog.\n";

"How many lines of default text to write to file."
Integer fileLines = 200;

String fileName = "lazydog.txt";

Parameter param1 = Parameter("foo", "valueFoo");
Parameter param2 = Parameter("latin", "Abc-ČŠŽĆĐ_čšžćđ.");
FilePart filePart1 = FilePart("file1", "file1.txt", fileContent);
FilePart filePart2 = FilePart("file2", "file2.txt", produceFileContent());


"Number of concurent requests"
Integer numberOfUsers=10;
Integer requestsPerUser = 10;

variable String asyncServiceStatus = "";

test void testServer() {

    function name(Request request) => request.parameter("name") else "world";
    
    void serviceImpl(Request request, Response response) {
        response.addHeader(contentType { contentType = "text/html"; charset = utf8; });
        response.writeString("Hello ``name(request)``!");
    }

    //add fileEndpoint
    value testFile = creteTestFile();
    
    String fileMapper(Request request) {
        return testFile.string;
    }

    {<Endpoint|AsynchronousEndpoint>+} endpoints => {
        Endpoint {
            service => serviceImpl;
            path = startsWith("/echo"); //TODO endpoint overriding, first matching should be used
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.header("Content-Type") else "");
            };
            path = startsWith("/headerTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.method.string);
            };
            path = startsWith("/methodTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.method.string);
            };
            path = startsWith("/acceptMethodTest");
            acceptMethod = {post, get};
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString("post");
            };
            path = startsWith("/acceptMethodTestSameUrl");
            acceptMethod = {post};
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString("get");
            };
            path = startsWith("/acceptMethodTestSameUrl");
            acceptMethod = {get};
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.parameter("čšž") else "");
            };
            path = startsWith("/paramTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.formParameters("aKey").string);
            };
            path = startsWith("/formParamsTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.queryParameter("aKey")?.string else "");
            };
            path = startsWith("/queryParamTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.queryParameters("aKey").string);
            };
            path = startsWith("/queryParamsTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.formParameter("aKey")?.string else "");
            };
            path = startsWith("/formParamTest");
        },
        Endpoint {
            service => void (Request request, Response response) {
                value data = request.readBinary();
                value converted = data.map((Byte element) => element.unsigned);
                response.writeString(converted.string);
            };
            path = startsWith("/readBinary");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                for (i in 0..10) {
                    response.writeString("foo ``i``\n");
                }
            };
            path = startsWith("/writeStrings");
        },
        Endpoint {
            service => void (Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                variable Object? count = request.session.get("count");
                if (exists Object c = count) {
                    if (is Integer ci = c) {
                        value ci2 = ci.plus(1);
                        request.session.put("count", ci2);
                        response.writeString(ci2.string);
                    } else {
                        AssertionError("Invalid object type retreived from session");
                    }
                } else {
                    request.session.put("count", Integer(1));
                    response.writeString(1.string);
                }
            };
            path = startsWith("/session");
        },
        AsynchronousEndpoint {
            service => serveStaticFile(".");
            path = startsWith("/lazy")
                    .or(startsWith("/blob"))
                    .or(endsWith(".txt"));
        },
        AsynchronousEndpoint {
            service => serveStaticFile("", fileMapper);
            path = startsWith("/filemapper");
        },
        Endpoint { 
            path = startsWith("/serializer"); 
            void service(Request request, Response response) {
                NodeSerializer(response.writeString).serialize(
                    Html {
                        doctype = html5; 
                        Head { title = "Hello"; }; 
                        Body {
                            P("Hello!")
                        };
                    }
                );
            }
        },
        AsynchronousEndpoint { 
            
            path = startsWith("/async"); 
            
            void service (Request request, Response response, void complete()) {
                value startTime = system.milliseconds;
                String source = request.sourceAddress.address;
                String responseHello = "Hello ``source`` ";
                String content = "xxxxxxxxxxoooooooooo";
                StringBuilder sb = StringBuilder();
                sb.append(responseHello);
                for (i in 0..1000) { //generate some more content
                    sb.append(content);
                }
                String responseString = sb.string;
                response.addHeader(contentLength(responseString.size.string));
                
                response.writeStringAsynchronous { 
                    string => responseString;
                    void onCompletion () {
                        asyncServiceStatus = "completing";
                        //TODO log
                        print("Completed in ``system.milliseconds - startTime``ms.");
                        complete();
                    } 
                };
                //TODO log
                print("Returned in ``system.milliseconds - startTime``ms.");
                asyncServiceStatus = "returning";
            }
        },
        Endpoint { 
            path = startsWith("/multipartPost"); 
            service = (Request request, Response response) {
                variable String responseString = "";
                if(exists uploadedFile = request.file("file1")) {
                    print("Server got file: ``uploadedFile.file``");
                    value openfile = newOpenFile(uploadedFile.file.resource);
                    openfile.readFully(void (ByteBuffer buffer) {
                        responseString += utf8.decode(buffer);
                    });
                }
                
                if(exists uploadedFile = request.file("file2")) {
                    print("Server got file: ``uploadedFile.file``");
                    value openfile = newOpenFile(uploadedFile.file.resource);
                    openfile.readFully(void (ByteBuffer buffer) {
                        responseString += utf8.decode(buffer);
                    });
                }
                
                responseString += Parameter(param1.name, request.parameter(param1.name)).humanRepresentation;
                responseString += "\n";
                responseString += Parameter(param2.name, request.parameter(param2.name)).humanRepresentation;
                responseString += "\n";
                
                response.addHeader(contentType("text/html", utf8));
                response.writeString(responseString);
                return null;
            }; 
            acceptMethod = {post};
        },
        Endpoint {
            path = template("/template/{val}/x/{other}");
            service = (Request request, Response response) {
                String? val = request.pathParameter("val");
                String? other = request.pathParameter("other");
                String? template = request.matchedTemplate;
                assert (exists val);
                assert (exists other);
                assert (exists template);
                response.addHeader(contentType("text/plain", utf8));
                response.writeString("val=``val``, other=``other``, matched=``template``");
            };
            acceptMethod = {get};
        },
        RepositoryEndpoint {
            root = "/modules";
        }
    };


    value server = newServer(endpoints);

    void onStartedExecuteTest(Status status) {
        if (status.equals(started)) {
            try {
                headerTest();
                
                executeEchoTest("Ceylon");
                
                fileMapperTest();
                
                concurentFileRequests(numberOfUsers);
                
                acceptMethodTest();
                
                acceptMethodTestSameUrl();
                
                methodTest();
                
                parametersTest("čšž", "ČŠŽ ĐŽ");

                formParametersTest("aKey", "aValue", "val2");

                formParameterTest("aKey", "aValue", "val2");
                
                queryParametersTest("aKey", "aValue");
                queryParameterTest("aKey", "aValue");

                writeStringsTest();

                readBinaryTest(Byte(1), Byte(252), Byte(3), Byte(0), Byte(2));

                //TODO enable session test when client suports it
                //sessionTest();
                
                testSerializer();
                
                //TODO enable async "streaming" test
                //testAsyncStream();

                templateTest();

                testMultipartPost();
                
                moduleTest();
                
            } finally {
                cleanUpFile();
                server.stop();
            }
        }
        if (status.equals(stopped)) {
            testCompleted();
        }
    }

    server.addListener(onStartedExecuteTest);

    server.startInBackground {
        serverOptions = Options {
            defaultCharset = utf8;
            workerTaskMaxThreads=2;
        };
    };

    waitTestToComplete();
}

void executeEchoTest(String name) {
    //TODO log debug
    print("Making request to Ceylon server...");
    
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

void fileMapperTest() {
    value fileRequest = ClientRequest(parse("http://localhost:8080/filemapper"));
    value fileResponse = fileRequest.execute();
    value fileCnt = fileResponse.contents;
    fileResponse.close();
    //TODO log trace
    print("Filemapper: ``fileCnt.initial(100)``" + (fileCnt.size > 100 then " ..." else ""));
    assertEquals(produceFileContent(), fileCnt);
}

void moduleTest() {
    value v = language.version;
    _moduleTest("ceylon/language/" + v + "/ceylon.language-" + v + ".js");
    _moduleTest("ceylon.language-" + v + ".js");
}

void _moduleTest(String modurl) {
    value url = "http://localhost:8080/modules/" + modurl;
    value fileRequest = ClientRequest(parse(url));
    value fileResponse = fileRequest.execute();
    value fileCnt = fileResponse.contents;
    fileResponse.close();
    //TODO log trace
    print("RepositoryEndpoint: read module " + modurl);
    assertTrue(fileCnt.size > 100000); // It's big so it's probably/hopefully the correct file
}

void concurentFileRequests(Integer concurentRequests) {
    variable Integer requestNumber = 0;
    
    object user satisfies Runnable {
        shared actual void run() {
            executeTestStaticFile(requestsPerUser);
        }
    }
    
    value users = LinkedList<Thread>();

    print ("Running ``concurentRequests `` concurrent requests.");    
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


Path creteTestFile() {
    Path path = parsePath(fileName);
    OpenFile file = newOpenFile(path.resource);
    file.writeFrom(stringToByteProducer(utf8, produceFileContent()));
    file.close();
    return path.absolutePath;
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

test void testPathMatcher() {
    String requestPath = "/file/myfile.txt";
    
    value matcherStarts = startsWith("/file");
    assertTrue(matcherStarts.matches(requestPath));

    value matcherEnds = endsWith(".txt");
    assertTrue(matcherEnds.matches(requestPath));

    value matcher = startsWith("/file");
    assertEquals("/myfile.txt", matcher.relativePath(requestPath));
    
    value matcher2 = endsWith(".txt");
    assertEquals("/file/myfile.txt", matcher2.relativePath(requestPath));
    
    value matcher3 = startsWith("/file").and(endsWith(".txt"));
    assertEquals("/file/myfile.txt", matcher3.relativePath(requestPath));

    value matcher4 = endsWith(".txt").and(startsWith("/file"));
    assertEquals("/file/myfile.txt", matcher4.relativePath(requestPath));

    value matcher5 = startsWith("/file")
            .or(startsWith("/blob"))
            .or(endsWith(".txt"));
    assertEquals("/myfile.txt", matcher5.relativePath(requestPath));

    value matcher6 = (startsWith("/blob")
            .or(startsWith("/file")) 
            .and(endsWith(".txt")));
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
    assertEquals(responseStatus, 200);
    assertEquals(responseContent, post.string);

    //accept GET
    value request1 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
    request1.method = post;
    request1.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request1.setParameter(Parameter("foo", "valueFoo"));
    value response1 = request1.execute();
    value response1Status = response1.status;
    response1.close();
    //TODO log
    assertEquals(response1Status, 200);

    //do NOT accept PUT 
    value request2 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
    request2.method = put;
    request2.setParameter(Parameter("foo", "valueFoo"));
    value response2 = request2.execute();
    value response2Status = response2.status;
    response2.close();
    //TODO log
    assertEquals(response2Status, 405);
    if (exists Header allow = response2.headersByName["allow"]) {
        assertEquals(allow.values.get(0), "POST, GET");
    } else {
        throw AssertionError("Missing allow header.");
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
    assertEquals(response3Status, 200);
}

void acceptMethodTestSameUrl() {
    //accept POST
    value request = ClientRequest(parse("http://localhost:8080/acceptMethodTestSameUrl"));
    request.method = post;
    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));
    value response = request.execute();
    value responseStatus = response.status;
    value responseContent = response.contents;
    response.close();
    //TODO log
    assertEquals(responseStatus, 200);
    assertEquals(responseContent, post.string);

    //accept GET
    value request1 = ClientRequest(parse("http://localhost:8080/acceptMethodTestSameUrl"));
    request1.method = get;
    request1.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request1.setParameter(Parameter("foo", "valueFoo"));
    value response1 = request1.execute();
    value response1Status = response1.status;
    value response1Content = response1.contents;
    response1.close();
    //TODO log
    assertEquals(response1Status, 200);
    assertEquals(response1Content, get.string);
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

void formParametersTest(String paramKey, String+ paramValues) {
    value request = ClientRequest(parse("http://localhost:8080/formParamsTest?``paramKey``=notThis"), post);

    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));
    for (String val in paramValues) {
        request.setParameter(Parameter(paramKey, val));
    }

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertEquals(responseContent, paramValues.string);
}

void formParameterTest(String paramKey, String+ paramValues) {
    value request = ClientRequest(parse("http://localhost:8080/formParamTest?``paramKey``=notThis"), post);

    request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    request.setParameter(Parameter("foo", "valueFoo"));
    for (String val in paramValues) {
        request.setParameter(Parameter(paramKey, val));
    }

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertEquals(responseContent, paramValues.first);
}

void queryParametersTest(String paramKey, String+ paramValues) {
	variable String query = "``paramKey``=``paramValues.first``";
	for (String val in paramValues.rest) {
		query = query + "&\`\`paramKey\`\`=\`\`paramValues.first\`\`";
	}
	print(query);
	value request = ClientRequest(parse("http://localhost:8080/queryParamsTest?``query``"), post);
	
	request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	request.setParameter(Parameter("foo", "valueFoo"));
	request.setParameter(Parameter(paramKey, "valueBar"));
	
	value response = request.execute();
	value responseContent = response.contents;
	response.close();
	//TODO log
	print("Response content: " + responseContent);
	assertEquals(responseContent, paramValues.string);
}

void queryParameterTest(String paramKey, String+ paramValues) {
	variable String query = "``paramKey``=``paramValues.first``";
	for (String val in paramValues.rest) {
		query = query + "&\`\`paramKey\`\`=\`\`paramValues.first\`\`";
	}
	print(query);
	value request = ClientRequest(parse("http://localhost:8080/queryParamTest?``query``"), post);
	
	request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	request.setParameter(Parameter("foo", "valueFoo"));
	request.setParameter(Parameter(paramKey, "valueBar"));
	
	value response = request.execute();
	value responseContent = response.contents;
	response.close();
	//TODO log
	print("Response content: " + responseContent);
	assertEquals(responseContent, paramValues.first);
}

void readBinaryTest(Byte* bytes) {
    value request = ClientRequest(parse("http://localhost:8080/readBinary"), post);

    request.data = newByteBufferWithData(*bytes);

    value response = request.execute();
    value body = response.contents;

    value expected = bytes.map((Byte b) => b.unsigned);
    assertEquals(body, expected.string);
}

void writeStringsTest() {
    value request = ClientRequest(parse("http://localhost:8080/writeStrings"), get);

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertTrue(responseContent.contains("foo 10"), "Response does not containg 'foo 10'.");
}

void templateTest() {
    value request = ClientRequest(parse("http://localhost:8080/template/xyzzy/x/veramocor"), get);

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent);
    assertTrue(responseContent.equals("val=xyzzy, other=veramocor, matched=/template/{val}/x/{other}"), "Response does not equals 'val=xyzzy, other=veramocor, matched=/template/{val}/x/{other}'.");
}

void sessionTest() {
    value request = ClientRequest(parse("http://localhost:8080/session"), get);

    value response = request.execute();
    value responseContent = response.contents;
    //TODO log
    print("Response content: " + responseContent);
    assertEquals("1", responseContent);
    response.close();

    value response2 = request.execute();
    value responseContent2 = response.contents;
    //TODO log
    print("Response content: " + responseContent2);
    assertEquals("2", responseContent2);
    response2.close();
}

void testSerializer() {
    value request = ClientRequest(parse("http://localhost:8080/serializer"), get);
    
    value response = request.execute();
    value responseContent = response.contents;
    //TODO log
    print("Response content: " + responseContent);
    assertTrue(responseContent.contains("Hello"), "Response does not contain Hello.");
    response.close();
}

void testAsyncStream() {
    value request = ClientRequest(parse("http://localhost:8080/async"), get);

    assertEquals(asyncServiceStatus, "");

    value startTime = system.milliseconds;
    value response = request.execute();

    threadSleep(50);
    assertEquals(asyncServiceStatus, "returning");

    value responseReader = response.getReader();
    value buffSize = 100;
    value buffer = newByteBuffer(buffSize);
    MutableList<Byte> content = LinkedList<Byte>();
    variable Integer remaining = parseInteger(response.getSingleHeader("content-length") else "0") else 0;
    print("cointent-size: ``remaining``");
    variable Integer loops = 0;
    while (true) {
        loops += 1;
        value read = responseReader.read(buffer);
        if (remaining == 0) {
            break;
        }
        remaining -= read;
        buffer.flip();
        for (b in buffer) {
            content.add(b);
        }
        buffer.flip();
        if (loops < 2) {
            assertEquals(asyncServiceStatus, "returning");
        }
        //TODO log
        process.write("``read``.");
    }
    print("Read in ``system.milliseconds - startTime``ms.");
    
    ByteBuffer contentBuff = newByteBuffer(content.size);
    for (b in content) {
        contentBuff.putByte(b);
    }
    contentBuff.flip();
    value responseContent = utf8.decode(contentBuff);
    //TODO log
    print("Response content: " + responseContent.initial(100));
    assertTrue(responseContent.contains("Hello"), "Response does not contain Hello.");
    response.close();
    assertEquals(asyncServiceStatus, "completing");
}

void testMultipartPost() {

    value parameters = {param1,param2};

    value files = {filePart1, filePart2};

    value request = MultipartRequest(parse("http://localhost:8080/multipartPost"), parameters, files);

    value response = request.execute();
    value responseContent = response.contents;
    response.close();
    //TODO log
    print("Response content: " + responseContent.initial(100));

    assertTrue(responseContent.contains(param1.humanRepresentation), "Response does not containg ``param1.humanRepresentation``.");
    assertTrue(responseContent.contains(param2.humanRepresentation), "Response does not containg ``param2.humanRepresentation``.");

    assertTrue(responseContent.contains(filePart1.data), "Response does not containg ``filePart1.data``.");
    assertTrue(responseContent.contains(filePart2.data), "Response does not containg ``filePart2.data``.");
}

Semaphore mutex = Semaphore(0);
void waitTestToComplete() {
    mutex.acquire();
}
void testCompleted() {
    mutex.release();
}
