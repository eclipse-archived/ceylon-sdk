import java.net { HttpURLConnection }
import ceylon.net.iop { readString }
import ceylon.json { JSONObject = Object, parseJSON = parse }

by "Stéphane Épardaud"
doc "Represents an HTTP Response"
shared class Response(HttpURLConnection con){
    
    doc "The HTTP response code"
    shared Integer status = con.responseCode;
    
    doc "The HTTP message line (non-normative)"
    shared String message = con.responseMessage;
    
    doc "The list of response headers"
    shared Map<String,List<String>> headers = toMap(con.headerFields);
    
    variable String? cachedContents := null;
    variable Exception? thrownException := null;
    variable Boolean contentsRead := false;

    doc "The `Content-Length` header value"    
    shared Integer contentLength {
        return con.contentLength;
    }
    
    doc "The response encoding as defined by the `Content-Type` header"
    shared String? encoding {
        return con.contentEncoding;
    }
    
    doc "The response contents, as a String"
    shared String contents {
        // did we already read?
        if(contentsRead){
            // use the cache
            if(exists Exception x = thrownException){
                throw x;
            }
            if(exists String contents = cachedContents){
                return contents;
            }
            // can't happen
            throw;
        }
        // do the real reading
        if(contentLength == 0){
            contentsRead := true;
            cachedContents := "";
            return "";
        }
        
        value istream = con.inputStream;
        try{
            contentsRead := true;
            String c = readString(istream, contentLength, encoding else "UTF-8");
            cachedContents := c;
            return c;
        }catch(Exception x){
            thrownException := x;
            throw x;
        }finally{
            istream.close();
        }
    }

    doc "The response contents, as a JSON Object"
    throws(Exception, "If the response status is not 200")    
    shared JSONObject getJSON() {
        if(status == 200){
            return parseJSON(contents);
        }
        throw Exception("Invalid response from server: " status " (expecting 200)");
    }
}