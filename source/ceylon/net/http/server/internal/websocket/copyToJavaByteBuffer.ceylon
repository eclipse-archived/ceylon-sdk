import ceylon.buffer {
    ByteBuffer
}

import java.lang {
    ByteArray
}
import java.nio {
    JByteBuffer=ByteBuffer {
        wrapByteBuffer=wrap
    }
}

JByteBuffer copyToJavaByteBuffer(ByteBuffer byteBuffer) {
    byteBuffer.resize(byteBuffer.limit); //strip trailing nulls
    value array = ByteArray(byteBuffer.limit);
    for (i in 0:byteBuffer.limit) {
        array.set(i, byteBuffer.getByte());
    }
    return wrapByteBuffer(array);
}
