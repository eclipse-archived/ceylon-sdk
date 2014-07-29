import ceylon.io {
    Socket
}
import ceylon.io.buffer {
    ByteBuffer
}
import ceylon.io.buffer.impl {
    ByteBufferImpl
}

import java.nio.channels {
    SocketChannel,
    SelectionKey,
    Selector
}

class SocketImpl(channel) 
        satisfies Socket {
    
    shared SocketChannel channel;
    
    close() => channel.close();
    
    shared default actual Integer read(ByteBuffer buffer) {
        assert(is ByteBufferImpl buffer);
        return channel.read(buffer.underlyingBuffer);
    }
    shared default actual Integer write(ByteBuffer buffer) {
        assert(is ByteBufferImpl buffer);
        return channel.write(buffer.underlyingBuffer);
    }
    
    shared actual Boolean blocking 
            => channel.blocking;
    assign blocking 
            => channel.configureBlocking(blocking);
    
    shared default SelectionKey register(Selector selector, 
        Integer ops, Object attachment)
            => channel.register(selector, ops, attachment);
    
    shared default void interestOps(SelectionKey key, Integer ops) 
            => key.interestOps(ops);
}


