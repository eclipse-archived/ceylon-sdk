import ceylon.io { Socket }
import ceylon.io.buffer { ByteBuffer }
import ceylon.io.buffer.impl { ByteBufferImpl }

import java.nio.channels { SocketChannel, SelectionKey, Selector }

shared class SocketImpl(channel) satisfies Socket {
    
    shared SocketChannel channel;
    
    shared actual void close() {
        channel.close();
    }
    shared default actual Integer read(ByteBuffer buffer) {
        if(is ByteBufferImpl buffer){
            return channel.read(buffer.underlyingBuffer);
        }
        throw;
    }
    shared default actual Integer write(ByteBuffer buffer) {
        if(is ByteBufferImpl buffer){
            return channel.write(buffer.underlyingBuffer);
        }
        throw;
    }
    
    shared actual void setNonBlocking() {
        channel.configureBlocking(false);
    }
    
    shared default SelectionKey register(Selector selector, Integer ops, Object attachment){
        return channel.register(selector, ops, attachment);
    }
    
    shared default void interestOps(SelectionKey key, Integer ops) {
        key.interestOps(ops);
    }
}


