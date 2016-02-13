import ceylon.buffer {
    ByteBuffer
}

shared Integer readByteArray(Array<Byte> array, Reader reader) {
    value buffer = ByteBuffer.ofArray(array);
    value result = reader.read(buffer);
    return result;
}
