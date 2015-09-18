
import java.nio {
    JByteBuffer=ByteBuffer
}
import ceylon.io.buffer {
    newByteBuffer,
    ByteBuffer,
    newByteBufferWithData
}
import java.lang {
    ByteArray
}

by("Matej Lazar")

shared ByteBuffer toCeylonByteBuffer(JByteBuffer? jByteBuffer) {
    if (exists jbb = jByteBuffer) {
        value byteArray = ByteArray(jbb.remaining()); 
        jbb.get(byteArray);
        ByteBuffer bb = newByteBufferWithData(*byteArray.byteArray);
        return bb;
    } else {
        return newByteBuffer(0); 
    }
}

shared ByteBuffer mergeBuffers(ByteBuffer* payload) {
    variable Integer payloadSize = 0;
    for (ByteBuffer bb in payload) {
        payloadSize = payloadSize + bb.available;
    }
    
    ByteBuffer buffer = newByteBuffer(payloadSize);
    if (payloadSize == 0) {
        return buffer;
    }
    
    for (ByteBuffer bb in payload) {
        addBytes(buffer, bb);
    }
    buffer.flip();
    return buffer;
}

void addBytes(ByteBuffer toBuffer, ByteBuffer fromBuffer) {
    while (fromBuffer.hasAvailable) {
        toBuffer.putByte(fromBuffer.getByte());
    }
}
