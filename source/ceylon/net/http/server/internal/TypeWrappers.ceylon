import java.nio { JByteBuffer=ByteBuffer { wrapByteBuffer=wrap }}
import java.lang { ByteArray }
import ceylon.io.buffer { ByteBuffer }
import ceylon.interop.java { javaByteArray }

shared ByteArray toByteArray(Array<Byte> bufferBytes) {
    value bytes = javaByteArray(bufferBytes);
    value byteArray = ByteArray(bytes.size);
    variable value i=0;
    while (i<bytes.size) {
        byteArray.set(i,bytes.get(i));
        i++;
    }
    return byteArray;
}

shared JByteBuffer toJavaByteBuffer(ByteBuffer byteBuffer) {
    byteBuffer.resize(byteBuffer.limit); //strip trailing nulls
    //TODO: this is super-crappy, since the bytes started 
    //      out as a byte[]
    return wrapByteBuffer(toByteArray(byteBuffer.bytes()));
}
