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
module ceylon.http.client maven:"org.ceylon-lang" "**NEW_VERSION**-SNAPSHOT" {
    shared import ceylon.http.common "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.collection "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.io "**NEW_VERSION**-SNAPSHOT";
    shared import ceylon.uri "**NEW_VERSION**-SNAPSHOT";
}
