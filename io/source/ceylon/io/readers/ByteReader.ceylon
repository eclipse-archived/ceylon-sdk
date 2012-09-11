import ceylon.io.buffer { newByteBuffer, ByteBuffer }

doc "Reader that can be used to read one byte at a time from
     the specified [[reader]]."
shared class ByteReader(Reader reader) satisfies Reader {
    
    value buffer = newByteBuffer(1);
    
    doc "Reads a single byte from the underlying [[reader]].
         Returns the byte read, or `-1` on end of file. 
         
         This method blocks the current thread until a byte is read
         or end of file is reached, so if the underlying reader
         is `non-blocking` then this method will do very expensive
         active polling."
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
 
    doc "Reads the specified buffer, pass-through to the underlying
         [[reader]]."
    shared actual Integer read(ByteBuffer buffer) {
        return reader.read(buffer);
    }

}