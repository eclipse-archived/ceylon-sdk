import com.redhat.ceylon.sdk.test { assertEquals }
import ceylon.io.charset { ascii, Encoder }
import ceylon.io.buffer { newCharacterBufferWithData, newByteBuffer }

void testASCIIEncoder(){
    Encoder encoder = ascii.newEncoder();
    value input = newCharacterBufferWithData("asd");
    value output = newByteBuffer(2);
    // decode 2 chars (max output)
    encoder.encode(input, output);
    
    assertEquals(2, input.position);
    assertEquals(2, output.position);
    
    output.flip();
    assertEquals(`a`.integer, output.get());
    assertEquals(`s`.integer, output.get());
    output.clear();
    
    // decode remaining char
    encoder.encode(input, output);
    assertEquals(3, input.position);
    assertEquals(1, output.position);
    
    output.flip();
    assertEquals(`d`.integer, output.get());
}

void testFullASCIIEncoder(){
    value encoded = ascii.encode("asd");
    assertEquals(0, encoded.position);
    assertEquals(3, encoded.limit);
    assertEquals(`a`.integer, encoded.get());
    assertEquals(`s`.integer, encoded.get());
    assertEquals(`d`.integer, encoded.get());
}