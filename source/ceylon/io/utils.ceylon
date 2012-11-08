import ceylon.io.buffer { ByteBuffer, newByteBuffer }

ByteBuffer newBuffer() {
    return newByteBuffer(4096);
}
