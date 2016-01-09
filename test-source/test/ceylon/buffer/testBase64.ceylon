import ceylon.buffer.base64 {
    base64ByteStandard {
        encode=encode,
        decode=decode
    }
}
import ceylon.buffer.charset {
    utf8,
    Charset,
    ascii,
    iso_8859_1
}
import ceylon.test {
    assertEquals,
    test
}

test void testBase64WithIso88591(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, iso_8859_1);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, iso_8859_1);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, iso_8859_1);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, iso_8859_1);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, iso_8859_1);
}

test void testBase64WithUtf8(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, utf8);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, utf8);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, utf8);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, utf8);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, utf8);

    input = "A≢Α.";
    expected = "QeKJos6RLg==";
    assertBase64(input, expected, utf8);

    input = "한국어";
    expected = "7ZWc6rWt7Ja0";
    assertBase64(input, expected, utf8);

    input = "日本語";
    expected = "5pel5pys6Kqe";
    assertBase64(input, expected, utf8);
    
    input = "𣎴";
    expected = "8KOOtA==";
    assertBase64(input, expected, utf8);
}

test void testBase64WithAscii(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, ascii);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, ascii);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, ascii);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, ascii);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, ascii);
}

void assertBase64( String input, String expectedEncode, Charset charset) {
    assertEquals{
        expected = expectedEncode; 
        actual = charset.decode(base64ByteStandard.encode(charset.encode(input)));
    };

    value encoded = base64ByteStandard.encode(charset.encode(input));
    assertEquals(input, charset.decode(base64ByteStandard.decode(encoded)));
}
