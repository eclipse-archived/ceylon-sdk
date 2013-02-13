import ceylon.test { assertEquals }
import ceylon.net.httpd { Httpd, newHttpdInstance = newInstance, newConfig, HttpdStatusListerner, HttpdStatus, httpdStarted }
import ceylon.net.httpd { WebEndpoint, HttpResponse, HttpRequest, WebEndpointConfig}
import ceylon.net.http { Request }
import ceylon.net.uri { parseURI }

by "Matej Lazar"

void testEchoWebEndpoint() {
    Httpd httpd = newHttpdInstance();
    httpd.addWebEndpointConfig(newConfig("/echo", "test.ceylon.net.EchoWebEndpoint", "test.ceylon.net:0.5"));
    
    object httpdListerner satisfies HttpdStatusListerner {
        shared actual void onStatusChange(HttpdStatus status) {
            if (status.equals(httpdStarted)) {
                executeHttpdTestAndStop(httpd);
            }
        }
    }
    
    httpd.addListener(httpdListerner);
    
    httpd.startInBackground();
}

void executeHttpdTestAndStop(Httpd httpd) {
    //TODO log debug
    print("Making request to Ceylon httpd...");
    
    String name = "Ceylon";
    
    value request = Request(parseURI("http://localhost:8080/echo?name=" + name));
    value response = request.execute();
    
    value contentTypeHeader = response.getSingleHeader("content-type");
    assertEquals("text/html", contentTypeHeader);
    
    value echoMsg = response.contents;
    //TODO log
    print("Received message: ``echoMsg``");
    assertEquals(generateMessage(name), echoMsg);
    
    httpd.stop();
}

String generateMessage(String? name) {
    if (exists name) {
        return "Hello " + name + "!";
    } else {
        return "Hello.";
    }
}


shared class EchoWebEndpoint() satisfies WebEndpoint {
    
    shared actual void init(WebEndpointConfig endpointConfig) {}
    
    shared actual void service(HttpRequest request, HttpResponse response) {
        response.addHeader("content-type", "text/html");
        response.writeString(generateMessage(request.parameter("name")));
    }
}