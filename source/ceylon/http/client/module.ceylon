"""This module defines APIs for connecting to HTTP servers.
   
   Given a [[ceylon.uri::Uri]] to an HTTP service, you can
   get its text representation with:
   
       void getit(Uri uri) {
           Request request = get(uri);
           Response response = request.execute();
           print(response.contents);
       }
"""

by("Stéphane Épardaud", "Matej Lazar")
license("Apache Software License")
native("jvm")
module ceylon.http.client maven:"org.ceylon-lang" "1.3.3-SNAPSHOT" {
    shared import ceylon.http.common "1.3.3-SNAPSHOT";
    shared import ceylon.collection "1.3.3-SNAPSHOT";
    shared import ceylon.io "1.3.3-SNAPSHOT";
    shared import ceylon.uri "1.3.3-SNAPSHOT";
}
