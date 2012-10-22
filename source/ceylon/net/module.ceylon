doc "This module allows you to represent URIs, and to connect to HTTP servers.
     
     Sample usage for getting the contents of an HTTP URI:
     
         void getit(String uriAsString){
             URI uri = parseURI(uriAsString);
             Request request = uri.get();
             Response response = request.execute();
             print(response.contents);
         }

by "Stéphane Épardaud, Matej Lazar"
license "Apache Software License"
module ceylon.net '0.5' {
    import ceylon.language '0.5';
    shared import ceylon.collection '0.5';
    shared import ceylon.io '0.5';
    import ceylon.file '0.5';

    import java.base '7';
    
    // -- java modules --
    import org.xnio '3.1.0.Beta6';
    import io.undertow '1.0.0.Alpha1-SNAPSHOT';
    import org.jboss.modules 'main';
    import com.redhat.ceylon.javaadapter '1.0';

    // -- dependent java modules --
    import org.jboss.logging '3.1.2.GA';
}
