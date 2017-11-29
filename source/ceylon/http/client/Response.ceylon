/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.io {
    FileDescriptor
}
import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.charset {
    ascii,
    charsetsByAlias
}
import ceylon.buffer.readers {
    Reader
}
import ceylon.io.readers {
    FileDescriptorReader
}
import ceylon.http.common {
    Header
}

"Represents an HTTP Response"
by("Stéphane Épardaud")
shared class Response(status, reason, major, minor, 
    FileDescriptor socket, Parser parser) 
        satisfies Correspondence<String, Header>{
    
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
    shared List<Header> headers => parser.headers;

    "The HTTP headers as a [[Map]]"
    shared Map<String,Header> headersByName 
            => parser.headersByName;

    "True if the content-type starts with `text/`"
    shared Boolean isText 
            => this.contentTypeLine?.startsWith("text/") else false;

    "The content-type, if set. Null otherwise."
    shared String? contentType 
            => this.contentTypeLine?.split(';'.equals)?.first else null;

    "The charset, if set. Null otherwise."
    shared String? charset {
        if(exists contentTypeLine = this.contentTypeLine) {
            // split it if required
            value params = contentTypeLine.split(';'.equals).rest;
            for(param in params) {
                value trimmed = param.trimmed;
                let ([first, *rest] = trimmed.split('='.equals).sequence());
                if(first == "charset") {
                    return rest[0];
                }
            }
        }
        return null;
    }

    "Returns a single header value, if there is a single 
     value present. Returns null if the header cannot be 
     found or has more than one value."
    shared String? getSingleHeader(String name) {
        if(exists contentType = this[name]) {
            if(contentType.values.size != 1) {
                return null;
            }
            return contentType.values[0];
        }else{
            return null;
        }
    }

    "Returns the content type header, unparsed."
    shared String? contentTypeLine 
            => getSingleHeader("Content-Type");
    
    "Builds a debugging representation of this HTTP response."
    shared actual String string {
        StringBuilder b = StringBuilder();
        b.append("HTTP/`` major ``.`` minor `` `` status `` `` reason ``\n");
        for(header in headers) {
            for(val in header.values) {
                b.append(header.name)
                 .append(": ")
                 .append(val)
                 .append("\n");
            }
        }
        return b.string;
    }
    
    "Fetches a header by name, returns null if the header 
     does not exist."
    shared actual Header? get(String key) 
            => headersByName[key.lowercased];

    shared actual Boolean defines(String key) 
            => headersByName.defines(key);

    "Returns a [[Reader]] for the entity body."
    shared Reader getReader() {
        if(exists transferEncoding 
            = getSingleHeader("Transfer-Encoding"),
                transferEncoding == "chunked") {
            return ChunkedEntityReader(socket);
        }
        return FileDescriptorReader(socket, contentLength);
    }

    class ChunkedEntityReader(FileDescriptor fileDescriptor) 
            extends Reader() {
    
        variable Boolean firstChunk = true;
        variable Integer nextChunkSize = 0;
        variable Boolean lastChunkRead = false;

        void parseChunkHeader() {
            nextChunkSize = parser.parseChunkHeader(firstChunk);
            firstChunk = false;
            lastChunkRead = nextChunkSize == 0;
            if(lastChunkRead) {
                // add optional headers
                parser.parseChunkTrailer();
            }
        }
        
        shared actual Integer read(ByteBuffer buffer) {
            if(lastChunkRead) {
                return -1;
            }
            // did we deplete the last chunk?
            if(nextChunkSize == 0) {
                // read a new chunk and goto 0
                parseChunkHeader();
                return read(buffer);
            }
            // only read up to the chunk size available
            if(buffer.available > nextChunkSize) {
                buffer.limit = buffer.position + nextChunkSize;
            }
            Integer bytesRead = fileDescriptor.read(buffer);
            // if we came to EOF, mark ourselves as EOF even 
            // though it's not normal
            // FIXME: should we barf?
            if(bytesRead == -1) {
                lastChunkRead = true;
            }else{
                nextChunkSize -= bytesRead;
            }
            return bytesRead;
        }
        
    }
    
    "Returns the entity body as a [[String]]."
    shared String contents {
        if(exists x = readException) {
            throw x;
        }
        if(exists c = readContents) {
            return c;
        }
        try{
            String c = readEntityBody();
            readContents = c;
            return c;
        }catch(Exception x) {
            readException = x;
            throw x;
        }
    }
    
    String readEntityBody() {
        value reader = getReader();
        ByteBuffer buffer = ByteBuffer.ofSize(4096);
        value encoding = charsetsByAlias[charset else "ASCII"] else ascii;
        value body = encoding.cumulativeDecoder(contentLength);
        while(reader.read(buffer) != -1) {
            buffer.flip();
            body.more(buffer);
            buffer.clear();
        }
        return body.done().string;
    }
    
    "Returns the entity `Content-Length`, if known. Returns 
     `null` otherwise."
    shared Integer? contentLength {
        // http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.13

        if(exists header = getSingleHeader("Content-Length"),
           is Integer int = Integer.parse(header)) {
            // Spec says that negative numbers should not count
            return int >= 0 then int;
        }
        return null;
    }

    "Closes the underlying [[FileDescriptor]]."    
    shared void close() => socket.close();
}
