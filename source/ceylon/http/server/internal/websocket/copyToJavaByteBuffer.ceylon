import ceylon.buffer {
    ByteBuffer
}

import java.nio {
    JByteBuffer=ByteBuffer
}

JByteBuffer copyToJavaByteBuffer(ByteBuffer byteBuffer) {
    assert (is JByteBuffer implementation = byteBuffer.implementation);
    return implementation;
}
