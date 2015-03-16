import java.nio {
    JByteBuffer=ByteBuffer
}
import java.lang {
    ByteArray
}

shared {Byte*} toBytes(JByteBuffer[] jByteBufferArray) => 
     jByteBufferArray.flatMap((JByteBuffer element) => collectBytes(element));

{Byte*} collectBytes(JByteBuffer jByteBuffer) {
    ByteArray array = ByteArray(jByteBuffer.remaining()); //TODO can we do without new array?
    jByteBuffer.get(array);
    return array.iterable;
}

