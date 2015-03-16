import ceylon.io.buffer {
    newByteBufferWithData
}
import ceylon.io.charset {
    utf8
}

class CloseReasonAdapter({Byte*} bytes) { //TODO write test
    shared Integer code;
    shared String reason;
    
    if (bytes.size >= 2) {
        value byteIterator = bytes.iterator();
        value byte2 = byteIterator.next();
        value byte1 = byteIterator.next();
        assert (is Byte byte1);
        assert (is Byte byte2);
        code = (byte2.leftLogicalShift(8) + (byte1.and( Byte(255) ))).unsigned;
        if (bytes.size > 2) {
            reason = utf8.decode(newByteBufferWithData(*bytes.skip(2)));
        } else {
            reason = "";
        }
    } else {
        code = 0;
        reason = "";
    }
}

