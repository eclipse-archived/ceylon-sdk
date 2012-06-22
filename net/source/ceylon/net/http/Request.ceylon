import ceylon.collection { MutableList, LinkedList, MutableMap, HashMap }
import ceylon.net { URI }
import ceylon.json { JSONObject = Object }

import java.net { URL, HttpURLConnection, URLConnection }

by "Stéphane Épardaud"
doc "Represents an HTTP Request"
shared class Request(uri, method = "GET"){
    doc "This request URI, must be absolute"
    shared URI uri;
    
    doc "The list of request headers"
    shared MutableList<Header> headers = LinkedList<Header>();
    
    doc "The request method, such as `GET`, `POST`…"
    shared variable String method;
    
    if(uri.relative){
        throw Exception("Can't request a relative URI");
    }
    if(exists String scheme = uri.scheme){
        if(scheme != "http"
            && scheme != "https"){
            throw Exception("Only HTTP and HTTPS schemes are supported");
        }
    }else{
        throw Exception("Missing URI scheme");
    }
    
    doc "Executes this request by connecting to the server and returns a Response"
    shared Response execute(){
        URL javaURL = URL(uri.string);
        URLConnection con = javaURL.openConnection();
        if(is HttpURLConnection con){
            con.requestMethod := method;
            for(Header header in headers){
                con.setRequestProperty(header.name, header.contents);
            }
            con.connect();
            return Response(con);
        }else{
            throw;
        }
    }

    doc "Executes this request and returns the response as JSON"    
    throws(Exception, "If the response status is not 200")    
    shared JSONObject getJSON(){
        return execute().getJSON();
    }
}