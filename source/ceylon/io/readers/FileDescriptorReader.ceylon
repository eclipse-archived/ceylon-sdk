import ceylon.io {
    FileDescriptor
}
import ceylon.io.buffer {
    ByteBuffer,
    newByteBuffer
}
import ceylon.interop.java {
    javaByteArray
}

"Reader that can read from a [[FileDescriptor]].
 
 If [[length]] is specified, this reader will read at most 
 [[length]] bytes until it considers that it reached end of 
 file."
by("Stéphane Épardaud")
shared class FileDescriptorReader(fileDescriptor, 
    Integer? length = null) 
        extends Reader() {
    
    shared FileDescriptor fileDescriptor;
    
    variable Integer position = 0;
    
    "Reads data into the specified [[buffer]] and return the number
     of bytes read, or `-1` if the end of file is reached."
    shared actual Integer read(ByteBuffer buffer) {
        if(exists length) {
            // check that we didn't already read it all
            if(position == length) {
                return -1;
            }
            // maybe decrease the max to read from the buffer if required
            Integer remaining = length - position;
            if(buffer.available > remaining) {
                buffer.limit = buffer.position + remaining;
            }
        }
        Integer r = fileDescriptor.read(buffer);
        if(r == -1) {
            return r;
        }
        position += r;
        return r;
    }

    shared actual Integer readByteArray(Array<Byte> array) {
        //TODO: is it horribly inefficient to allocate
        //      a new byte buffer here??
        value buffer = newByteBuffer(array.size);
        value result = read(buffer);
        value byteArray = javaByteArray(array);
        for (i in 0:result) {
            byteArray.set(i, buffer.getByte());
        }
        return result;
    }
}