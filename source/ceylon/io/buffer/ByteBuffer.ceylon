import ceylon.io.buffer.impl { ByteBufferImpl }

"Represents a buffer of bytes (from 0 to 255 inclusive, unsigned).
 
 You can create new instances with [[newByteBuffer]] (empty) and
 [[newByteBufferWithData]] (filled with your data)."
by("Stéphane Épardaud")
see(`class Buffer`,
    `function newByteBuffer`,
    `function newByteBufferWithData`)
shared abstract class ByteBuffer() extends Buffer<Byte>(){
    shared formal Array<Byte> bytes();
    
    "The platform-specific implementation object, if any."
    shared formal Object? implementation;
}

"Allocates a new empty [[ByteBuffer]] of the given [[capacity]]."
by("Stéphane Épardaud")
see(`class ByteBuffer`,
    `function newByteBufferWithData`,
    `class Buffer`)
shared ByteBuffer newByteBuffer(Integer capacity)
        => ByteBufferImpl(capacity);

"Allocates a new [[ByteBuffer]] filled with the [[bytes]] given
 as parameter. The capacity of the new buffer will be the number
 of bytes given. The returned buffer will be ready to be `read`,
 with its `position` set to `0` and its limit set to the buffer
 `capacity`."
by("Stéphane Épardaud")
see(`class ByteBuffer`,
    `function newByteBuffer`,
    `class Buffer`)
shared ByteBuffer newByteBufferWithData(Byte* bytes){
    value seq = bytes.sequence();
    value buf = newByteBuffer(seq.size);
    for(byte in seq){
        buf.put(byte);
    }
    buf.flip();
    return buf;
}
