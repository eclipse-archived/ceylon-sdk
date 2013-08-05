import java.nio { JByteBuffer = ByteBuffer }
import java.lang { arrays }
import ceylon.io.buffer { ByteBuffer }
import ceylon.net.http.server.internal {JavaHelper {wrapByteBuffer}}

shared JByteBuffer toJavaByteBuffer(ByteBuffer byteBuffer) {
    byteBuffer.resize(byteBuffer.limit); //strip trailing nulls
    return wrapByteBuffer(arrays.toByteArray(byteBuffer.bytes()));
}
