import ceylon.io.buffer.impl { ByteBufferImpl }

"Represents a buffer of bytes (from 0 to 255 inclusive, unsigned).
 
 You can create new instances with [[newByteBuffer]] (empty) and
 [[newByteBufferWithData]] (filled with your data)."
by("Stéphane Épardaud")
see(`Buffer`,`newByteBuffer`,`newByteBufferWithData`)
shared abstract class ByteBuffer() extends Buffer<Integer>(){
	shared formal Array<Integer> bytes();
}

"Allocates a new empty [[ByteBuffer]] of the given [[capacity]]."
by("Stéphane Épardaud")
see(`ByteBuffer`,`newByteBufferWithData`,`Buffer`)
shared ByteBuffer newByteBuffer(Integer capacity){
    return ByteBufferImpl(capacity);
}

"Allocates a new [[ByteBuffer]] filled with the [[bytes]] given
 as parameter. The capacity of the new buffer will be the number
 of bytes given. The returned buffer will be ready to be `read`,
 with its `position` set to `0` and its limit set to the buffer
 `capacity`."
by("Stéphane Épardaud")
see(`ByteBuffer`,`newByteBuffer`,`Buffer`)
shared ByteBuffer newByteBufferWithData(Integer* bytes){
    value seq = bytes.sequence;
    value buf = newByteBuffer(seq.size);
    for(Integer byte in seq){
        buf.put(byte);
    }
    buf.flip();
    return buf;
}
