import ceylon.test { assertEquals }
import ceylon.io.buffer { newByteBuffer, newByteBufferWithData }
import ceylon.io.charset { Charset, utf8, utf16, iso_8859_1 }

void testDecoder(Charset charset, String expected, Integer* bytes){
    // we put it in a buffer of 2 so we can test multiple calls to decode
    // with 3-4 byte chars split between buffers
    value buf = newByteBuffer(2);
    value iter = bytes.iterator;
    value decoder = charset.newDecoder();
    
    while(true){
        // put as much as fits
        while(buf.hasAvailable){
            if(is Integer byte = iter.next()){
                buf.put(byte);
            }else{
                break;
            }
        }
        if(buf.position == 0){
            break;
        }
        buf.flip();
        decoder.decode(buf);
        buf.clear();
    }
    assertEquals(expected, decoder.done());
    print("Decoded ``expected`` OK");
}

void testLatin1Decoder(){
    testDecoder(iso_8859_1, "Stéphane Épardaud", 
                            #53, #74, #E9, #70, #68, #61, #6E, #65, #20,
                            #C9, #70, #61, #72, #64, #61, #75, #64);
}

void testUTF8Decoder(){
    // samples from http://en.wikipedia.org/wiki/UTF-8
    testDecoder(utf8, "$", #24);
    testDecoder(utf8, "¢", #C2, #A2);
    testDecoder(utf8, "ä", #C3, #A4);
    testDecoder(utf8, "€", #E2, #82, #AC);
    testDecoder(utf8, "𤭢", #F0, #A4, #AD, #A2);

    // samples from http://tools.ietf.org/html/rfc3629
    testDecoder(utf8, "A≢Α.", #41, #E2, #89, #A2, #CE, #91, #2E);
    testDecoder(utf8, "한국어", #ED, #95, #9C, #EA, #B5, #AD, #EC, #96, #B4);
    testDecoder(utf8, "日本語", #E6, #97, #A5, #E6, #9C, #AC, #E8, #AA, #9E);
    testDecoder(utf8, "𣎴", #EF, #BB, #BF, #F0, #A3, #8E, #B4);

    value buffer = newByteBufferWithData(#24, #C2, #A2, #E2, #82, #AC, 
                                         #F0, #A4, #AD, #A2);
    assertEquals("$¢€𤭢", utf8.decode(buffer));
}

void testUTF16Decoder(){
    // samples from http://en.wikipedia.org/wiki/UTF-16
    testDecoder(utf16, "z", #00, #7A);
    testDecoder(utf16, "水", #6C, #34);
    testDecoder(utf16, "𐀀", #D8, 0, #DC, 0);
    testDecoder(utf16, "𝄞", #D8, #34, #DD, #1E);
    testDecoder(utf16, "􏿽", #DB, #FF, #DF, #FD);

    // with BOMs
    testDecoder(utf16, "𝄞", #FE, #FF, #D8, #34, #DD, #1E);
    testDecoder(utf16, "𝄞", #FF, #FE, #34, #D8, #1E, #DD);
}