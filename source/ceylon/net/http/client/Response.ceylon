import ceylon.io { FileDescriptor }
import ceylon.io.buffer { ByteBuffer, newByteBuffer }
import ceylon.io.readers { Reader, FileDescriptorReader }
import ceylon.io.charset { ascii, getCharset }
import ceylon.net.http { Header }

"Represents an HTTP Response"
by("Stéphane Épardaud")
shared class Response(status, reason, major, minor, FileDescriptor socket, Parser parser) satisfies Correspondence<String, Header>{
    
    "The HTTP status code"
    shared Integer status;
    
    "The HTTP reason line"
    shared String reason;
    
    "The HTTP major number"
    shared Integer major;

    "The HTTP major number"
    shared Integer minor;

    variable Exception? readException = null;
    variable String? readContents = null;
    
    "The HTTP headers as a [[List]]"
    shared List<Header> headers {
        return parser.headers;
    }

    "The HTTP headers as a [[Map]]"
    shared Map<String,Header> headersByName {
        return parser.headersByName;
    }

    "True if the content-type starts with `text/`"
    shared Boolean isText {
        String? contentType = this.contentTypeLine;
        if(exists contentType){
            return contentType.startsWith("text/");
        }
        return false;
    }

    "The content-type, if set. Null otherwise."
    shared String? contentType {
        String? contentTypeLine = this.contentTypeLine;
        if(exists contentTypeLine){
            // split it if required
            value sep = contentTypeLine.firstInclusion(";");
            if(exists sep){
                return contentTypeLine.segment(0, sep);
            }else{
                return contentTypeLine;
            }
        }
        return null;
    }

    "The charset, if set. Null otherwise."
    shared String? charset {
        String? contentTypeLine = this.contentTypeLine;
        if(exists contentTypeLine){
            // split it if required
            value params = contentTypeLine.split((Character c) => c == ';').rest;
            for(param in params){
                value trimmed = param.trimmed;
                value keyValue = trimmed.split((Character c) => c == '=').sequence;
                if(nonempty keyValue){
                    if(keyValue.first == "charset"){
                        return keyValue[1];
                    }
                }
            }
        }
        return null;
    }

    "Returns a single header value, if there is a single value present.
     Returns null if the header cannot be found or has more than one value."
    shared String? getSingleHeader(String name){
        Header? contentType = this[name];
        if(exists contentType){
            if(contentType.values.size != 1){
                return null;
            }
            return contentType.values[0];
        }else{
            return null;
        }
    }

    "Returns the content type header, unparsed."
    shared String? contentTypeLine {
        return getSingleHeader("Content-Type");
    }
    
    "Builds a debugging representation of this HTTP response."
    shared actual String string {
        StringBuilder b = StringBuilder();
        b.append("HTTP/`` major ``.`` minor `` `` status `` `` reason ``\n");
        for(header in headers){
            for(val in header.values){
                b.append(header.name).append(": ").append(val).append("\n");
            }
        }
        return b.string;
    }
    
    "Fetches a header by name, returns null if the header does not exist."
    shared actual Header? get(String key) {
        return headersByName[key.lowercased];
    }

    "Returns a [[Reader]] for the entity body."
    throws(`class Exception`, "If the status is not 200 OK.")
    shared Reader getReader(){
        if(status != 200){
            throw Exception("Status is not OK");
        }
        String? transferEncoding = getSingleHeader("Transfer-Encoding");
        if(exists transferEncoding){
            if(transferEncoding == "chunked"){
                return ChunkedEntityReader(socket);
            }
        }
        return FileDescriptorReader(socket, contentLength);
    }

    class ChunkedEntityReader(FileDescriptor fileDescriptor) satisfies Reader {
    
        variable Boolean firstChunk = true;
        variable Integer nextChunkSize = 0;
        variable Boolean lastChunkRead = false;

        void parseChunkHeader(){
            nextChunkSize = parser.parseChunkHeader(firstChunk);
            firstChunk = false;
            lastChunkRead = nextChunkSize == 0;
            if(lastChunkRead){
                // add optional headers
                parser.parseChunkTrailer();
            }
        }
        
        shared actual Integer read(ByteBuffer buffer) {
            if(lastChunkRead){
                return -1;
            }
            // did we deplete the last chunk?
            if(nextChunkSize == 0){
                // read a new chunk and goto 0
                parseChunkHeader();
                return read(buffer);
            }
            // only read up to the chunk size available
            if(buffer.available > nextChunkSize){
                buffer.limit = buffer.position + nextChunkSize;
            }
            Integer bytesRead = fileDescriptor.read(buffer);
            // if we came to EOF, mark ourselves as EOF even though it's not normal
            // FIXME: should we barf?
            if(bytesRead == -1){
                lastChunkRead = true;
            }else{
                nextChunkSize -= bytesRead;
            }
            return bytesRead;
        }
    }
    
    "Returns the entity body as a [[String]]."
    throws(`class Exception`, "If the status code is not 200")
    shared String contents {
        if(exists x = readException){
            throw x;
        }
        if(exists c = readContents){
            return c;
        }
        try{
            String c = readEntityBody();
            readContents = c;
            return c;
        }catch(Exception x){
            readException = x;
            throw x;
        }
    }
    
    String readEntityBody() {
        // that's a bit of a simplification ;)
        if(status == 200){
            value reader = getReader();
            ByteBuffer buffer = newByteBuffer(4096);
            value encoding = getCharset(charset else "ASCII") else ascii;
            value decoder = encoding.newDecoder();
            while(reader.read(buffer) != -1){
                buffer.flip();
                decoder.decode(buffer);
                buffer.clear();
            }
            return decoder.done();
        }
        throw Exception("Failed to read contents");
    }
    
    "Returns the entity `Content-Length`, if known. Returns `null` otherwise."
    shared Integer? contentLength {
        // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.13
        value header = getSingleHeader("Content-Length");
        if(exists header){
            value int = parseInteger(header);
            if(exists int){
                // Spec says that negative numbers should not count
                return int >= 0 then int;
            }
        }
        return null;
    }

    "Closes the underlying [[FileDescriptor]]."    
    shared void close(){
        socket.close();
    }
}
