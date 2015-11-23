import ceylon.buffer {
    Buffer,
    ByteBuffer
}
import ceylon.test {
    test
}

shared class ByteBufferTests() extends BufferTests<Byte>() {
    shared actual Buffer<Byte>(Array<Byte>) bufferOfArray = ByteBuffer.ofArray;
    shared actual Buffer<Byte>({Byte*}) bufferOfData = ByteBuffer;
    shared actual Buffer<Byte>(Integer) bufferOfSize = ByteBuffer.ofSize;
    
    shared actual Array<Byte> zeroSizeSample => Array<Byte> { };
    shared actual Array<Byte> oneSizeSample => Array { 3.byte };
    shared actual Array<Byte> twoSizeSample => Array { 255.byte, 7.byte };
    shared actual Array<Byte> threeSizeSample => Array { 2.byte, 254.byte, 4.byte };
    shared actual Array<Byte> largeSample => Array { for (i in 0:50) i.byte };
}
