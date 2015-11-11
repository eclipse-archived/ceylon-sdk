import ceylon.buffer {
    newByteBuffer,
    ByteBuffer
}

ByteBuffer newBuffer() => newByteBuffer(4096);
