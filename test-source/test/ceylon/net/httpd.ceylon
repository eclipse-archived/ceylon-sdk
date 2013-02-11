import ceylon.test { assertEquals }
import ceylon.net.httpd { Httpd, newHttpdInstance = newInstance, newConfig }
import ceylon.net.httpd { WebEndpoint, HttpResponse, HttpRequest, WebEndpointConfig}
import ceylon.net.http { Request }
import ceylon.net.uri { URI }

by "Matej Lazar"

void testEchoWebEndpoint() {
    startHttpd();
    
    String name = "Ceylon";
    
    value request = Request(URI("http://localhost:8080/echo?name=" + name));
    value response = request.execute();
    
    value contentTypeHeader = response.getSingleHeader("content-type");
    assertEquals("text/html", contentTypeHeader);
    
    value echoMsg = response.contents;
    assertEquals(generateMessage(name), echoMsg);
}

void startHttpd() {
    Httpd httpd = newHttpdInstance();
    httpd.addWebEndpointConfig(newConfig("/echo", "test.ceylon.net.EchoWebEndpoint", "test.ceylon.net:0.5"));
    httpd.start();
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