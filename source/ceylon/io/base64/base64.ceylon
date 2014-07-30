import ceylon.io.buffer {
    ByteBuffer,
    newByteBuffer
}

"Encode the given [[input]] using the Basic type base64 
 encoding scheme of [RFC 4648][rfc4648].
 
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared ByteBuffer encode(ByteBuffer input) 
        => base64Standard.encode(input);

"Decode the given [[input]] using the Basic type base64 
 encoding scheme of [RFC 4648][rfc4648].
 
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared ByteBuffer decode(ByteBuffer input) 
        => base64Standard.decode(input);

"Encode the given [[url]] using the URL and Filename 
 safe type base64 encoding scheme of [RFC 4648][rfc4648].
 
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared ByteBuffer encodeUrl(ByteBuffer url) 
        => base64Url.encode(url);

"Decode the given [[url]] using the URL and Filename 
 safe type base64 encoding scheme of [RFC 4648][rfc4648].
 
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared ByteBuffer decodeUrl(ByteBuffer url) 
        => base64Url.decode(url);

abstract class AbstractBase64() {
 
    "Returns characters table"
    shared formal [Character+] table;

    "Returns padding character"
    shared Character pad = '=';

    "Returns index for ignored character"
    Integer ignoreCharIndex = 64;

    shared ByteBuffer encode(ByteBuffer input) {
        //Base64 has an output grow about 33%
        value result = newByteBuffer((2 + input.available - ((input.available + 2) % 3)) * 4 / 3);
        while( input.hasAvailable ) {
            encodeBytesToChars( input, result );
        }
        result.flip();
        return result;
    }

    "Transforms a sequence of 3 bytes into 4 characters 
     based on base64 table"
    void encodeBytesToChars(ByteBuffer input, ByteBuffer encoded) {
        value available = input.available;
        value codePoint1 = input.get();
        assert(exists char1 
            = table[codePoint1.rightLogicalShift(2).signed]);

        variable value codePoint2 = 0.byte;
        variable value codePoint3 = 0.byte;
        if( available >= 3 ) {
            codePoint2 = input.get();
            codePoint3 = input.get();
        } else if( available == 2 ) {
            codePoint2 = input.get();
        }

        assert(exists char2 = table[((codePoint1.and(3.byte)).leftLogicalShift(4)).or((codePoint2.rightLogicalShift(4))).signed]);
        assert(exists char3 = table[((codePoint2.and(15.byte)).leftLogicalShift(2)).or(codePoint3.rightLogicalShift(6)).signed]);
        assert(exists char4 = table[codePoint3.and(63.byte).signed]);

        encoded.putByte(char1.integer.byte);
        encoded.putByte(char2.integer.byte);
        encoded.putByte(available >= 2 then char3.integer.byte else pad.integer.byte);
        encoded.putByte(available >= 3 then char4.integer.byte else pad.integer.byte);
    }

    "Returns index of an encoded character. This code is 
     based on base64 tables where just special chars are 
     changed"
    Integer indexOf(Character char) {
        if( 'A'.integer <= char.integer <= 'Z'.integer ) {
            return char.integer - 'A'.integer;
        }

        if( 'a'.integer <= char.integer <= 'z'.integer ) {
            return char.integer - 'a'.integer + 26;
        }

        if( '0'.integer <= char.integer <= '9'.integer ) {
            return char.integer - '0'.integer + 52;
        }

        if ( '+'.integer == char.integer || '-'.integer == char.integer ) {
            return 62;
        }

        if ( '/'.integer == char.integer || '_'.integer == char.integer ) {
            return 63;
        }

        //If pad we need an index to know when to discard 
        if ( char == pad ) {
            return ignoreCharIndex;
        }
        throw Exception("Bad character found: '``char``' ");
    }

    shared ByteBuffer decode(ByteBuffer encoded) {
        //Currently theres no implementation that discard padding. 
        //In this case we always have a group of 4 bytes.
        if( encoded.available % 4 != 0 ) {
            throw Exception("Not a valid base64 encode");
        }

        //Estimate output buffer size
        value result = newByteBuffer(encoded.available * 3 / 4);
        while( encoded.hasAvailable ) {
            value char1 = indexOf(encoded.get().signed.character);
            value char2 = indexOf(encoded.get().signed.character);
            value char3 = indexOf(encoded.get().signed.character);
            value char4 = indexOf(encoded.get().signed.character);

            value bits =     char1.leftLogicalShift(18)
                         .or(char2.leftLogicalShift(12))
                         .or(char3.leftLogicalShift(6))
                         .or(char4);

            value byte1 = bits.rightLogicalShift(16).and(#FF).byte;
            value byte2 = bits.rightLogicalShift(8).and(#FF).byte;
            value byte3 = bits.and(#FF).byte;

            result.putByte(byte1);
            if ( char3 != ignoreCharIndex ) {
                result.putByte(byte2);
            } if ( char4 != ignoreCharIndex ) {
                result.putByte(byte3);
            }
        }
        result.flip();
        return result;
    }

}

object base64Standard 
        extends AbstractBase64() {
    table = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
             'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
             'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
             'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
             'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
             'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
             'w', 'x', 'y', 'z', '0', '1', '2', '3',
             '4', '5', '6', '7', '8', '9', '+', '/'];
}

object base64Url 
        extends AbstractBase64() {
    table = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
             'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
             'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
             'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
             'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
             'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
             'w', 'x', 'y', 'z', '0', '1', '2', '3',
             '4', '5', '6', '7', '8', '9', '-', '_'];
}
