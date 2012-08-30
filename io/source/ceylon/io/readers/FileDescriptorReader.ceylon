import ceylon.io { FileDescriptor }
import ceylon.io.buffer { ByteBuffer }

shared class FileDescriptorReader(FileDescriptor fileDescriptor) satisfies Reader {
    
    shared actual Integer read(ByteBuffer buffer) {
        return fileDescriptor.read(buffer);
    }
}