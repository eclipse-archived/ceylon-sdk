import ceylon.json {
    parseJson=parse,
    ...
}
import ceylon.uri {
    parse,
    Parameter
}
import ceylon.http.client {
    httpGet = get,
    ...
}
import ceylon.test {
    ...
}
import ceylon.http.server {
    newServer,
    Server,
    Endpoint,
    startsWith,
    ServerRequest=Request,
    ServerResponse=Response,
    Status,
    started
}
import java.util.concurrent {
    Semaphore
}
import ceylon.io {
    SocketAddress
}
import ceylon.http.common {
    getMethod=get,
    postMethod=post,
    contentType
}
import ceylon.buffer.charset {
    utf8
}

void testJSON(Object json) {
    assertTrue(json.size > 30, "Object size: "+json.size.string);
    assertEquals("http://ceylon-lang.org", json["homepage"], "Homepage");
    
    if (is Object owner = json["owner"]) {
        assertEquals("eclipse", owner["login"], "Owner name");
    } else {
        fail("owner is not Object");
    }
}

test
void testGETAndParseJSON() {
    value request = httpGet(parse("https://api.github.com/repos/eclipse/ceylon"));
    value response = request.execute();
    print(response);
    assertFalse(response.contents.empty, "Has contents");
    
    assert (is Object json = parseJson(response.contents));
    testJSON(json);
}

String get(String uri) {
    return httpGet(parse(uri)).execute().contents;
}

test
void testGet() {
    value contents = get("https://en.wikipedia.org/wiki/Main_Page");
    assertTrue(contents.contains("<title>Wikipedia, the free encyclopedia</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}

test
void testGetUtf8() {
    value contents = get("https://th.wikipedia.org/wiki/%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B9%80%E0%B8%82%E0%B9%89%E0%B8%B2%E0%B8%A3%E0%B8%AB%E0%B8%B1%E0%B8%AA%E0%B8%82%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%87%E0%B9%80%E0%B8%9B%E0%B9%87%E0%B8%99%E0%B8%8A%E0%B8%B4%E0%B9%89%E0%B8%99%E0%B8%AA%E0%B9%88%E0%B8%A7%E0%B8%99");
    assertTrue(contents.contains("<title>การเข้ารหัสขนส่งเป็นชิ้นส่วน - วิกิพีเดีย</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}

test
void testGetUtf8_2() {
    value contents = get("https://ceylon-lang.org/community/team/");
    assertTrue(contents.contains("Tomáš Hradec"), "Contains Tomáš Hradec");
    assertTrue(contents.contains("Aleš Justin"), "Contains Aleš Justin");
    assertTrue(contents.contains("Stéphane Épardaud"), "Contains Stéphane Épardaud");
}

test
void testGetChunked() {
    value contents = get("http://www.google.fr");
    assertTrue(contents.contains("<title>Google</title>"), "Contains title");
    assertTrue(contents.contains("</html>"), "Contains end </html>");
}

object localServer {
    shared Semaphore runningSync = Semaphore(0);
    shared Semaphore counterMutex = Semaphore(1);
    
    shared Server server = newServer {
        Endpoint {
            path = startsWith("/hello");
            service = void(ServerRequest request, ServerResponse response) {
                response.addHeader(contentType("text/plain", utf8));
                response.writeString("hello world");
            };
        },
        Endpoint {
            path = startsWith("/getparamecho");
            service = void(ServerRequest request, ServerResponse response) {
                // Can't simply get all of the request parameters for whatever reason...
                suppressWarnings("deprecation")
                value p = request.parameter;
                value present = { for (name in { "a", "b", "c" }) if (exists v = p(name)) "``name``=``v``" };
                response.addHeader(contentType("text/plain", utf8));
                response.writeString("\n".join(present));
            };
            getMethod
        },
        Endpoint {
            path = startsWith("/postparamecho");
            service = void(ServerRequest request, ServerResponse response) {
                // Can't simply get all of the request parameters for whatever reason...
                suppressWarnings("deprecation")
                value p = request.parameter;
                value present = { for (name in { "a", "b", "c" }) if (exists v = p(name)) "``name``=``v``" };
                response.addHeader(contentType("text/plain", utf8));
                response.writeString("\n".join(present));
            };
            postMethod
        },
        Endpoint {
            path = startsWith("/postbodyecho");
            service = void(ServerRequest request, ServerResponse response) {
                // Can't seem to access the request body/data ???
                //response.addHeader(contentType("text/plain", utf8));
                //response.writeString(request.data/body?);
            };
            postMethod
        }
    };
    server.addListener(void(Status status) {
            if (status == started) {
                runningSync.release();
            }
        });
    shared Integer serverPort = 59746;
    shared String baseUri = "http://localhost:" + serverPort.string;
    
    shared variable Integer testsRun = 0;
    shared variable Integer testsStarted = 0;
    shared Integer testCount = 6; // TODO determine automatically?
}

class RequestLocalServerTest() {
    beforeTest
    shared void init() {
        localServer.counterMutex.acquire();
        if (localServer.testsStarted == 0) {
            localServer.server.startInBackground(SocketAddress("127.0.0.1", localServer.serverPort));
            localServer.runningSync.acquire();
        }
        localServer.testsStarted++;
        localServer.counterMutex.release();
    }
    
    afterTest
    shared void dispose() {
        localServer.counterMutex.acquire();
        localServer.testsRun++;
        if (localServer.testsRun == localServer.testCount) {
            localServer.server.stop();
        }
        localServer.counterMutex.release();
    }
    
    test
    shared void defaultGet() {
        value req = Request(parse(localServer.baseUri + "/hello"));
        assertEquals(req.execute().contents, "hello world");
    }
    
    test
    shared void simpleGet() {
        value req = Request(parse(localServer.baseUri + "/hello"), getMethod);
        assertEquals(req.execute().contents, "hello world");
    }
    
    test
    shared void postParams() {
        value req = Request {
            parse(localServer.baseUri + "/postparamecho");
            postMethod;
            initialParameters = {
                Parameter("a", "asd"),
                Parameter("b", "ᚷᛖᚻᚹᛦᛚᚳᚢᛗ")
            };
        };
        value returned = req.execute().contents.split((ch) => ch == '\n');
        assertTrue(returned.contains("a=asd"), "Contains a ``returned``");
        assertTrue(returned.contains("b=ᚷᛖᚻᚹᛦᛚᚳᚢᛗ"), "Contains b ``returned``");
    }
    
    test
    shared void getParams() {
        value req = Request {
            parse(localServer.baseUri + "/getparamecho");
            getMethod;
            initialParameters = {
                Parameter("a", "asd"),
                Parameter("b", "ᚷᛖᚻᚹᛦᛚᚳᚢᛗ")
            };
        };
        value returned = req.execute().contents.split((ch) => ch == '\n');
        assertTrue(returned.contains("a=asd"), "Contains a ``returned``");
        assertTrue(returned.contains("b=ᚷᛖᚻᚹᛦᛚᚳᚢᛗ"), "Contains b ``returned``");
    }
    
    test
    shared void getQueryAndParams() {
        value req = Request {
            parse(localServer.baseUri + "/getparamecho?c=hello");
            getMethod;
            initialParameters = {
                Parameter("a", "asd"),
                Parameter("b", "ᚷᛖᚻᚹᛦᛚᚳᚢᛗ")
            };
        };
        value returned = req.execute().contents.split((ch) => ch == '\n');
        assertTrue(returned.contains("a=asd"), "Contains a ``returned``");
        assertTrue(returned.contains("b=ᚷᛖᚻᚹᛦᛚᚳᚢᛗ"), "Contains b ``returned``");
        assertTrue(returned.contains("c=hello"), "Contains c ``returned``");
    }
    
    test
    shared void getQuery() {
        value req = Request {
            parse(localServer.baseUri + "/getparamecho?a=hello");
            getMethod;
        };
        assertEquals(req.execute().contents, "a=hello");
    }
    
    //test
    //shared void getHeaders() {
    //    // TODO header echoer
    //}
    //
    //test
    //shared void postHeaders() {
    //    // TODO header echoer
    //}
}
