import ceylon.io.buffer { newByteBuffer, ByteBuffer }

shared class ByteReader(Reader reader) satisfies Reader {
    
    value buffer = newByteBuffer(1);
    
    shared Integer readByte(){
        buffer.clear();
        while(read(buffer) >= 0){
            // did we get anything?
            if(!buffer.hasAvailable){
                buffer.flip();
                return buffer.get();
            }
            // try again
        }
        // EOF
        return -1;
    }
    
    shared actual Integer read(ByteBuffer buffer) {
        return reader.read(buffer);
    }

}