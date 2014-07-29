import ceylon.interop.java {
    javaByteArray
}
import ceylon.io.buffer {
    ByteBuffer
}

import java.nio {
    JByteBuffer=ByteBuffer {
        wrapByteBuffer=wrap
    }
}

shared JByteBuffer createJavaByteBuffer(ByteBuffer byteBuffer) {
    byteBuffer.resize(byteBuffer.limit); //strip trailing nulls
    return wrapByteBuffer(javaByteArray(byteBuffer.bytes()));
}
