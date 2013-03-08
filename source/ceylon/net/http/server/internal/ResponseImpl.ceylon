import ceylon.net.http.server { Response }

import io.undertow.server { HttpServerExchange }
import io.undertow.util { HttpString }
import ceylon.io.charset { Charset, getCharset }
import ceylon.net.http { Header }
import ceylon.collection { MutableList, LinkedList }

import java.io { JIOException=IOException }
import java.lang { JString=String, arrays }
import java.nio { 
    JByteBuffer=ByteBuffer { wrapByteBuffer=wrap },
    CharBuffer {wrapCharBuffer = wrap} }
import java.nio.charset {JCharset = Charset {charsetForName=forName}}
import org.xnio.channels { StreamSinkChannel,
                           Channels { chFlushBlocking=flushBlocking } }

by "Matej Lazar"
shared class ResponseImpl(HttpServerExchange exchange, Charset defaultCharset) 
        satisfies Response {

    variable StreamSinkChannel? lazyResponse = null;
    StreamSinkChannel response => lazyResponse else (lazyResponse=exchange.responseChannel);

    MutableList<Header> headers = LinkedList<Header>();
    
    //TODO comment encodings and defaults
    shared actual void writeString(String string) {
        //TODO use encoder
        value charset = findCharset();
        writeBytes(toByteArray(string, charsetForName(charset.name)));
        //TODO use ceylon encoder
        //value buffer = charset.encode(string);
        //writeBytes(buffer.bytes());
    }
    //TODO remove
    Array<Integer> toByteArray(String string, JCharset charset) {
        CharBuffer cbuf = wrapCharBuffer(JString(string).toCharArray());
        JByteBuffer bbuf = charset.encode(cbuf);
        return bbuf.array().array;
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
        response.shutdownWrites();
        chFlushBlocking(response);
        response.close();
    }

    void applyHeadersToExchange() {
        for(header in headers){
            for(val in header.values){
                exchange.responseHeaders.add(HttpString(header.name), val);
            }
        }
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
    }
}
