/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    MutableList,
    LinkedList
}
import ceylon.buffer {
    ByteBuffer
}
import ceylon.io {
    OpenFile
}
import ceylon.buffer.charset {
    Charset,
    charsetsByAlias
}
import ceylon.http.common {
    Header
}
import ceylon.http.server {
    Response,
    ServerException
}

import io.undertow.io {
    JIoCallback=IoCallback
}
import io.undertow.server {
    HttpServerExchange
}
import io.undertow.util {
    HttpString
}

import java.io {
    JIOException=IOException
}
import java.lang {
    ByteArray
}
import java.nio {
    JByteBuffer=ByteBuffer {
        wrapByteBuffer=wrap
    }
}

import org.xnio.channels {
    StreamSinkChannel
}
import java.nio.channels {
    FileChannel
}

by("Matej Lazar")
class ResponseImpl(HttpServerExchange exchange, 
    Charset defaultCharset) 
        satisfies Response {

    variable StreamSinkChannel? lazyResponse = null;
    StreamSinkChannel response => lazyResponse 
            else (lazyResponse=exchange.responseChannel);

    MutableList<Header> headers = LinkedList<Header>();
    variable value headersSent = false;
    
    //TODO comment encodings and defaults
    shared actual void writeString(String string) {
        applyHeadersToExchange();
        value buffer = findCharset().encodeBuffer(string);
        writeJByteBuffer(nativeByteBuffer(buffer));
    }

    shared actual void writeStringAsynchronous(
            String string,
            void onCompletion(),
            void onError(ServerException e)) {
        applyHeadersToExchange();
        value byteBuffer = findCharset().encodeBuffer(string);
        writeJByteBufferAsynchronous(
            nativeByteBuffer(byteBuffer), 
            IoCallbackWrapper(onCompletion, onError));
    }

    shared actual void writeBytes(Array<Byte> bytes) {
        applyHeadersToExchange();
        writeJByteBuffer(wrapByteBuffer(ByteArray.from(bytes)));
    }
    
    shared actual void writeBytesAsynchronous(
            Array<Byte> bytes,
            void onCompletion(),
            void onError(ServerException e)) {

        applyHeadersToExchange();
        writeJByteBufferAsynchronous(wrapByteBuffer(ByteArray.from(bytes)),
            IoCallbackWrapper(onCompletion, onError));
    }
    
    shared actual void writeByteBuffer(ByteBuffer byteBuffer) {
        applyHeadersToExchange();
        writeJByteBuffer(nativeByteBuffer(byteBuffer));
    }

    shared actual void writeByteBufferAsynchronous(
            ByteBuffer byteBuffer,
            void onCompletion(),
            void onError(ServerException e)) {

        applyHeadersToExchange();
        writeJByteBufferAsynchronous(nativeByteBuffer(byteBuffer), 
            IoCallbackWrapper(onCompletion, onError));
    }

    shared actual void transferFile(OpenFile openFile) {
        
        applyHeadersToExchange();
        assert(is FileChannel fileChannel = openFile.implementation);
        transferFileChannel(fileChannel);
    }

    shared actual void transferFileAsynchronous(
        OpenFile openFile,
        void onCompletion(),
        void onError(ServerException e)) {
        
        applyHeadersToExchange();
        assert(is FileChannel fileChannel = openFile.implementation);
        transferFileChannelAsynchronous(fileChannel, 
            IoCallbackWrapper(onCompletion, onError));
    }

    void writeJByteBuffer(JByteBuffer byteBuffer) {
        while(byteBuffer.hasRemaining()) {
            response.write(byteBuffer);
            try {
                response.awaitWritable();
            } catch(JIOException e) {
                throw ServerException("Cannot write response.", e);
            }
        }
    }
    
    void writeJByteBufferAsynchronous(JByteBuffer jByteBuffer, 
        JIoCallback sendCallback) {
        if (jByteBuffer.hasRemaining()) {
            exchange.responseSender.send(jByteBuffer, sendCallback);
        }
    }

    void transferFileChannel(FileChannel fileChannel) {
        value size = fileChannel.size();
        variable value written = 0;
        while(written < size){
            written += response.transferFrom(fileChannel, written, size - written);
            try {
                response.awaitWritable();
            } catch(JIOException e) {
                throw ServerException("Cannot write response.", e);
            }
        }
    }

    void transferFileChannelAsynchronous(FileChannel fileChannel, JIoCallback ioCallback) {
        exchange.responseSender.transferFrom(fileChannel, ioCallback);
    }
    
    //TODO test adding header with same name
    shared actual void addHeader(Header header) {
        if (headersSent) {
            throw ServerException("Headers already sent to client.");
        }
        variable Boolean headerExists = false;
        for (h in headers) {
            if (h.name.equalsIgnoringCase(header.name)) {
                for (val in header.values) {
                    //TODO log trace print("Adding value [``val``] to header [``header.name``].");
                    h.values.add(val);
                }
                headerExists = true; 
            }
        }
        if (!headerExists) {
            //TODO log trace print("Adding new header [``header.name``] with values [``header.values``].");
            headers.add(header);
        }
    }
    
    shared actual Integer status => exchange.statusCode;
    assign status => exchange.setStatusCode(status);
    
    shared actual Integer responseStatus => status;
    assign responseStatus => status = responseStatus;
    
    shared void responseDone() {
        //Retry to apply headers, if there were no writes, headers were not applied.
        applyHeadersToExchange();
    }

    void applyHeadersToExchange() {
        if (headersSent) {
            return;
        }
        for(header in headers) {
            for(val in header.values) {
                //TODO log fine print("Applying header [``header.name``] with value [``val``].");
                exchange.responseHeaders.put(HttpString(header.name), val);
            }
        }
        headersSent = true;
    }
    
    Charset findCharset() {
        for (header in headers) {
            if (header.name.equalsIgnoringCase("content-type")) {
                return parseCharset(header);
            }
        }
        return defaultCharset;
    }

    Charset parseCharset(Header header) {
        if (exists headerValue = header.values.first) {
            value charsetLabel = "charset=";
            if (exists charsetIndex = headerValue.firstInclusion(charsetLabel)) {
                value startIndex = charsetIndex + charsetLabel.size;
                value endIndex = headerValue.size;
                String charsetString = headerValue[startIndex..endIndex].trimmed;
                if (exists charset = charsetsByAlias[charsetString]) {
                    return charset;
                } else {
                    //TODO log
                    print("Charset ``charsetString`` is not supported.");
                }
            } else {
                //TODO log warn
                print("Malformed content-type header: ``headerValue``.");
            }
        }
        return defaultCharset;
    }

    JByteBuffer nativeByteBuffer(ByteBuffer byteBuffer) {
        if (is JByteBuffer implementation = byteBuffer.implementation) {
            return implementation;
        } else {
            //TODO log warning
            print("Cannot access native implementation of ByteBuffer. Copying values ...");
            value bytes = ByteArray(byteBuffer.available);
            variable Integer i = 0;
            while(byteBuffer.hasAvailable) {
                bytes[i++] = byteBuffer.get();
            }
            return wrapByteBuffer(bytes);
        }
    }
    
    shared actual void flush(){
        exchange.endExchange();
    }
    shared actual void close(){
    }
}
