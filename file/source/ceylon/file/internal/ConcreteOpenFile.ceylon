import ceylon.file { OpenFile, File }
import ceylon.io.buffer { ByteBuffer }

import java.nio.channels { FileChannel { javaOpenFileChannel = open }}
import java.nio.file { JavaPath = Path }

class ConcreteOpenFile(ConcreteFile concreteFile, JavaPath path) satisfies OpenFile {
    
    FileChannel channel = javaOpenFileChannel(path);
    
    shared actual void close() {
        channel.close();
    }

    shared actual File file = concreteFile;

    shared actual Integer position {
        return channel.position();
    }
    assign position {
        channel.position(position);
    }

    shared actual Integer size {
        return channel.size();
    }

    shared actual void truncate(Integer size) {
        channel.truncate(size);
    }

    shared actual Integer read(ByteBuffer buffer) {
        // FIXME: how do we get to the underlying Java ByteBuffer?
        return bottom;
    }

    shared actual Integer write(ByteBuffer buffer) {
        // FIXME: how do we get to the underlying Java ByteBuffer?
        return bottom;
    }

}