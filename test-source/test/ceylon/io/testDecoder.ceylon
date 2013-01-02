import ceylon.test { assertEquals }
import ceylon.io.buffer { newByteBuffer, newByteBufferWithData }
import ceylon.io.charset { Charset, utf8, utf16, iso_8859_1 }

void testDecoder(Charset charset, String expected, Integer... bytes){
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
    print("Decoded " expected " OK");
}

void testLatin1Decoder(){
    testDecoder(iso_8859_1, "Stéphane Épardaud", 
                            hex('53'), hex('74'), hex('E9'), hex('70'), hex('68'), hex('61'), hex('6E'), hex('65'), hex('20'),
                            hex('C9'), hex('70'), hex('61'), hex('72'), hex('64'), hex('61'), hex('75'), hex('64'));
}

void testUTF8Decoder(){
    // samples from http://en.wikipedia.org/wiki/UTF-8
    testDecoder(utf8, "$", hex('24'));
    testDecoder(utf8, "¢", hex('C2'), hex('A2'));
    testDecoder(utf8, "ä", hex('C3'), hex('A4'));
    testDecoder(utf8, "€", hex('E2'), hex('82'), hex('AC'));
    testDecoder(utf8, "𤭢", hex('F0'), hex('A4'), hex('AD'), hex('A2'));

    // samples from http://tools.ietf.org/html/rfc3629
    testDecoder(utf8, "A≢Α.", hex('41'), hex('E2'), hex('89'), hex('A2'), hex('CE'), hex('91'), hex('2E'));
    testDecoder(utf8, "한국어", hex('ED'), hex('95'), hex('9C'), hex('EA'), hex('B5'), hex('AD'), hex('EC'), hex('96'), hex('B4'));
    testDecoder(utf8, "日本語", hex('E6'), hex('97'), hex('A5'), hex('E6'), hex('9C'), hex('AC'), hex('E8'), hex('AA'), hex('9E'));
    testDecoder(utf8, "𣎴", hex('EF'), hex('BB'), hex('BF'), hex('F0'), hex('A3'), hex('8E'), hex('B4'));

    value buffer = newByteBufferWithData(hex('24'), hex('C2'), hex('A2'), hex('E2'), hex('82'), hex('AC'), 
                                         hex('F0'), hex('A4'), hex('AD'), hex('A2'));
    assertEquals("$¢€𤭢", utf8.decode(buffer));
}

void testUTF16Decoder(){
    // samples from http://en.wikipedia.org/wiki/UTF-16
    testDecoder(utf16, "z", hex('00'), hex('7A'));
    testDecoder(utf16, "水", hex('6C'), hex('34'));
    testDecoder(utf16, "𐀀", hex('D8'), 0, hex('DC'), 0);
    testDecoder(utf16, "𝄞", hex('D8'), hex('34'), hex('DD'), hex('1E'));
    testDecoder(utf16, "􏿽", hex('DB'), hex('FF'), hex('DF'), hex('FD'));

    // with BOMs
    testDecoder(utf16, "𝄞", hex('FE'), hex('FF'), hex('D8'), hex('34'), hex('DD'), hex('1E'));
    testDecoder(utf16, "𝄞", hex('FF'), hex('FE'), hex('34'), hex('D8'), hex('1E'), hex('DD'));
}