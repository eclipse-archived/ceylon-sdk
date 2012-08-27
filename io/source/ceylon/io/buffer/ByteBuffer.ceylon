import ceylon.io.buffer.impl { ByteBufferImpl }

shared abstract class ByteBuffer() extends Buffer<Integer>(){
}

shared ByteBuffer newByteBuffer(Integer capacity){
    return ByteBufferImpl(capacity);
}

shared ByteBuffer newByteBufferWithData(Integer... bytes){
    value seq = bytes.sequence;
    value buf = newByteBuffer(seq.size);
    for(Integer byte in seq){
        buf.put(byte);
    }
    buf.flip();
    return buf;
}
