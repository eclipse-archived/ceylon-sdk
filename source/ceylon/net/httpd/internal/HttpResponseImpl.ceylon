import ceylon.net.httpd { Response, InternalException }

import io.undertow.server { HttpServerExchange }
import io.undertow.util { HttpString }
import ceylon.io.charset { Charset }
import ceylon.net.http { Header }
import ceylon.collection { MutableList, LinkedList }

import java.io { JIOException=IOException }
import java.lang { JString=String }
import java.nio { JByteBuffer=ByteBuffer { wrapByteBuffer=wrap } }

import org.xnio.channels { StreamSinkChannel, ChannelFactory, 
                           Channels { chFlushBlocking=flushBlocking } }

by "Matej Lazar"
shared class HttpResponseImpl(HttpServerExchange exchange, Charset defaultCharset) 
        satisfies Response {

    ChannelFactory<StreamSinkChannel>? factory = exchange.responseChannelFactory;
    if (!factory exists ) {
        throw InternalException("Cannot get response ChannelFactory."); 
    } 
    
    variable StreamSinkChannel? response = null;
    
    MutableList<Header> headers = LinkedList<Header>();
    
    StreamSinkChannel createResponse() {
        if (exists factory) {
            return factory.create();
        } else {
            throw InternalException("Missing response channel factory.");
        }
    }

    StreamSinkChannel getResponse() {
        if (exists r = response) {
            return r;
        }
        response = createResponse();
        if (exists r = response) {
            return r;
        }
        throw InternalException("response is not avaialble");
    }
    
    //TODO comment encodings and defaults
    shared actual void writeString(String string) {
        writeBytes(JString(string).bytes);
        //TODO use encoder
        //value buffer = findCharset().encode(string);
        //writeBytes(buffer.bytes());
    }
    
    shared actual void writeBytes(Array<Integer> bytes) {
        applyHeadersToExchange();
        
        value bb = wrapByteBuffer(bytes);
        value response = getResponse();
        
        variable Integer remaining = bytes.size;
        while (remaining > 0) {
            variable Integer written = 0;
            while((written = response.write(bb)) > 0) {
                remaining -= written;
                try {
                    response.awaitWritable();
                } catch(JIOException e) {
                    //TODO log
                    print(e);
                }
            }
        }
    }
    
    //TODO test adding header with same name
    shared actual void addHeader(Header header) {
        variable Boolean headerExists = false;
        for (h in headers) {
            if (h.name.lowercased.equals(header.name.lowercased)) {
                for (val in header.values) {
                    h.values.add(val);
                }
                headerExists = true; 
            }
        }
        if (!headerExists) {
            headers.add(header);
        }
    }
    
    shared actual Integer responseStatus {
        return exchange.responseCode;
    }
    assign responseStatus {
        exchange.responseCode = responseStatus;
    }
    
    shared void responseDone() {
        getResponse().shutdownWrites();
        chFlushBlocking(getResponse());
        getResponse().close();
    }

    void applyHeadersToExchange() {
        for(header in headers){
            for(val in header.values){
                exchange.responseHeaders.add(HttpString(header.name), val);
            }
        }
    }
    
    /*Charset findCharset() {
        for (header in headers) {
            if (header.name.lowercased.equals("content-type")) {
                return parseCharset(header);
            }
        }
        return defaultCharset;
    }

    Charset parseCharset(Header header) {
        value headerValue = header.values.first;
        if (exists headerValue) {
            value charsetLabel = "charset=";
            value charsetIndex = headerValue.firstOccurrence(charsetLabel);
            if (exists charsetIndex) {
                String charsetString = headerValue[charsetIndex + charsetLabel.size..headerValue.size].trimmed;
                Charset? charset = getCharset(charsetString);
                if (exists charset) {
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
    }*/
}
