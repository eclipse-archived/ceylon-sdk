import ceylon.io.base64 {
    encode,
    decode,
    encodeMime
}
import ceylon.io.charset {
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
		actual = charset.decode(encode(charset.encode(input)));
	};
	
	value encoded = encode(charset.encode(input));
	assertEquals(input, charset.decode(decode(encoded)));
}


test void testbase64MimeWithAscii(){
			
	variable value input = "Man is distinguished, not only by his reason, but by this";
	variable value expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlz";
	
	assertBase64Mime(input, expected, ascii);
	
	input = "Man is distinguished, not only by his reason, but by this singular pass";
	expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3M=";
	assertBase64Mime(input, expected, ascii);
	
	input = "Man is distinguished, not only by his reason, but by this singular ";
	expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIA==";
	assertBase64Mime(input, expected, ascii);	

	input = "Man is distinguished";
	expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQ=";
	assertBase64Mime(input, expected, ascii);
	
	input = "Man is distinguishe";
	expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZQ==";
	assertBase64Mime(input, expected, ascii);
	
	input = "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of ";
	expected = "TWFuIGlzIGRpc3Rpbmd1aXNoZWQsIG5vdCBvbmx5IGJ5IGhpcyByZWFzb24sIGJ1dCBieSB0aGlzIHNpbmd1bGFyIHBhc3Npb24gZnJvbSBvdGhlciBhbmltYWxzLCB3aGljaCBpcyBhIGx1c3Qgb2Yg";
	assertBase64Mime(input, expected, ascii);
	
	input = "\r\n";
	expected = "DQo=";
	assertBase64Mime(input, expected, ascii);
}


void assertBase64Mime( String input, String expectedEncode, Charset charset) {
	assertEquals{
		expected = expectedEncode; 
		actual = charset.decode(encodeMime(charset.encode(input)));
	};
	
	value encoded = encodeMime(charset.encode(input));
	assertEquals(input, charset.decode(decode(encoded)));
}