import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    Buffer
}
import ceylon.test {
    assertEquals,
    test
}

void testBuffer<Element>(Buffer<Element> buffer, Element[] values) {
    // check initial state
    assertEquals(4, buffer.capacity);
    assertEquals(4, buffer.limit);
    assertEquals(4, buffer.available);
    assertEquals(0, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    variable Integer position = 0;
    // put four bytes
    for (Element val in values) {
        buffer.put(val);
        position++;
        assertEquals(4, buffer.capacity);
        assertEquals(4, buffer.limit);
        assertEquals(values.size - position, buffer.available);
        assertEquals(position, buffer.position);
        assertEquals(position < values.size, buffer.hasAvailable);
    }
    
    // flip it
    buffer.flip();
    assertEquals(4, buffer.capacity);
    assertEquals(4, buffer.limit);
    assertEquals(4, buffer.available);
    assertEquals(0, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    // now check the results
    position = 0;
    for (Element val in values) {
        assertEquals(val, buffer.get());
        position++;
        assertEquals(4, buffer.capacity);
        assertEquals(4, buffer.limit);
        assertEquals(values.size - position, buffer.available);
        assertEquals(position, buffer.position);
        assertEquals(position < values.size, buffer.hasAvailable);
    }
    
    // clear it
    buffer.clear();
    assertEquals(4, buffer.capacity);
    assertEquals(4, buffer.limit);
    assertEquals(4, buffer.available);
    assertEquals(0, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    // get two and flip
    assertEquals(0, buffer.position);
    buffer.get();
    assertEquals(1, buffer.position);
    buffer.get();
    assertEquals(2, buffer.position);
    buffer.flip();
    
    assertEquals(4, buffer.capacity);
    assertEquals(2, buffer.limit);
    assertEquals(2, buffer.available);
    // make sure size uses available and does not consume bytes
    assertEquals(2, buffer.size);
    assertEquals(2, buffer.available);
    assertEquals(0, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    // FIXME: check exceptions
}

test
void testByteBuffer() {
    Byte[] values = [1, 200, 200, 200]*.byte;
    ByteBuffer ofSizeBuffer = ByteBuffer.ofSize(4);
    testBuffer(ofSizeBuffer, values);
    ByteBuffer ofArrayBuffer = ByteBuffer.ofArray(Array.ofSize(4, 0.byte));
    testBuffer(ofArrayBuffer, values);
    ByteBuffer ofDataBuffer = ByteBuffer({ 0.byte }.repeat(4));
    testBuffer(ofDataBuffer, values);
}

test
void testByteBufferResize() {
    ByteBuffer buffer = ByteBuffer.ofSize(4);
    Byte[] values = [1, 2, 3, 4]*.byte;
    for (val in values) {
        buffer.put(val);
    }
    
    // flip it and eat a byte to get to position 1 
    buffer.flip();
    buffer.get();
    assertEquals(1, buffer.position);
    
    // check initial state
    assertEquals(4, buffer.capacity);
    assertEquals(4, buffer.limit);
    assertEquals(3, buffer.available);
    assertEquals(1, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    // expand
    buffer.resize(6);
    // check expanded state
    assertEquals(6, buffer.capacity);
    assertEquals(4, buffer.limit);
    assertEquals(3, buffer.available);
    assertEquals(1, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    assertEquals(2.byte, buffer.get());
    assertEquals(3.byte, buffer.get());
    assertEquals(4.byte, buffer.get());
    
    // flip it and eat a byte to get to position 1 
    buffer.flip();
    buffer.get();
    assertEquals(1, buffer.position);
    
    // shrink
    buffer.resize(2);
    // check reduced state
    assertEquals(2, buffer.capacity);
    assertEquals(2, buffer.limit);
    assertEquals(1, buffer.available);
    assertEquals(1, buffer.position);
    assertEquals(true, buffer.hasAvailable);
    
    assertEquals(2.byte, buffer.get());
}

test
void testCharacterBuffer() {
    CharacterBuffer buffer = CharacterBuffer("abcd");
    Character[] values = ['a', 'b', 'c', 'd'];
    testBuffer(buffer, values);
}
