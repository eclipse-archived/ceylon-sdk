import ceylon.buffer {
    Buffer,
    ByteBuffer
}
import ceylon.test {
    test,
    assertEquals
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
    
    test
    shared void ofArray() {
        value b1 = ByteBuffer.ofArray(Array { 3.byte });
        value b2 = ByteBuffer.ofArray(Array { 4.byte });
        assertEquals(b1.get(), 3.byte);
        assertEquals(b2.get(), 4.byte);
        assertEquals(b1, b2);
    }
}


shared void asd() {
    print(ByteBuffer.ofArray(Array { 0.byte }));
}