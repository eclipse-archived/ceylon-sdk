import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.codec {
    ByteToByteCodec,
    ErrorStrategy,
    PieceConvert,
    CharacterToByteCodec,
    strict,
    ignore,
    DecodeException
}

shared abstract class Base64Byte()
        satisfies ByteToByteCodec {
    // TODO direct to ascii byte encoding, since b64 charset is within ascii and usually needs to be written out
    "The character table of this variant"
    shared formal [Byte+] table;
}

Map<Character,Integer> toReverseTable([Character+] table) {
    return map { for (i->c in table.indexed) c->i };
}

shared abstract class Base64String()
        satisfies CharacterToByteCodec {
    "The character table of this base64 variant."
    shared formal [Character+] table;
    
    shared formal Map<Character,Integer> reverseTable;
    
    "The padding character, used where required to terminate discrete blocks of
     encoded data so they may be concatenated without making the seperation
     point ambiguous."
    shared Character pad = '=';
    
    shared actual Integer averageEncodeSize(Integer inputSize)
            => (2 + inputSize - ((inputSize + 2) % 3)) * 4 / 3;
    shared actual Integer maximumEncodeSize(Integer inputSize)
            => averageEncodeSize(inputSize);
    shared actual Integer averageDecodeSize(Integer inputSize)
            => inputSize * 3 / 4;
    shared actual Integer maximumDecodeSize(Integer inputSize)
            => averageDecodeSize(inputSize);
    
    shared actual Integer encodeBid({Byte*} sample) => 1;
    shared actual Integer decodeBid({Character*} sample) {
        if (sample.every((char) => char==pad || char in table)) {
            return 100;
        } else {
            return 0;
        }
    }
    
    shared actual PieceConvert<Character,Byte> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Byte> {
        variable Boolean middle = true;
        variable Byte? remainder = null;
        
        void reset() {
            middle = true;
            remainder = null;
        }
        
        Character byteToChar(Byte byte) {
            // Not using ErrorStrategy / EncodeException here since if this
            // doesn't succeed the implementation is wrong. All input bytes are
            // valid.
            "Base64 implementation invalid. Internal error."
            assert (exists char = table[byte.signed]);
            return char;
        }
        
        shared actual {Character*} more(Byte input) {
            // Three byte repeating quantum
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum
                    // [rem 67][in 01234567] -> [char [rem 67]0123][rem 4567]
                    value byte = input.rightLogicalShift(4).or(rem.leftLogicalShift(6));
                    remainder = input.and($1111.byte);
                    middle = false;
                    return { byteToChar(byte) };
                } else {
                    // End of quantum
                    // [rem 4567][in 01234567] -> [char [rem 4567]01][char 234567]
                    value byte1 = input.rightLogicalShift(6).or(rem.leftLogicalShift(2));
                    value byte2 = input.and($111111.byte);
                    reset();
                    return { byteToChar(byte1), byteToChar(byte2) };
                }
            } else {
                // Start of quantum
                // [in 01234567] -> [char 012345][rem 67]
                remainder = input.and($11.byte);
                return { byteToChar(input.rightLogicalShift(2)) };
            }
        }
        
        shared actual {Character*} done() {
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum (1/4 chars already written)
                    // [rem 67] -> [char [rem 67][pad 0000]] pad pad
                    value byte = rem.leftLogicalShift(6);
                    reset();
                    return { byteToChar(byte), pad, pad };
                } else {
                    // End of quantum (2/4 chars already written)
                    // [rem 4567] -> [char [rem 4567][pad 00]] pad
                    value byte = rem.leftLogicalShift(2);
                    reset();
                    return { byteToChar(byte), pad };
                }
            } else {
                // Start of quantum (no chars to write)
                return empty;
            }
        }
    };
    shared actual PieceConvert<Byte,Character> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,Character> {
        
        Byte? charToByte(Character char) {
            if (exists byte = reverseTable.get(char)) {
                
                return byte;
            } else if (char == pad) {
                // Should only be valid for end
                return null;
            } else {
                switch (error)
                case (strict) {
                    throw DecodeException("``char`` is not a base64 Character");
                }
                case (ignore) {
                    return null;
                }
            }
        }
        
        shared actual {Byte*} more(Character input) {
            return nothing;
        }
    };
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
        while (input.hasAvailable) {
            encodeBytesToChars(input, result);
        }
        result.flip();
        return result;
    }
    
    "Transforms a sequence of 3 bytes into 4 characters 
     based on base64 table"
    void encodeBytesToChars(ByteBuffer input, ByteBuffer encoded) {
        value available = input.available;
        value codePoint1 = input.get();
        assert (exists char1
                    = table[codePoint1.rightLogicalShift(2).signed]);
        
        variable value codePoint2 = 0.byte;
        variable value codePoint3 = 0.byte;
        if (available >= 3) {
            codePoint2 = input.get();
            codePoint3 = input.get();
        } else if (available == 2) {
            codePoint2 = input.get();
        }
        
        assert (exists char2 = table[((codePoint1.and(3.byte)).leftLogicalShift(4)).or((codePoint2.rightLogicalShift(4))).signed]);
        assert (exists char3 = table[((codePoint2.and(15.byte)).leftLogicalShift(2)).or(codePoint3.rightLogicalShift(6)).signed]);
        assert (exists char4 = table[codePoint3.and(63.byte).signed]);
        
        encoded.putByte(char1.integer.byte);
        encoded.putByte(char2.integer.byte);
        encoded.putByte(available >= 2 then char3.integer.byte else pad.integer.byte);
        encoded.putByte(available >= 3 then char4.integer.byte else pad.integer.byte);
    }
    
    "Returns index of an encoded character. This code is 
     based on base64 tables where just special chars are 
     changed"
    Integer indexOf(Character char) {
        if ('A'.integer <= char.integer <= 'Z'.integer) {
            return char.integer - 'A'.integer;
        }
        
        if ('a'.integer <= char.integer <= 'z'.integer) {
            return char.integer - 'a'.integer + 26;
        }
        
        if ('0'.integer <= char.integer <= '9'.integer) {
            return char.integer - '0'.integer + 52;
        }
        
        if ('+'.integer==char.integer || '-'.integer==char.integer) {
            return 62;
        }
        
        if ('/'.integer==char.integer || '_'.integer==char.integer) {
            return 63;
        }
        
        //If pad we need an index to know when to discard 
        if (char == pad) {
            return ignoreCharIndex;
        }
        throw Exception("Bad character found: '``char``' ");
    }
    
    shared ByteBuffer decode(ByteBuffer encoded) {
        //Currently theres no implementation that discard padding. 
        //In this case we always have a group of 4 bytes.
        if (encoded.available%4 != 0) {
            throw Exception("Not a valid base64 encode");
        }
        
        //Estimate output buffer size
        value result = newByteBuffer(encoded.available * 3 / 4);
        while (encoded.hasAvailable) {
            value char1 = indexOf(encoded.get().signed.character);
            value char2 = indexOf(encoded.get().signed.character);
            value char3 = indexOf(encoded.get().signed.character);
            value char4 = indexOf(encoded.get().signed.character);
            
            value bits = char1.leftLogicalShift(18)
                .or(char2.leftLogicalShift(12))
                .or(char3.leftLogicalShift(6))
                .or(char4);
            
            value byte1 = bits.rightLogicalShift(16).and(#FF).byte;
            value byte2 = bits.rightLogicalShift(8).and(#FF).byte;
            value byte3 = bits.and(#FF).byte;
            
            result.putByte(byte1);
            if (char3 != ignoreCharIndex) {
                result.putByte(byte2);
            }
            if (char4 != ignoreCharIndex) {
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
