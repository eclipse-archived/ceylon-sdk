import ceylon.net.http.server { Response, Exception }

import io.undertow.server { HttpServerExchange }
import io.undertow.util { HttpString }
import ceylon.io.charset { Charset, getCharset }
import ceylon.net.http { Header }
import ceylon.collection { MutableList, LinkedList }

import java.io { JIOException=IOException }
import java.lang { arrays, ByteArray }
import java.nio { 
    JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import org.xnio.channels { StreamSinkChannel,
                           Channels { chFlushBlocking=flushBlocking } }
import ceylon.io.buffer { Buffer }

by("Matej Lazar")
shared class ResponseImpl(HttpServerExchange exchange, Charset defaultCharset) 
        satisfies Response {

    variable StreamSinkChannel? lazyResponse = null;
    StreamSinkChannel response => lazyResponse else (lazyResponse=exchange.responseChannel);

    MutableList<Header> headers = LinkedList<Header>();
    variable value headersSent = false;
    
    //TODO comment encodings and defaults
    shared actual void writeString(String string) {
        applyHeadersToExchange();

        value charset = findCharset();
        Buffer<Integer> buffer = charset.encode(string);
        
        ByteArray bytes = ByteArray(buffer.available);
        variable Integer i = 0;
        while(buffer.hasAvailable) {
            bytes.set(i++, buffer.get());
        }
        value bb = wrapByteBuffer(bytes);
        response.write(bb);
        try {
            response.awaitWritable();
        } catch(JIOException e) {
            //TODO log
            print(e);
        }
    }
    
    shared actual void writeBytes(Array<Integer> bytes) {
        applyHeadersToExchange();
        
        value bb = wrapByteBuffer(arrays.asByteArray(bytes));
        
        variable Integer remaining = bytes.size;
        while (remaining > 0) {
            variable Integer written = 0;
            
            while(bb.hasRemaining()) {
                written = response.write(bb);
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
        if (headersSent) {
            throw Exception("Headers already sent to client.");
        }
        variable Boolean headerExists = false;
        for (h in headers) {
            if (h.name.lowercased.equals(header.name.lowercased)) {
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
    
    shared actual Integer responseStatus {
        return exchange.responseCode;
    }
    assign responseStatus {
        exchange.responseCode = responseStatus;
    }
    
    shared void responseDone() {
        //Retry to apply headers, if there were no writes, headers were not applied.
        applyHeadersToExchange();
        
        response.shutdownWrites();
        chFlushBlocking(response);
        response.close();
    }

    void applyHeadersToExchange() {
        if (headersSent) {
            return;
        }
        for(header in headers){
            for(val in header.values){
                //TODO log fine print("Applying header [``header.name``] with value [``val``].");
                exchange.responseHeaders.put(HttpString(header.name), val);
            }
        }
        headersSent = true;
    }
    
    Charset findCharset() {
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
            value charsetIndex = headerValue.firstInclusion(charsetLabel);
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
    }
}
