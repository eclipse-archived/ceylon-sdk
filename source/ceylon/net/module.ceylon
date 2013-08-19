"This module allows you to represent URIs, to connect to HTTP servers and to run a HTTP server.
 
 Sample usage for getting the contents of an HTTP URI:
 
     void getit(String uriAsString){
         URI uri = parseURI(uriAsString);
         Request request = uri.get();
         Response response = request.execute();
         print(response.contents);
     }

 Sample usage for running a HTTP server:
     void runServer() {
         //create a HTTP server
         value server = createServer {
             //an endpoint, on the path /hello
             Endpoint {
                path = startsWith(\"/hello\");
                 //handle requests to this path
                 service(Request request, Response response) =>
                         response.writeString(\"hello world\");
             }
         };
 
         //start the server on port 8080
         server.start(8080);
     }"
by("Stéphane Épardaud, Matej Lazar")
license("Apache Software License")
module ceylon.net '0.6' {
    import ceylon.language '0.6';
    shared import ceylon.collection '0.6';
    shared import ceylon.io '0.6';
    import ceylon.file '0.6';

    import java.base '7';
    
    // -- java modules --
    import io.undertow.core '1.0.0.Beta8';

    import 'org.jboss.xnio.api' '3.1.0.CR6';
    import 'org.jboss.xnio.nio' '3.1.0.CR6';
    
    //TODO remove transitive dependency
    import org.jboss.logging '3.1.2.GA';
}
