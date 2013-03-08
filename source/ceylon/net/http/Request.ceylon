import ceylon.collection { MutableList, LinkedList }
import ceylon.net.uri { Uri }
import ceylon.io.charset { ascii }
import ceylon.io { newSocketConnector, SocketAddress }

doc "Represents an HTTP Request"
by "Stéphane Épardaud"
shared class Request(uri, method = "GET"){
    // constant
    String crLf = "\r\n";

    doc "This request URI, must be absolute."
    shared Uri uri;
    
    doc "The list of request headers."
    shared MutableList<Header> headers = LinkedList<Header>();
    
    doc "The request method, such as `GET`, `POST`…"
    shared variable String method;
    
    doc "The port to connect to. Defaults to 80 for `http` Uris and to 443 for `https` uris, unless
         overridden in the [[uri]]."
    shared variable Integer port = 80;

    if(uri.relative){
        throw Exception("Can't request a relative URI");
    }
    if(exists String scheme = uri.scheme){
        if(scheme != "http"
            && scheme != "https"){
            throw Exception("Only HTTP and HTTPS schemes are supported");
        }
        if(exists tmpPort = uri.authority.port){
            port = tmpPort;
        }else if(scheme == "http"){
            port = 80;
        }else if(scheme == "https"){
            port = 443;
            throw Exception("HTTPS not currently supported (sorry)");
        }
    }else{
        throw Exception("Missing URI scheme");
    }
    
    doc "The host to connect to. Extracted from the specified [[uri]]."
    shared String host;
    if(exists tmpHost = uri.authority.host){
        host = tmpHost;
    }else{
        throw Exception("URI host is not set");
    }
    
    doc "Returns a request header, if it exists. Returns null otherwise."
    shared Header? getHeader(String name){
        String lc = name.lowercased;
        for(header in headers){
            if(header.name.lowercased == lc){
                return header;
            }
        }
        return null;
    }
    
    doc "Sets a request header."
    shared void setHeader(String name, String* values){
        Header? header = getHeader(name);
        if(exists header){
            header.values.clear();
            header.values.addAll(*values);
        }else{
            headers.add(Header(name, *values));
        }
    }
    
    // initial headers
    setHeader("Host", host);
    setHeader("Accept", "*/*");
    setHeader("User-Agent", "curl/7.21.6 (x86_64-pc-linux-gnu) libcurl/7.21.6 OpenSSL/1.0.0e zlib/1.2.3.4 libidn/1.22 librtmp/2.3");
    setHeader("Accept-Charset", "UTF-8");
    
    String prepareRequest() {
        variable String path = uri.pathPart;
        if(path.empty){
            path = "/";
        }
        if(exists query = uri.queryPart){
            path += "?"+query;
        }

        value builder = StringBuilder();
        builder.append(method).append(" ").append(path).append(" ").append("HTTP/1.1").append(crLf);

        // headers
        for(header in headers){
            for(val in header.values){
                builder.append(header.name).append(": ").append(val).append(crLf);
            }
        }
        builder.append(crLf);
        return builder.string;
    }
    
    doc "Executes this request by connecting to the server and returns a [[Response]]."
    shared Response execute(){
        // prepare the request
        value requestContents = prepareRequest();
        // ready to send, convert to a byte buffer
        value requestBuffer = ascii.encode(requestContents);
        
        // now open a socket to the host
        value connector = newSocketConnector(SocketAddress(host, port));
        value socket = connector.connect();
        
        // send the full request
        socket.writeFully(requestBuffer);
        
        // now parse the response
        return Parser(socket).parseResponse();
    }
}