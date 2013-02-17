doc "This module allows you to represent URIs, and to connect to HTTP servers.
     
     Sample usage for getting the contents of an HTTP URI:
     
         void getit(String uriAsString){
             URI uri = parseURI(uriAsString);
             Request request = uri.get();
             Response response = request.execute();
             print(response.contents);
         }"

by "Stéphane Épardaud, Matej Lazar"
license "Apache Software License"
module ceylon.net '0.5' {
    import ceylon.language '0.5';
    shared import ceylon.collection '0.5';
    shared import ceylon.io '0.5';
    import ceylon.file '0.5';

    import ceylon.util '0.5';

    import java.base '7';
    
    // -- java modules --
    import io.undertow.core '1.0.0.Alpha1-9fdfd5f766';

    import 'org.jboss.xnio.api' '3.1.0.Beta8';
    import 'org.jboss.xnio.nio' '3.1.0.Beta8';
    
    //TODO remove transitive dependency
    import org.jboss.logging '3.1.2.GA';

}
