import ceylon.file { Resource }
import ceylon.io.buffer { ByteBuffer }
import ceylon.io { OpenFile }

import java.nio.channels { FileChannel { javaOpenFileChannel = open }}
import java.nio.file { 
	Paths { javaGetPath = get },
	StandardOpenOption { 
		javaCreateOption = \iCREATE,
		javaWriteOption = \iWRITE,
		javaReadOption = \iREAD
	}
}
import ceylon.io.buffer.impl { ByteBufferImpl }

shared class OpenFileImpl(resource) satisfies OpenFile {
    
    shared actual Resource resource;

	FileChannel channel = javaOpenFileChannel(javaGetPath(resource.path.string), 
		javaCreateOption, javaWriteOption, javaReadOption);
    
    shared actual void close() {
        channel.close();
    }

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

}