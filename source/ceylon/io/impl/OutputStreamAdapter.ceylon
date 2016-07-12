import ceylon.buffer {
    ByteBuffer
}
import ceylon.io {
    WritableFileDescriptor
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
    
    close() => channel.close();
    
    shared actual Integer write(ByteBuffer buffer) {
        assert (is JavaByteBuffer implementation = buffer.implementation);
        return channel.write(implementation);
    }
}
