import ceylon.io.buffer {
    ByteBuffer,
    newByteBuffer
}

ByteBuffer newBuffer() => newByteBuffer(4096);
