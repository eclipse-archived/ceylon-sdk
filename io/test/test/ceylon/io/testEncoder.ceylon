import com.redhat.ceylon.sdk.test { assertEquals }
import ceylon.io.charset { ascii, Encoder, Charset, iso_8859_1, utf8 }
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

void testEncoder(Charset charset, String string, Integer... bytes){
    value encoded = charset.encode(string);
    value sequence = bytes.sequence;
    assertEquals(0, encoded.position);
    assertEquals(sequence.size, encoded.limit);
    for(Integer byte in sequence){
        assertEquals(byte, encoded.get());
    }
    print("Encoded " string " OK");
}

void testFullASCIIEncoder(){
    testEncoder(ascii, "asd", hex('61'), hex('73'), hex('64'));
}

void testLatin1Encoder(){
    testEncoder(iso_8859_1, "Stéphane Épardaud", 
                            hex('53'), hex('74'), hex('E9'), hex('70'), hex('68'), hex('61'), hex('6E'), hex('65'), hex('20'),
                            hex('C9'), hex('70'), hex('61'), hex('72'), hex('64'), hex('61'), hex('75'), hex('64'));
}

void testUTF8Encoder(){
    // samples from http://tools.ietf.org/html/rfc3629
    testEncoder(utf8, "A≢Α.", hex('41'), hex('E2'), hex('89'), hex('A2'), hex('CE'), hex('91'), hex('2E'));
    testEncoder(utf8, "한국어", hex('ED'), hex('95'), hex('9C'), hex('EA'), hex('B5'), hex('AD'), hex('EC'), hex('96'), hex('B4'));
    testEncoder(utf8, "日本語", hex('E6'), hex('97'), hex('A5'), hex('E6'), hex('9C'), hex('AC'), hex('E8'), hex('AA'), hex('9E'));
    testEncoder(utf8, "𣎴", hex('F0'), hex('A3'), hex('8E'), hex('B4'));
}