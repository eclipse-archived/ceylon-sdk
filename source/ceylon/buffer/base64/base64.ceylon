import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer
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

Map<Character,Byte> toReverseTable([Character+] table) {
    return map { for (i->c in table.indexed) c->i.byte };
}

abstract class PieceDecoderIntraQuantum()
        of second | third | fourth {}
object second extends PieceDecoderIntraQuantum() {}
object third extends PieceDecoderIntraQuantum() {}
object fourth extends PieceDecoderIntraQuantum() {}

shared abstract class Base64String()
        satisfies CharacterToByteCodec {
    "The character table of this base64 variant."
    shared formal [Character+] table;
    
    // Has to be defined by the subtype for laziness, maybe can fix when `once` becomes available
    shared formal Map<Character,Byte> reverseTable;
    
    "The padding character, used where required to terminate discrete blocks of
     encoded data so they may be concatenated without making the seperation
     point ambiguous."
    shared Character pad = '=';
    Byte padCharIndex = 64.byte;
    
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
        CharacterBuffer output = CharacterBuffer.ofSize(3);
        
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
            "Base64 table is invalid. Internal error."
            assert (exists char = table[byte.signed]);
            return char;
        }
        
        shared actual {Character*} more(Byte input) {
            output.clear();
            // Three byte repeating quantum, producing 4 characters of 6-bits each
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum
                    // [rem 67][in 01234567] -> [char [rem 67]0123][rem 4567]
                    value byte = input.rightLogicalShift(4).or(rem.leftLogicalShift(6));
                    remainder = input.and($1111.byte);
                    middle = false;
                    output.put(byteToChar(byte));
                    output.flip();
                    return output;
                } else {
                    // End of quantum
                    // [rem 4567][in 01234567] -> [char [rem 4567]01][char 234567]
                    value byte1 = input.rightLogicalShift(6).or(rem.leftLogicalShift(2));
                    value byte2 = input.and($111111.byte);
                    reset();
                    output.put(byteToChar(byte1));
                    output.put(byteToChar(byte2));
                    output.flip();
                    return output;
                }
            } else {
                // Start of quantum
                // [in 01234567] -> [char 012345][rem 67]
                remainder = input.and($11.byte);
                value byte = input.rightLogicalShift(2);
                output.put(byteToChar(byte));
                output.flip();
                return output;
            }
        }
        
        shared actual {Character*} done() {
            output.clear();
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum (1/4 chars already written)
                    // [rem 67] -> [char [rem 67][pad 0000]] pad pad
                    value byte = rem.leftLogicalShift(6);
                    reset();
                    output.put(byteToChar(byte));
                    output.put(pad);
                    output.put(pad);
                    output.flip();
                    return output;
                } else {
                    // End of quantum (2/4 chars already written)
                    // [rem 4567] -> [char [rem 4567][pad 00]] pad
                    value byte = rem.leftLogicalShift(2);
                    reset();
                    output.put(byteToChar(byte));
                    output.put(pad);
                    output.flip();
                    return output;
                }
            } else {
                // Start of quantum (no chars to write)
                return empty;
            }
        }
    };
    shared actual PieceConvert<Byte,Character> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,Character> {
        ByteBuffer output = ByteBuffer.ofSize(1);
        
        variable PieceDecoderIntraQuantum intraQuantum = second;
        variable Byte? remainder = null;
        variable Boolean padSeen = false;
        
        void reset() {
            intraQuantum = second;
            remainder = null;
            padSeen = false;
        }
        
        Byte? charToByte(Character char, Boolean padPossible = false) {
            if (exists byte = reverseTable.get(char)) {
                return byte;
            } else if (char == pad) {
                // Should only be valid for end
                if (padPossible) {
                    return padCharIndex;
                } else {
                    switch (error)
                    case (strict) {
                        throw DecodeException("Pad character ``char`` is not allowed here");
                    }
                    case (ignore) {
                        return null;
                    }
                }
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
            // similar to encode, but quantum is of 4 (6-bit) Characters instead of 3 Bytes
            // We should always know the next character before returning the current one, as
            // encountering pad char will mean the current is padded.
            output.clear();
            value inputByte = charToByte {
                char = input;
                padPossible = intraQuantum != second;
            };
            if (!exists inputByte) {
                reset();
                return empty;
            }
            // Repeating quantum of four 6-bit characters, producing 3 bytes
            if (exists rem = remainder) {
                switch (intraQuantum)
                case (second) {
                    // Second 6 bits
                    // Now have enough for first output byte, plus some remainder
                    // [rem 012345][in 012345] -> [out [rem 012345][in 01]][rem 2345]
                    value outputByte = rem.leftLogicalShift(2).or(inputByte.rightLogicalShift(4));
                    remainder = inputByte.and($1111.byte);
                    output.put(outputByte);
                    output.flip();
                    intraQuantum = third;
                    return output;
                }
                case (third) {
                    // Third 6 bits, or pad
                    if (inputByte == padCharIndex) {
                        // If we see pad for the third, the fourth must also be pad
                        padSeen = true;
                        // [rem 2345][pad 000000] -> [out [rem 2345][pad 0000]][rem 0000]
                        value outputByte = rem.leftLogicalShift(4);
                        remainder = 0.byte;
                        output.put(outputByte);
                    } else {
                        // [rem 2345][in 012345] -> [out [rem 2345][in 0123]][rem 45]
                        value outputByte = rem.leftLogicalShift(4)
                            .or(inputByte.rightLogicalShift(2));
                        remainder = inputByte.and($11.byte);
                        output.put(outputByte);
                    }
                    
                    intraQuantum = fourth;
                    return output;
                }
                case (fourth) {
                    // Fourth 6 bits, or pad
                    if (inputByte == padCharIndex) {
                        if (padSeen) {
                            reset();
                            return empty;
                        } else {
                            // [rem 45][pad 000000] -> [out [rem 45][pad 0000]]
                            value outputByte = rem.leftLogicalShift(6);
                            output.put(outputByte);
                        }
                    } else {
                        if (padSeen) {
                            switch (error)
                            case (strict) {
                                throw DecodeException {
                                    "Non-pad character ``input`` is not allowed here";
                                };
                            }
                            case (ignore) {
                                reset();
                                return empty;
                            }
                        } else {
                            // [rem 45][in 012345] -> [out [rem 45][in 012345]]
                            value outputByte = rem.leftLogicalShift(6).or(inputByte);
                            output.put(outputByte);
                        }
                    }
                    output.flip();
                    reset();
                    return output;
                }
            } else {
                // First 6 bits
                // Don't have enough to construct 8 bits yet, put entire input into remainder
                remainder = inputByte;
                return empty;
            }
        }
        
        shared actual {Byte*} done() {
            output.clear();
            // Handle none/partial lack of padding characters to terminate input
            // Pad termination is technically optional for otherwise discrete base64 strings
            if (exists rem = remainder) {
                switch (intraQuantum)
                case (second) {
                    // A base64 string cannot terminate on the second part of a quantum
                    switch (error)
                    case (strict) {
                        throw DecodeException("Missing one input piece");
                    }
                    case (ignore) {
                        reset();
                        return empty;
                    }
                }
                case (third) {
                    // [rem 2345][pad 000000] -> [out [rem 2345][pad 0000]]
                    value outputByte = rem.leftLogicalShift(4);
                    output.put(outputByte);
                }
                case (fourth) {
                    // [rem 45][pad 000000] -> [out [rem 45][pad 0000]]
                    value outputByte = rem.leftLogicalShift(6);
                    output.put(outputByte);
                }
            } else {
                // Nothing to do. Finished before at an inter-quantum boundary.
            }
            output.flip();
            reset();
            return output;
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
