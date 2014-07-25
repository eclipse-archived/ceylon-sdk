import ceylon.io.charset { utf8, Charset, ascii, iso_8859_1 }
import ceylon.io { base64, Encoder, Decoder }
import ceylon.test { assertEquals, test }

test void testBase64WithIso88591(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, iso_8859_1);
    assertBase64Helper(input, expected, iso_8859_1);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, iso_8859_1);
    assertBase64Helper(input, expected, iso_8859_1);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, iso_8859_1);
    assertBase64Helper(input, expected, iso_8859_1);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, iso_8859_1);
    assertBase64Helper(input, expected, iso_8859_1);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, iso_8859_1);
    assertBase64Helper(input, expected, iso_8859_1);

	


}

test void testBase64WithUtf8(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "A≢Α.";
    expected = "QeKJos6RLg==";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "한국어";
    expected = "7ZWc6rWt7Ja0";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);

    input = "日本語";
    expected = "5pel5pys6Kqe";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);
    
    input = "𣎴";
    expected = "8KOOtA==";
    assertBase64(input, expected, utf8);
    assertBase64Helper(input, expected, utf8);
}

test void testBase64WithAscii(){
    //Some texts from wikipedia
    variable value input = "any carnal pleasure.";
    variable value expected = "YW55IGNhcm5hbCBwbGVhc3VyZS4=";
    assertBase64(input, expected, ascii);
    assertBase64Helper(input, expected, ascii);

    input = "any carnal pleasure";
    expected = "YW55IGNhcm5hbCBwbGVhc3VyZQ==";
    assertBase64(input, expected, ascii);
    assertBase64Helper(input, expected, ascii);

    input = "any carnal pleasur";
    expected = "YW55IGNhcm5hbCBwbGVhc3Vy";
    assertBase64(input, expected, ascii);
    assertBase64Helper(input, expected, ascii);

    input = "any carnal pleasu";
    expected = "YW55IGNhcm5hbCBwbGVhc3U=";
    assertBase64(input, expected, ascii);
    assertBase64Helper(input, expected, ascii);

    input = "any carnal pleas";
    expected = "YW55IGNhcm5hbCBwbGVhcw==";
    assertBase64(input, expected, ascii);
    assertBase64Helper(input, expected, ascii);
}

void assertBase64( String input, String expectedEncode, Charset charset, Encoder encoder = base64.getEncoder(), Decoder decoder = base64.getDecoder() ) {
    assertEquals{
        expected = expectedEncode; 
        actual = charset.decode(encoder.encode(charset.encode(input)));
    };

    value encoded = encoder.encode(charset.encode(input));
    assertEquals(input, charset.decode(decoder.decode(encoded)));
	

}

void assertBase64Helper( String input, String expectedEncode, Charset charset) {
	assertEquals{
		expected = expectedEncode; 
		actual = base64.encode(input , charset);
	};
	
	value encoded =base64.encode(input,charset);
	assertEquals(input, base64.decode(encoded , charset));
	
	
}
