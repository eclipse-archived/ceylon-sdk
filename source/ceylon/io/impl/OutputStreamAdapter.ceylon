import ceylon.io {
    WritableFileDescriptor
}
import ceylon.io.buffer {
    ByteBuffer
}

import java.io {
    OutputStream
}
import java.nio {
    JavaByteBuffer=ByteBuffer
}
import java.nio.channels {
    WritableByteChannel,
    Channels
}

shared class OutputStreamAdapter(OutputStream stream) satisfies WritableFileDescriptor {
    WritableByteChannel channel = Channels.newChannel(stream);
    
    shared actual void close() => channel.close();
    
    shared actual Integer write(ByteBuffer buffer) {
        assert (is JavaByteBuffer implementation = buffer.implementation);
        return channel.write(implementation);
    }
}
