import ceylon.io.buffer { ByteBuffer, newByteBuffer, newByteBufferWithData }

"Represents a Base64 implementation of RFC 4648
 (the specification)[http://tools.ietf.org/html/rfc4648]."
by "Diego Coronel"
shared object base64 {
    
    "Returns a [[Encoder]] that encodes using the Basic type base64 encoding scheme."
    shared Encoder getEncoder() {
        return Base64Standard();
    }
   
    "Returns a [[Decoder]] that decodes using the Basic type base64 encoding scheme."
    shared Decoder getDecoder() {
        return Base64Standard();
    }
    
    "Returns a [[Encoder]] that encodes using the URL and Filename safe type base64 encoding scheme."
    shared Encoder getUrlEncoder() {
        return Base64Url();
    }
   
    "Returns a [[Decoder]] that decodes using the URL and Filename safe type base64 encoding scheme."
    shared Decoder getUrlDecoder() {
        return Base64Url();
    }
    
}

"Allows you to encode a sequence of bytes into a sequence of 6 bits characters."
by "Diego Coronel"
shared interface Encoder {

    "Encodes all remaining bytes from the specified byte buffer 
     into a newly-allocated ByteBuffer using the Base64 encoding scheme."
    shared formal ByteBuffer encode( ByteBuffer input );
}

"Allows you to decode a group of four 6 bits characters into bytes."
by "Diego Coronel"
shared interface Decoder {

    "Decodes all bytes from the input byte buffer using the Base64 encoding scheme, 
     writing the results into a newly-allocated ByteBuffer."
    shared formal ByteBuffer decode( ByteBuffer input );
}

"Abstract implementations for [[Decoder]] and [[Encoder]]"
abstract class AbstractBase64() satisfies Encoder & Decoder {
 
    "Returns characters table"
    shared formal [Character+] table;

    "Retuns padding character"
    shared Character pad = '=';

    "Retuns index for ignored character"
    Integer ignoreCharIndex = 64;

    shared actual ByteBuffer encode( ByteBuffer input ) {
        //Base64 has an output grow about 33%
        value result = newByteBuffer((2 + input.available - ((input.available + 2) % 3)) * 4 / 3);
        while( input.hasAvailable ){
            Integer remaining = min({3, input.available});
           
             //Get remaining chars
            value raw3 = newByteBufferWithData( for( Integer i in 1..remaining) input.get().integer );
            
            encodeBytesToChars( raw3, result );
        }
        result.flip();
        return result;
    }

    "Transforms a sequence of 3 bytes into 4 characters based on base64 table"
    void encodeBytesToChars( ByteBuffer threeBytes, ByteBuffer encoded ) {
        value codePoint1 = threeBytes.get().integer;
        assert(exists char1 = table[codePoint1.rightLogicalShift(2)]);

        variable value codePoint2 = 0;
        variable value codePoint3 = 0;
        if( threeBytes.capacity == 3 ) {
            codePoint2 = threeBytes.get().integer;
            codePoint3 = threeBytes.get().integer;
        } else if( threeBytes.capacity == 2 ) {
            codePoint2 = threeBytes.get().integer;
        }

        assert(exists char2 = table[((codePoint1.and(3)).leftLogicalShift(4)).or((codePoint2.rightLogicalShift(4)))]);
        assert(exists char3 = table[((codePoint2.and(15)).leftLogicalShift(2)).or(codePoint3.rightLogicalShift(6))]);
        assert(exists char4 = table[codePoint3.and(63)]);

        encoded.put(char1.integer);
        encoded.put(char2.integer);
        encoded.put(threeBytes.capacity >= 2 then char3.integer else pad.integer);
        encoded.put(threeBytes.capacity == 3 then char4.integer else pad.integer);
    }

    "Returns index of an encoded char
     This code is based on base64 tables where just special chars are changed"
    Integer indexOf( Character char ) {
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

    shared actual ByteBuffer decode(ByteBuffer encoded) {
        //Currently theres no implementation that discard padding. 
        //In this case we always have a group of 4 bytes.
        if( encoded.available % 4 != 0 ) {
            throw Exception("Not a valid base64 encode");
        }

        //Estimate output buffer size
        value result = newByteBuffer(encoded.available * 3 / 4);
        while( encoded.hasAvailable ) {
            value char1 = indexOf(encoded.get().character);
            value char2 = indexOf(encoded.get().character);
            value char3 = indexOf(encoded.get().character);
            value char4 = indexOf(encoded.get().character);

            value bits =     char1.leftLogicalShift(18)
                         .or(char2.leftLogicalShift(12))
                         .or(char3.leftLogicalShift(6))
                         .or(char4);

            value byte1 = bits.rightLogicalShift(16).and(#FF);
            value byte2 = bits.rightLogicalShift(8).and(#FF);
            value byte3 = bits.and(#FF);

            result.put(byte1);
            if ( char3 != ignoreCharIndex ) {
                result.put(byte2);
            } if ( char4 != ignoreCharIndex ) {
                result.put(byte3);
            }
        }
        result.flip();
        return result;
    }

}

class Base64Standard() extends AbstractBase64() {
    "The Base64 Basic index table"
    shared actual [Character+] table = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                                        'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
                                        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                        'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                                        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                                        'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                                        'w', 'x', 'y', 'z', '0', '1', '2', '3',
                                        '4', '5', '6', '7', '8', '9', '+', '/'];
}

class Base64Url() extends AbstractBase64() {
    "The Base64 Safe Url index table"
    shared actual [Character+] table = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                                        'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
                                        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                        'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                                        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                                        'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                                        'w', 'x', 'y', 'z', '0', '1', '2', '3',
                                        '4', '5', '6', '7', '8', '9', '-', '_'];
}
