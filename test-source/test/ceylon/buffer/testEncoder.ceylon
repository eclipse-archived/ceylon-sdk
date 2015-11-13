import ceylon.buffer.charset {
    ascii,
    Charset,
    iso_8859_1,
    utf8,
    utf16
}
import ceylon.test {
    assertEquals,
    test
}
import ceylon.buffer {
    newByteBuffer,
    newCharacterBufferWithData
}

test void testASCIIEncoder(){
    value encoder = ascii.Encoder();
    value input = newCharacterBufferWithData("asd");
    value output = newByteBuffer(2);
    // decode 2 chars (max output)
    encoder.encode(input, output);
    
    assertEquals(2, input.position);
    assertEquals(2, output.position);
    
    output.flip();
    assertEquals('a'.integer.byte, output.get());
    assertEquals('s'.integer.byte, output.get());
    output.clear();
    
    // decode remaining char
    encoder.encode(input, output);
    assertEquals(3, input.position);
    assertEquals(1, output.position);
    
    output.flip();
    assertEquals('d'.integer.byte, output.get());
}

void testEncoder(Charset charset, String string, Integer* bytes) {
    value encoded = charset.encode(string);
    value sequence = { for (i in bytes) i.byte }.sequence();
    assertEquals(encoded.position, 0, "Position not zero for encoding of ``string``");
    assertEquals(encoded.sequence(), sequence, "Encoding of ``string``");
}

test void testFullASCIIEncoder(){
    testEncoder(ascii, "asd", #61, #73, #64);
}

test void testLatin1Encoder(){
    testEncoder(iso_8859_1, "Stéphane Épardaud", 
                            #53, #74, #E9, #70, #68, #61, #6E, #65, #20,
                            #C9, #70, #61, #72, #64, #61, #75, #64);
}

test void testUTF8Encoder(){
    // samples from http://tools.ietf.org/html/rfc3629
    testEncoder(utf8, "A≢Α.", #41, #E2, #89, #A2, #CE, #91, #2E);
    testEncoder(utf8, "한국어", #ED, #95, #9C, #EA, #B5, #AD, #EC, #96, #B4);
    testEncoder(utf8, "日本語", #E6, #97, #A5, #E6, #9C, #AC, #E8, #AA, #9E);
    testEncoder(utf8, "𣎴", #F0, #A3, #8E, #B4);
    testEncoder(utf8, "𐀀", #f0, #90, #80, #80);
    testEncoder(utf8, "𝄞", #f0, #9d, #84, #9e);
    testEncoder(utf8, "􏿽", #f4, #8f, #bf, #bd);
    testEncoder(utf8, "𐀀z􏿽", #f0, #90, #80, #80, #7a, #f4, #8f, #bf, #bd);
    testEncoder(utf8, "𐀀􏿽􏿽", #f0, #90, #80, #80, #f4, #8f, #bf, #bd, #f4, #8f, #bf, #bd);
    testEncoder(utf8, "z水𐀀𝄞􏿽", #7a, #e6, #b0, #b4, #f0, #90, #80, #80, #f0, #9d, #84, #9e, #f4, #8f, #bf, #bd);
}

test void testUTF16Encoder(){
    // samples from http://en.wikipedia.org/wiki/UTF-16
    testEncoder(utf16, "z水𐀀𝄞􏿽", #00, #7A,
                                    #6C, #34,
                                    #D8, 0, #DC, 0,
                                    #D8, #34, #DD, #1E,
                                    #DB, #FF, #DF, #FD);
}