import ceylon.file {
    Resource
}
import ceylon.io {
    OpenFile
}
import ceylon.io.buffer {
    ByteBuffer
}
import ceylon.io.buffer.impl {
    ByteBufferImpl
}

import java.nio.channels {
    FileChannel {
        javaOpenFileChannel=open
    }
}
import java.nio.file {
    Paths {
        javaGetPath=get
    },
    StandardOpenOption {
        javaCreateOption=CREATE,
        javaWriteOption=WRITE,
        javaReadOption=READ
    }
}

shared class OpenFileImpl(resource) 
        satisfies OpenFile {
    
    shared actual Resource resource;

	FileChannel channel = 
			javaOpenFileChannel(javaGetPath(resource.path.string), 
		            javaCreateOption, javaWriteOption, javaReadOption);
    
    close() => channel.close();

    size => channel.size();
    
    truncate(Integer size) => channel.truncate(size);
    
    shared actual Integer position => channel.position();
    assign position => channel.position(position);

    shared actual Integer read(ByteBuffer buffer) {
        assert(is ByteBufferImpl buffer);
        return channel.read(buffer.underlyingBuffer);
    }

    shared actual Integer write(ByteBuffer buffer) {
        assert(is ByteBufferImpl buffer);
        return channel.write(buffer.underlyingBuffer);
    }

    shared actual Object implementation => channel;
}