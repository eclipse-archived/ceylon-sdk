import ceylon.net.http.server { Response, Exception }

import io.undertow.server { HttpServerExchange }
import io.undertow.util { HttpString }
import ceylon.io.charset { Charset, getCharset }
import ceylon.net.http { Header }
import ceylon.collection { MutableList, LinkedList }

import java.io { JIOException=IOException }
import java.lang { ByteArray, Runnable }
import java.nio { 
    JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import org.xnio.channels { StreamSinkChannel }
import ceylon.io.buffer { ByteBuffer }
import io.undertow.io { JIoCallback = IoCallback }

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
        ByteBuffer buffer = charset.encode(string);
        writeJByteBuffer(nativeByteBuffer(buffer));
    }

    shared actual void writeStringAsynchronous(
            String string,
            Callable<Anything, []> onCompletion,
            Callable<Anything, [Exception]>? onError) {

        void task() {
            applyHeadersToExchange();
            value charset = findCharset();
            ByteBuffer byteBuffer = charset.encode(string);
            writeByteBufferAsynchronous(byteBuffer, onCompletion, onError);
        }

        exchange.dispatch(
            Task { 
                task => task;
                onCompletion => onCompletion;
                onError => onError;
            }
        );
    }

    shared actual void writeBytes(Array<Integer> bytes) {
        applyHeadersToExchange();

        value jByteBuffer = wrapByteBuffer(toByteArray(bytes));
        writeJByteBuffer(jByteBuffer);
    }
    
    shared actual void writeBytesAsynchronous(
            Array<Integer> bytes,
            Callable<Anything, []> onCompletion,
            Callable<Anything, [Exception]>? onError) {

        applyHeadersToExchange();
        value jByteBuffer = wrapByteBuffer(toByteArray(bytes));
        writeJByteBufferAsynchronous(jByteBuffer, IoCallbackWrapper(onCompletion, onError));
    }
    
    shared actual void writeByteBuffer(ByteBuffer byteBuffer) {
        applyHeadersToExchange();
        writeJByteBuffer(nativeByteBuffer(byteBuffer));
    }

    shared actual void writeByteBufferAsynchronous(
            ByteBuffer byteBuffer,
            Callable<Anything, []> onCompletion,
            Callable<Anything, [Exception]>? onError) {

        applyHeadersToExchange();
        writeJByteBufferAsynchronous(nativeByteBuffer(byteBuffer), IoCallbackWrapper(onCompletion, onError));
    }

    void writeJByteBuffer(JByteBuffer byteBuffer) {
        while(byteBuffer.hasRemaining()) {
            response.write(byteBuffer);
            try {
                response.awaitWritable();
            } catch(JIOException e) {
                throw Exception("Cannot write response.", e);
            }
        }
    }
    
    void writeJByteBufferAsynchronous(JByteBuffer jByteBuffer, JIoCallback sendCallback) {
        if (jByteBuffer.hasRemaining()) {
            exchange.responseSender.send(jByteBuffer, sendCallback);
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

    JByteBuffer nativeByteBuffer(ByteBuffer byteBuffer) {
        Object? implementation = byteBuffer.implementation;
        if (is JByteBuffer implementation ) {
            return implementation;
        } else {
            //TODO log warning
            print("Cannot access native implementation of ByteBuffer. Copying values ...");
            ByteArray bytes = ByteArray(byteBuffer.available);
            variable Integer i = 0;
            while(byteBuffer.hasAvailable) {
                bytes.set(i++, byteBuffer.get());
            }
            return wrapByteBuffer(bytes);
        }
    }
    
    class Task (
        Callable<Anything, []> task,
        Callable<Anything, []> onCompletion,
        Callable<Anything, [Exception]>? onError)
            satisfies Runnable {
        
        shared actual void run() {
            task();
        }
    }
    
}
