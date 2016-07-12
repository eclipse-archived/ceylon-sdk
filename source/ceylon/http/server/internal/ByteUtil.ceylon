
import ceylon.buffer {
    ByteBuffer
}
import ceylon.interop.java {
    toByteArray
}

import java.nio {
    JByteBuffer=ByteBuffer
}

by("Matej Lazar")

shared ByteBuffer toCeylonByteBuffer(JByteBuffer? jByteBuffer) {
    if (exists jbb = jByteBuffer) {
        Array<Byte> cba;
        if (jbb.hasArray()) {
            cba = toByteArray(jbb.array());
        } else {
            cba = Array<Byte>.ofSize(jbb.limit(), 0.byte);
            for (ii in 0: jbb.limit()) {
                cba.set(ii, jbb.get(ii));
            }
        }
        ByteBuffer bb = ByteBuffer.ofArray(cba);
        return bb;
    } else {
        return ByteBuffer.ofSize(0);
    }
}

shared ByteBuffer mergeBuffers({ByteBuffer*} payload) {
    variable Integer payloadSize = 0;
    for (ByteBuffer bb in payload) {
        payloadSize = payloadSize + bb.available;
    }
    
    ByteBuffer buffer = ByteBuffer.ofSize(payloadSize);
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
        toBuffer.put(fromBuffer.get());
    }
}
