import java.nio { JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import java.lang { arrays }
import ceylon.io.buffer { ByteBuffer }

shared JByteBuffer toJavaByteBuffer(ByteBuffer byteBuffer) {
    byteBuffer.resize(byteBuffer.limit); //strip trailing nulls
    return wrapByteBuffer(arrays.toByteArray(byteBuffer.bytes()));
}
