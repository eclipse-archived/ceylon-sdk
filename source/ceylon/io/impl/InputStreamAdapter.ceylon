import ceylon.buffer {
    ByteBuffer
}
import ceylon.io {
    ReadableFileDescriptor
}

import java.io {
    InputStream
}
import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    ReadableByteChannel,
    Channels
}

shared class InputStreamAdapter(InputStream stream) satisfies ReadableFileDescriptor {
    ReadableByteChannel channel = Channels.newChannel(stream);
    
    shared actual void close() => channel.close();
    
    shared actual Integer read(ByteBuffer buffer) {
        assert (is JavaByteBuffer implementation = buffer.implementation);
        return channel.read(implementation);
    }
}
