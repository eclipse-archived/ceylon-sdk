import ceylon.io.buffer { ByteBuffer }

doc "Represents an object that can read data from a source
     into byte buffers."
shared interface Reader {
    
    doc "Reads data into the specified [[buffer]] and return the number
         of bytes read, or `-1` if the end of file is reached."
    formal shared Integer read(ByteBuffer buffer);
}