doc "This module allows you to represent URIs, and to connect to HTTP servers.
     
     Sample usage for getting the contents of an HTTP URI:
     
         void getit(String uriAsString){
             URI uri = parseURI(uriAsString);
             Request request = uri.get();
             Response response = request.execute();
             print(response.contents);
         }
    "
by "Stéphane Épardaud"
license "Apache Software License"
module ceylon.net '0.3.3' {
    import ceylon.collection '0.3.3';
    import ceylon.io '0.3.3';
    import java.base '7';
}
