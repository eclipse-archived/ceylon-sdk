import ceylon.collection { MutableList, LinkedList, MutableMap, HashMap }
import ceylon.net.uri { Uri, Parameter }
import ceylon.io.charset { ascii }
import ceylon.io { newSocketConnector, SocketAddress }
import ceylon.net.http { Header, contentType, contentTypeFormUrlEncoded, contentLength }

doc "Represents an HTTP Request"
by("Stéphane Épardaud", "Matej Lazar")
shared class Request(uri, method = "GET"){
    // constant
    String crLf = "\r\n";

    doc "This request URI, must be absolute."
    shared Uri uri;
    
    doc "The list of request parameters."
    MutableMap<String, MutableList<Parameter>> parameters = HashMap<String, MutableList<Parameter>>();
    
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
            header.values.addAll(values);
        }else{
            headers.add(Header(name, *values));
        }
    }
    
    // initial headers
    setHeader("Host", host);
    setHeader("Accept", "*/*");
    setHeader("User-Agent", "curl/7.21.6 (x86_64-pc-linux-gnu) libcurl/7.21.6 OpenSSL/1.0.0e zlib/1.2.3.4 libidn/1.22 librtmp/2.3");
    setHeader("Accept-Charset", "UTF-8");
    
    doc "Returns a list of parameters, if it exists. Returns null otherwise."
    shared MutableList<Parameter>? getParameters(String name) {
        return parameters.get(name);
    }
    
    doc "Returns first parameter, if it exists. Returns null otherwise.
         Note to use `getParameters` if there are multiple items with the same name."
    shared Parameter? getParameter(String name) {
        List<Parameter>? params = getParameters(name);
        if (exists params) {
            return params.first; 
        }
        return null;
    }
    
    shared void setParameter(Parameter parameter) {
        if (exists MutableList<Parameter> params = parameters.get(parameter.name)) {
            params.add(parameter);
        } else {
            MutableList<Parameter> params = LinkedList<Parameter>();
            params.add(parameter);
            parameters.put(parameter.name, params);
        }
    }

    Header defaultContentTypeHeader() {
        //TODO log debug
        print("Using default Content-Type");
        Header contentTypeHeader = contentType(contentTypeFormUrlEncoded);
        headers.add(contentTypeHeader);
        return contentTypeHeader; 
    }
    
    Header contentTypeHeader() {
        variable Header? contentTypeHeader = headers.find((Header header) => header.name.lowercased.startsWith("content-type"));
        return contentTypeHeader else defaultContentTypeHeader();
    }
    
    String preparePostData() {
        if (parameters.size == 0) {
            return "";
        }
        if (exists contentType = contentTypeHeader().values.first) {
            ContentEncoder encoder = createEncoder(contentType);
            return encoder.encode(parameters);
        } else {
            throw Exception("Shouldn't be here.");
        }
    }
    
    String prepareRequest() {
        variable String path = uri.pathPart;
        if(path.empty){
            path = "/";
        }
        if(exists query = uri.queryPart) {
            path += "?"+query;
        }

        value builder = StringBuilder();
        builder.append(method).append(" ").append(path).append(" ").append("HTTP/1.1").append(crLf);

        String postData = preparePostData();
        if (!postData.empty) {
            headers.add(contentLength(postData.size.string));
        }
        
        // headers
        for(header in headers){
            for(val in header.values){
                builder.append(header.name).append(": ").append(val).append(crLf);
            }
        }
        builder.append(crLf);
        
        if (!postData.empty) {
            builder.append(postData);
        }

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