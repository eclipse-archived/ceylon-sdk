import ceylon.net.httpd { HttpResponse, HttpdInternalException }
import io.undertow.server { HttpServerExchange }
import org.xnio.channels { StreamSinkChannel, ChannelFactory, Channels {chFlushBlocking = flushBlocking}}
import java.nio { JByteBuffer = ByteBuffer {wrapByteBuffer = wrap} }
import java.lang { JString = String }
import java.io { JIOException = IOException }
import io.undertow.util { HttpString }

by "Matej Lazar"
shared class HttpResponseImpl(HttpServerExchange exchange) satisfies HttpResponse {
    
    ChannelFactory<StreamSinkChannel>? factory = exchange.responseChannelFactory;
    if (!factory exists ) {
        throw HttpdInternalException("Cannot get response ChannelFactory."); 
    } 
    
    variable StreamSinkChannel? response = null;
    
    StreamSinkChannel createResponse() {
        if (exists factory) {
            return factory.create();
        } else {
            throw HttpdInternalException("Missing response channel factory.");
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
        throw HttpdInternalException("response is not avaialble");
    }
    
    shared actual void writeString(String string) {
        writeBytes(JString(string).bytes);
    }
    
    shared actual void writeBytes(Array<Integer> bytes) {
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
    
    shared actual void addHeader(String headerName, String headerValue) {
        exchange.responseHeaders.add(HttpString(headerName), headerValue);
    }
    
    shared actual void responseStatus(Integer responseStatusCode) {
        exchange.responseCode = responseStatusCode;
    }
    
    shared void responseDone() {
        getResponse().shutdownWrites();
        chFlushBlocking(getResponse());
        getResponse().close();
    }
}