import java.nio {
    JByteBuffer=ByteBuffer
}
import java.lang {
    ByteArray
}

shared {Byte*} toBytes(JByteBuffer[] jByteBufferArray) => 
     jByteBufferArray.flatMap((JByteBuffer element) => collectBytes(element));

{Byte*} collectBytes(JByteBuffer jByteBuffer) {
    return jByteBuffer.array().iterable;
}

