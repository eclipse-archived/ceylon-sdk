import ceylon.file { Path, File, parsePath }
import ceylon.io { OpenFile, newOpenFile,
    stringToByteProducer }
import ceylon.buffer.charset {
    utf8
}
import ceylon.uri { parse, Parameter }
import ceylon.http.client { ClientRequest=Request }
import ceylon.http.server { Status  { ... }, 
                                  AsynchronousEndpoint, 
                                  Endpoint, Response, Request, 
                                  startsWith, endsWith, Options, newServer,
                                  template,
    Server }
import ceylon.http.server.endpoints { serveStaticFile,
    RepositoryEndpoint }
import ceylon.test { assertEquals, assertTrue, test,
    beforeTest,
    afterTest }
import ceylon.collection { LinkedList, MutableList }
import ceylon.http.common { contentType, trace, connect, Method, parseMethod, post, get, put, delete, Header, contentLength}
import java.util.concurrent { Semaphore }
import java.lang { Runnable, Thread {threadSleep = sleep}, JString = String }
import ceylon.html {
    Html,
    Head,
    Body,
    Title,
    P,
    renderTemplate
}
import ceylon.buffer { ByteBuffer }
import test.ceylon.http.server.multipartclient {
    MultipartRequest,
    FilePart
}
import ceylon.http.server.websocket {
    WebSocketEndpoint
}
import ceylon.locale {
    Locale,
    systemLocale
}
import ceylon.buffer.base {
    base64StringStandard
}

shared abstract class ServerTest() {

    variable Status? lastStatus = null;
    variable Boolean successfullyStarted = false;

    value startingLock = Semaphore(0);

    Boolean waitServerStarted() {
        startingLock.acquire();
        return successfullyStarted;
    }

    void notifyStatusUpdate(Status status) {
        if (status == started) {
            successfullyStarted = true;
            startingLock.release();
        } else if (status == stopped) {
            startingLock.release();
            if (exists last = lastStatus) {
                if (last == starting) {
                    throw AssertionError("Server failed to start.");
                } else if (last != stopping) {
                    throw AssertionError("Unexpected server stop.");
                }
            }
        }
    }
    
    variable Server? server = null;
    
    shared formal {<Endpoint|AsynchronousEndpoint|WebSocketEndpoint>+} endpoints;
    
    beforeTest
    shared void startServerBeforeTest() {
        
        value server = newServer(endpoints);
        server.addListener(notifyStatusUpdate);
        
        server.startInBackground {
            serverOptions = Options {
                defaultCharset = utf8;
                workerTaskMaxThreads=2;
            };
        };
        value successfullyStarted = waitServerStarted();
        if (!successfullyStarted) {
            throw AssertionError("Server failed to start.");
        }
        this.server = server;
    }
    
    afterTest
    shared void stopServerAfterTest() {
        if (exists s=server) {
            s.stop();
        }
    }
}

by("Matej Lazar")
shared class TestServer() extends ServerTest() {
    String fileContent = "The quick brown fox jumps over the lazy dog.\n";
    
    "How many lines of default text to write to file."
    Integer fileLines = 200;
    
    String fileName = "lazydog.txt";
    
    Parameter param1 = Parameter("foo", "valueFoo");
    Parameter param2 = Parameter("latin", "Abc-ČŠŽĆĐ_čšžćđ.");
    FilePart filePart1 = FilePart("file1", "file1.txt", fileContent);
    String produceFileContent() {
        variable String content = "";
        variable value line = 0;
        while(line < fileLines) {
            content += "``line``. ``fileContent``";
            line++;
        }
        return content;
    }
    FilePart filePart2 = FilePart("file2", "file2.txt", produceFileContent());
    
    "Number of concurent requests"
    Integer numberOfUsers = 10;
    Integer requestsPerUser = 10;
    
    variable String asyncServiceStatus = "";

    suppressWarnings("deprecation")
    function name(Request request) => request.parameter("name") else "world";
    
    void serviceImpl(Request request, Response response) {
        response.addHeader(contentType { contentType = "text/html"; charset = utf8; });
        response.writeString("Hello ``name(request)``!");
    }

    variable Path testFile = parsePath(fileName);
    beforeTest
    shared void createTestFile() {
        OpenFile file = newOpenFile(testFile.resource);
        file.writeFrom(stringToByteProducer(utf8, produceFileContent()));
        file.close();
    }
    
    String fileMapper(Request request) {
        return testFile.absolutePath.string;
    }
    
    afterTest
    shared void cleanUpFile() {
        if(is File f = testFile.resource){
            f.delete();
        }
    }

    suppressWarnings("deprecation")
    shared actual {<Endpoint|AsynchronousEndpoint>+} endpoints => {
        Endpoint {
            service => serviceImpl;
            path = startsWith("/echo"); //TODO endpoint overriding, first matching should be used
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.header("Content-Type") else "");
            }
            path = startsWith("/headerTest");
        },
        //Pure i18n test. Prints message to response in first accepted language or in default if first is not supported.
        Endpoint {
            void service(Request request, Response response) {
                value messages = request.locale.messages(`module`, "LocaleTestMessages");
                assert (is String message = messages.get("message"));
                response.addHeader(contentType("text/plain", utf8));
                response.writeString(message);
            }
            path = startsWith("/localeTest");
        },
        //Rich i18n test. Prints message to response in first supported language from accepted list or default if no is supported.
        Endpoint {
            void service(Request request, Response response) {
                variable Map<String,String> messages;
                for (Locale locale in request.locales) {
                    messages = locale.messages(`module`, "LocaleTestMessages");
                    assert (is String languagetag = messages.get("languagetag"));
                    if (languagetag != "default") {
                        break;
                    }
                }
                response.addHeader(contentType("text/plain", utf8));
                assert (is String message = messages.get("message"));
                response.writeString(message);
            }
            path = startsWith("/localesTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.method.string);
            }
            path = startsWith("/methodTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                print("``request.method`` ``request.uri``");
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.method.string);
            }
            path = startsWith("/acceptMethodTest");
            acceptMethod = {post, get};
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString("post");
            }
            path = startsWith("/acceptMethodTestSameUrl");
            acceptMethod = {post};
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString("get");
            }
            path = startsWith("/acceptMethodTestSameUrl");
            acceptMethod = {get};
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.parameter("čšž") else "");
            }
            path = startsWith("/paramTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.formParameters("aKey").string);
            }
            path = startsWith("/formParamsTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.queryParameter("aKey")?.string else "");
            }
            path = startsWith("/queryParamTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.queryParameters("aKey").string);
            }
            path = startsWith("/queryParamsTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                response.writeString(request.formParameter("aKey")?.string else "");
            }
            path = startsWith("/formParamTest");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.writeString(request.requestCharset);
            }
            path = startsWith("/printCharset");
        },
        Endpoint {
            void service(Request request, Response response) {
                ByteBuffer dataRaw = ByteBuffer(request.readBinary());
                String data = JString(dataRaw.array, request.requestCharset).string;
                response.addHeader(contentType("text/html", utf8));
                response.writeString(data);
            }
            path = startsWith("/printBody");
        },
        Endpoint {
            void service(Request request, Response response) {
                String data = request.read();
                response.addHeader(contentType("text/html", utf8));
                response.writeString(data);
            }
            path = startsWith("/readString");
        },
        Endpoint {
            void service(Request request, Response response) {
                value data = request.readBinary();
                value converted = data.map((element) => element.unsigned);
                response.writeString(converted.string);
            }
            path = startsWith("/readBinary");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                for (i in 0..10) {
                    response.writeString("foo ``i``\n");
                }
            }
            path = startsWith("/writeStrings");
        },
        Endpoint {
            void service(Request request, Response response) {
                response.addHeader(contentType("text/html", utf8));
                variable Object? count = request.session.get("count");
                if (exists Object c = count) {
                    if (is Integer ci = c) {
                        value ci2 = ci.plus(1);
                        request.session.put("count", ci2);
                        response.writeString(ci2.string);
                    } else {
                        throw AssertionError("Invalid object type retreived from session");
                    }
                } else {
                    request.session.put("count", Integer(1));
                    response.writeString(1.string);
                }
            }
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
                renderTemplate(
                    Html {
                        Head { 
                            Title { "Hello" } 
                        }, 
                        Body {
                            P { "Hello!" }
                        }
                    }, response.writeString);
                }
            },
            AsynchronousEndpoint { 
                
                path = startsWith("/async"); 
                
                void service (Request request, Response response, void complete()) {
                    value startTime = system.milliseconds;
                    String source = request.sourceAddress.address;
                    String responseHello = "Hello ``source`` ";
                    StringBuilder sb = StringBuilder();
                    sb.append(responseHello);
                    // On Linux the max write buffer size for sockets is 4M so let's take 8M
                    value arr = Array<Character>.ofSize(8M, 'x');
                    sb.append(String(arr));
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
                    if (exists uploadedFile = request.file("file1")) {
                        print("Server got file: ``uploadedFile.file``");
                        value openfile = newOpenFile(uploadedFile.file.resource);
                        openfile.readFully((buffer) {
                            responseString += utf8.decode(buffer);
                        });
                    }
                    
                    if (exists uploadedFile = request.file("file2")) {
                        print("Server got file: ``uploadedFile.file``");
                        value openfile = newOpenFile(uploadedFile.file.resource);
                        openfile.readFully((buffer) {
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
            AsynchronousEndpoint {
                path = template("/asynctemplate/{val}/x/{other}");
                service = (Request request, Response response, void complete()) {
                    String? val = request.pathParameter("val");
                    String? other = request.pathParameter("other");
                    String? template = request.matchedTemplate;
                    assert (exists val);
                    assert (exists other);
                    assert (exists template);
                    response.addHeader(contentType("text/plain", utf8));
                    response.writeString("val=``val``, other=``other``, matched=``template``");
                    complete();
                };
                acceptMethod = {get};
            },
            RepositoryEndpoint {
                root = "/modules";
            }
        };
    
    shared test void executeEchoTest() {
        String name = "Ceylon";
        //TODO log debug
        print("Making request to Ceylon server...");
        
        value expecting = "Hello ``name``!";
    
        value request = ClientRequest(parse("http://localhost:8080/echo?name=" + name));
        value response = request.execute();
    
        value echoMsg = response.contents;
        response.close();
        //TODO log
        print("Received message: ``echoMsg``");
        assertEquals { 
            expected = expecting; 
            actual = echoMsg; 
        };
    }
    
    shared test void bodyEncodingTest() {
        Map<String,String> messages = systemLocale.messages(`module`, "CharsetTestMessages");

        void runBodyEncodingTest(String charsetName) {
            assert (is String base64 = messages.get(charsetName + "base64"));

            value printCharsetRequest = ClientRequest(parse("http://localhost:8080/printCharset"), post);
            printCharsetRequest.setHeader("Content-Type", "text/plain; charset=" + charsetName);
            printCharsetRequest.data = ByteBuffer(base64StringStandard.decode(base64));
            value printCharsetResponse = printCharsetRequest.execute();
            assertEquals(printCharsetResponse.contents, charsetName);


            //test binary reading
            value printBodyRequest = ClientRequest(parse("http://localhost:8080/printBody"), post);
            printBodyRequest.setHeader("Content-Type", "text/plain; charset=" + charsetName);
            printBodyRequest.data = ByteBuffer(base64StringStandard.decode(base64));
            value printBodyResponse = printBodyRequest.execute();
            assertEquals(printBodyResponse.contents, messages.get("stringoriginal"));

            //test text reading
            value readRequest = ClientRequest(parse("http://localhost:8080/readString"), post);
            readRequest.setHeader("Content-Type", "text/plain; charset=" + charsetName);
            readRequest.data = ByteBuffer(base64StringStandard.decode(base64));
            value readResponse = readRequest.execute();
            assertEquals(readResponse.contents, messages.get("stringoriginal"));
        }

        runBodyEncodingTest("utf8");
        runBodyEncodingTest("cp1251");
        runBodyEncodingTest("cp866");
    }

    shared test void headerTest() {
        String contentType = "application/x-www-form-urlencoded";
        
        value request = ClientRequest(parse("http://localhost:8080/headerTest"));
        request.setHeader("Content-Type", contentType);
        
        value response = request.execute();
    
        value echoMsg = response.contents;
        //TODO log debug
        print("Received contents: ``echoMsg``");
        
        value contentTypeHeader = response.getSingleHeader("Content-Type");
        response.close();
    
        assertEquals { 
            expected = "text/html; charset=``utf8.name``"; 
            actual = contentTypeHeader; 
        };
        assertEquals { 
            expected = contentType; 
            actual = echoMsg; 
        };
    }
    
    void executeTestStaticFile_(Integer executeRequests) {
        variable Integer request = 0;
        while(request < executeRequests) {
            value fileRequest = ClientRequest(parse("http://localhost:8080/``fileName``"));
            value fileResponse = fileRequest.execute();
            value fileCnt = fileResponse.contents;
            fileResponse.close();
            //TODO log trace
            print("Request N°``request``");
            //print("File content:``fileCnt``");
            assertEquals { 
                expected = produceFileContent(); 
                actual = fileCnt; 
            };
            request++;
        }
    }
    
    shared test void executeTestStaticFile() {
        executeTestStaticFile_(requestsPerUser);
    }
    
    shared test void fileMapperTest() {
        value fileRequest = ClientRequest(parse("http://localhost:8080/filemapper"));
        value fileResponse = fileRequest.execute();
        value fileCnt = fileResponse.contents;
        fileResponse.close();
        //TODO log trace
        print("Filemapper: ``fileCnt.initial(100)``" + (fileCnt.size > 100 then " ..." else ""));
        assertEquals { 
            expected = produceFileContent(); 
            actual = fileCnt; 
        };
    }
    
    void assertResponseForAcceptLanguage(String url, String languageTagsChain, String expectedResponse) {
        value request = ClientRequest(parse(url));
        request.setHeader("Accept-Language", languageTagsChain);

        value response = request.execute();

        value msg = response.contents;
        //TODO log debug
        print("Received contents: ``msg``");

        response.close();

        assertEquals {
            expected = expectedResponse;
            actual = msg;
        };
    }
    //Pure i18n test. Server prints message to response in first accepted language or in default if first is not supported.
    shared test void localeTest() {
        String url = "http://localhost:8080/localeTest";
        //Case 1: one language that is supported
        assertResponseForAcceptLanguage(url, "de-DE", "Nachricht");
        //Case 2: two languages, first is supported
        assertResponseForAcceptLanguage(url, "ru-RU,en;q=0.5", "Сообщение");
        //Case 3: unsupported language
        assertResponseForAcceptLanguage(url, "fr-FR", "Message");
        //Case 4: first language is unsupported, second is supported, but default is returned
        assertResponseForAcceptLanguage(url, "fr-FR,ru-RU;q=0.5", "Message");
    }
    //Rich i18n test. Server prints message to response in first supported language from accepted list or in default no is supported.
    shared test void localesTest() {
        String url = "http://localhost:8080/localesTest";
        //Case 1: one language that is supported
        assertResponseForAcceptLanguage(url, "de-DE", "Nachricht");
        //Case 2: two languages, first is supported
        assertResponseForAcceptLanguage(url, "ru-RU,en;q=0.5", "Сообщение");
        //Case 3: unsupported language
        assertResponseForAcceptLanguage(url, "fr-FR", "Message");
        //Case 4: two unsupported languages
        assertResponseForAcceptLanguage(url, "fr-FR,es-ES;q=0.5", "Message");
        //Case 5: first language is unsupported, second is supported and returned
        assertResponseForAcceptLanguage(url, "fr-FR,ru-RU;q=0.5", "Сообщение");
        //Case 6: second and third languages are supported, second is returned
        assertResponseForAcceptLanguage(url, "fr-FR,en-US;q=0.7,ru-RU;q=0.3", "Message");
    }
    
    shared test void moduleTest() {
        value v = language.version;
        _moduleTest("ceylon/language/" + v + "/ceylon.language-" + v + ".js");
        _moduleTest("ceylon.language-" + v + ".js");
    }
    
    void _moduleTest(String modurl) {
        value url = "http://localhost:8080/modules/" + modurl;
        value fileRequest = ClientRequest(parse(url));
        value fileResponse = fileRequest.execute();
        
        try {
            assertEquals{
                expected = 200;
                actual = fileResponse.status;
            };
            
            value fileCnt = fileResponse.contents;
            //TODO log trace
            print("RepositoryEndpoint: read module " + modurl);
            print(fileCnt);
            assertTrue(fileCnt.size > 100000); // It's big so it's probably/hopefully the correct file
        } finally {
            fileResponse.close();
        }  
        
    }
    
    shared test void concurentFileRequests() {
        Integer concurentRequests = numberOfUsers;
        variable Integer requestNumber = 0;
        
        object user satisfies Runnable {
            shared actual void run() {
                executeTestStaticFile_(requestsPerUser);
            }
        }
        
        value users = LinkedList<Thread>();
    
        print ("Running ``concurentRequests `` concurrent requests.");    
        while (requestNumber < concurentRequests) {
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
        assertEquals { 
            expected = method.string; 
            actual = responseContent; 
        };
    }
    
    shared test void methodTest() {
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
    
    shared test void acceptMethodTest() {
        //accept POST
        value request = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
        request.method = post;
        request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        request.setParameter(Parameter("foo", "valueFoo"));
        value response = request.execute();
        try {
            //TODO log
            assertEquals { 
                actual = response.status; 
                expected = 200; 
            };
            
            assertEquals { 
                actual = response.contents; 
                expected = "POST"; 
            };
        } finally {
            response.close();
        }
    
        //accept GET
        value request1 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
        request1.method = get;
        request1.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        request1.setParameter(Parameter("foo", "valueFoo"));
        value response1 = request1.execute();
        try {
            //TODO log
            assertEquals { 
                actual = response1.status; 
                expected = 200; 
            };
            assertEquals { 
                actual = response1.contents; 
                expected = "GET"; 
            };
        } finally {
            response1.close();
        }
    
        //do NOT accept PUT 
        value request2 = ClientRequest(parse("http://localhost:8080/acceptMethodTest"));
        request2.method = put;
        request2.setParameter(Parameter("foo", "valueFoo"));
        value response2 = request2.execute();
        try {
            //TODO log
            assertEquals { 
                actual = response2.status; 
                expected = 405; 
            };
            if (exists Header allow = response2.headersByName["allow"]) {
                assertEquals { 
                    actual = allow.values.get(0); 
                    expected = "POST, GET"; 
                };
            } else {
                throw AssertionError("Missing allow header.");
            }
        } finally {
            response2.close();
        }
    
        //accept all methods
        value request3 = ClientRequest(parse("http://localhost:8080/methodTest"));
        request3.method = post;
        request3.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        request3.setParameter(Parameter("foo", "valueFoo"));
        value response3 = request3.execute();
        try {
            //TODO log
            assertEquals { 
                actual = response3.status; 
                expected = 200; 
            };
        } finally {
            response3.close();
        }
    }
    
    shared test void acceptMethodTestSameUrl() {
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
        assertEquals { 
            actual = responseStatus; 
            expected = 200; 
        };
        assertEquals {
            // WTF? 
            actual = responseContent; 
            expected = post.string; 
        };
    
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
        assertEquals { 
            actual = response1Status; 
            expected = 200; 
        };
        assertEquals { 
            actual = response1Content; 
            expected = get.string; 
        };
    }
    
    void _parametersTest(String paramKey, String paramValue) {
        value request = ClientRequest(parse("http://localhost:8080/paramTest"), post);
    
        request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        request.setParameter(Parameter("foo", "valueFoo"));
        request.setParameter(Parameter(paramKey, paramValue));
    
        value response = request.execute();
        value responseContent = response.contents;
        response.close();
        //TODO log
        print("Response content: " + responseContent);
        assertEquals { 
            expected = paramValue; 
            actual = responseContent; 
        };
    }
    
    shared test void parameterTest() {
        _parametersTest("čšž", "ČŠŽ ĐŽ");
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
        assertEquals { 
            actual = responseContent; 
            expected = paramValues.string; 
        };
    }
    test shared void formParametersTest1() {
        formParametersTest("aKey", "aValue", "val2");
        
        formParameterTest("aKey", "aValue", "val2");
    }
    
    void formParameterTest(String paramKey, String+ paramValues) {
        value request = ClientRequest(parse("http://localhost:8080/formParamTest?``paramKey``=notThis"), post);
    
        request.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        request.setParameter(Parameter("foo", "valueFoo"));
        for (val in paramValues) {
            request.setParameter(Parameter(paramKey, val));
        }
    
        value response = request.execute();
        value responseContent = response.contents;
        response.close();
        //TODO log
        print("Response content: " + responseContent);
        assertEquals { 
            actual = responseContent; 
            expected = paramValues.first; 
        };
    }
    
    void queryParametersTest(String paramKey, String+ paramValues) {
        variable String query = "``paramKey``=``paramValues.first``";
        for (val in paramValues.rest) {
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
        assertEquals { 
            actual = responseContent; 
            expected = paramValues.string; 
        };
    }
    
    test shared void queryParametersTest1() {
        queryParametersTest("aKey", "aValue");
        queryParameterTest("aKey", "aValue");
    }
    
    void queryParameterTest(String paramKey, String+ paramValues) {
        variable String query = "``paramKey``=``paramValues.first``";
        for (val in paramValues.rest) {
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
        assertEquals { 
            actual = responseContent; 
            expected = paramValues.first; 
        };
    }
    
    void readBinaryTest(Byte* bytes) {
        value request = ClientRequest(parse("http://localhost:8080/readBinary"), post);
    
        request.data = ByteBuffer(bytes);
    
        value response = request.execute();
        value body = response.contents;
    
        value expected = bytes.map((b) => b.unsigned);
        assertEquals { 
            actual = body; 
            expected = expected.string; 
        };
    }
    test shared void readBinaryTest1() {
        readBinaryTest(Byte(1), Byte(252), Byte(3), Byte(0), Byte(2));
    }
    
    shared test void writeStringsTest() {
        value request = ClientRequest(parse("http://localhost:8080/writeStrings"), get);
    
        value response = request.execute();
        value responseContent = response.contents;
        response.close();
        //TODO log
        print("Response content: " + responseContent);
        assertTrue(responseContent.contains("foo 10"), "Response does not containg 'foo 10'.");
    }
    
    shared test void templateTest() {
        value request = ClientRequest(parse("http://localhost:8080/template/xyzzy/x/veramocor"), get);
    
        value response = request.execute();
        value responseContent = response.contents;
        response.close();
        //TODO log
        print("Response content: " + responseContent);
        assertTrue(responseContent.equals("val=xyzzy, other=veramocor, matched=/template/{val}/x/{other}"), "Response does not equals 'val=xyzzy, other=veramocor, matched=/template/{val}/x/{other}'.");
    }
    
    shared test void asyncTemplateTest() {
        value request = ClientRequest(parse("http://localhost:8080/asynctemplate/ceylon/x/java"), get);
        
        value response = request.execute();
        value responseContent = response.contents;
        response.close();
        //TODO log
        print("Response content: " + responseContent);
        assertTrue(responseContent.equals("val=ceylon, other=java, matched=/asynctemplate/{val}/x/{other}"), "Response does not equals 'val=xyzzy, other=veramocor, matched=/template/{val}/x/{other}'.");
    }
    
    shared test void sessionTest() {
        value request = ClientRequest(parse("http://localhost:8080/session"), get);
    
        value response = request.execute();
        value responseContent = response.contents;
        //TODO log
        
        value setCookie = response.headersByName["set-cookie"]?.values?.first else "";
        
        assertEquals { 
            expected = "1"; 
            actual = responseContent; 
        };
        response.close();
    
        value cookieName = setCookie[0..(setCookie.firstIndexWhere((ch) => ch == ';') else 0)-1 ];
        request.setHeader("Cookie", cookieName);
        value response2 = request.execute();
        value responseContent2 = response2.contents;
        //TODO log
        print("Response content: " + responseContent2);
        assertEquals { 
            expected = "2"; 
            actual = responseContent2; 
        };
        response2.close();
    }
    
    shared test void testSerializer() {
        value request = ClientRequest(parse("http://localhost:8080/serializer"), get);
        
        value response = request.execute();
        value responseContent = response.contents;
        //TODO log
        print("Response content: " + responseContent);
        assertTrue(responseContent.contains("Hello"), "Response does not contain Hello.");
        response.close();
    }
    
    shared test void testAsyncStream() {
        value request = ClientRequest(parse("http://localhost:8080/async"), get);
    
        assertEquals { 
            actual = asyncServiceStatus; 
            expected = ""; 
        };
    
        value startTime = system.milliseconds;
        value response = request.execute();
    
        threadSleep(50);
        assertEquals { 
            actual = asyncServiceStatus; 
            expected = "returning"; 
        };
    
        value responseReader = response.getReader();
        value buffSize = 4k;
        value buffer = ByteBuffer.ofSize(buffSize);
        MutableList<Byte> content = LinkedList<Byte>();
        value header
                = response.getSingleHeader("content-length")
                else "0";
        variable Integer remaining
                = if (is Integer len = Integer.parse(header))
                then len
                else 0;
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
                assertEquals { 
                    actual = asyncServiceStatus; 
                    expected = "returning"; 
                };
            }
            //TODO log
            process.write("``read``.");
        }
        print("Read in ``system.milliseconds - startTime``ms.");
        
        // we only test the start and 4M makes a large buffer so let's only take the first 100
        ByteBuffer contentBuff = ByteBuffer.ofSize(100);
        for (b in content.initial(100)) {
            contentBuff.put(b);
        }
        contentBuff.flip();
        value responseContent = utf8.decode(contentBuff);
        //TODO log
        print("Response content: " + responseContent.initial(100));
        assertTrue(responseContent.contains("Hello"), "Response does not contain Hello.");
        response.close();
        assertEquals { 
            actual = asyncServiceStatus; 
            expected = "completing"; 
        };
    }
    
    shared test void testMultipartPost() {
    
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

}

suppressWarnings("deprecation")
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