import ceylon.io { Socket }
import ceylon.io.buffer { ByteBuffer }
import ceylon.io.buffer.impl { ByteBufferImpl }

import java.nio.channels { SocketChannel }

shared class SocketImpl(channel) satisfies Socket {
    
    shared SocketChannel channel;
    
    shared actual void close() {
        channel.close();
    }
    shared actual Integer read(ByteBuffer buffer) {
        if(is ByteBufferImpl buffer){
            return channel.read(buffer.underlyingBuffer);
        }
        throw;
    }
    shared actual Integer write(ByteBuffer buffer) {
        if(is ByteBufferImpl buffer){
            return channel.write(buffer.underlyingBuffer);
        }
        throw;
    }
    
    shared actual void setNonBlocking() {
        channel.configureBlocking(false);
    }
}


