import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    Buffer
}
import ceylon.buffer.codec {
    ByteToByteCodec,
    ErrorStrategy,
    PieceConvert,
    CharacterToByteCodec,
    strict,
    ignore,
    DecodeException,
    IncrementalCodec,
    resetStrategy=reset
}

abstract class PieceDecoderIntraQuantum()
        of second | third | fourth {}
object second extends PieceDecoderIntraQuantum() {}
object third extends PieceDecoderIntraQuantum() {}
object fourth extends PieceDecoderIntraQuantum() {}

shared sealed abstract class Base64<ToMutable, ToImmutable, ToSingle>(toMutableOfSize)
        satisfies IncrementalCodec<ToMutable,ToImmutable,ToSingle,ByteBuffer,Array<Byte>,Byte>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given ToSingle satisfies Object {
    ToMutable(Integer) toMutableOfSize;
    
    "The character table of this base64 variant."
    shared formal [ToSingle+] table;
    "Map of character table index to characters"
    shared formal Map<ToSingle,Byte> reverseTable;
    
    "The padding character, used where required to terminate discrete blocks of
     encoded data so they may be concatenated without making the seperation
     point ambiguous."
    shared formal ToSingle pad;
    shared Byte padCharIndex = 64.byte;
    
    shared actual Integer averageEncodeSize(Integer inputSize)
            => (2 + inputSize - ((inputSize + 2) % 3)) * 4 / 3;
    shared actual Integer maximumEncodeSize(Integer inputSize) => averageEncodeSize(inputSize);
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize * 3 / 4;
    shared actual Integer maximumDecodeSize(Integer inputSize) => averageDecodeSize(inputSize);
    
    //shared actual default Integer encodeBid({Byte*} sample) => 1;
    shared actual Integer decodeBid({ToSingle*} sample) {
        if (sample.every((s) => s==pad || s in table)) {
            return 100;
        } else {
            return 0;
        }
    }
    
    shared actual PieceConvert<ToSingle,Byte> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<ToSingle,Byte> {
        ToMutable output = toMutableOfSize(3);
        
        variable Boolean middle = true;
        variable Byte? remainder = null;
        
        void reset() {
            middle = true;
            remainder = null;
        }
        
        ToSingle byteToChar(Byte byte) {
            // Not using ErrorStrategy / EncodeException here since if this
            // doesn't succeed the implementation is wrong. All input bytes are
            // valid.
            "6 bit split is too large. Internal error."
            assert (byte.signed < 64);
            "6 bit split is negative. Internal error."
            assert (byte.signed >= 0);
            "Base64 table is invalid. Internal error."
            assert (exists char = table[byte.signed]);
            return char;
        }
        
        shared actual {ToSingle*} more(Byte input) {
            output.clear();
            // Three byte repeating quantum, producing 4 characters of 6-bits each
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum
                    // [rem 67][in 01234567] -> [char [rem 67]0123][rem 4567]
                    value byte = input.rightLogicalShift(4).or(rem.leftLogicalShift(4));
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
        
        shared actual {ToSingle*} done() {
            output.clear();
            if (exists rem = remainder) {
                if (middle) {
                    // Middle of quantum (1/4 chars already written)
                    // [rem 67] -> [char [rem 67][pad 0000]] pad pad
                    value byte = rem.leftLogicalShift(4);
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
    
    shared actual PieceConvert<Byte,ToSingle> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,ToSingle> {
        ByteBuffer output = ByteBuffer.ofSize(1);
        
        variable PieceDecoderIntraQuantum intraQuantum = second;
        variable Byte? remainder = null;
        variable Boolean padSeen = false;
        
        void reset() {
            intraQuantum = second;
            remainder = null;
            padSeen = false;
        }
        
        Byte? charToByte(ToSingle char, Boolean padPossible = false) {
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
                    }
                    case (resetStrategy) {
                        reset();
                    }
                    return null;
                }
            } else {
                switch (error)
                case (strict) {
                    throw DecodeException("``char`` is not a base64 Character");
                }
                case (ignore) {
                }
                case (resetStrategy) {
                    reset();
                }
                return null;
            }
        }
        
        shared actual {Byte*} more(ToSingle input) {
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
                    intraQuantum = third;
                }
                case (third) {
                    // Third 6 bits, or pad
                    if (inputByte == padCharIndex) {
                        // If we see pad for the third, the fourth must also be pad
                        padSeen = true;
                        // [rem 2345][pad 000000] -> [out [rem 2345][pad 0000]][rem 0000]
                        remainder = 0.byte;
                        if (rem != 0.byte) {
                            output.put(rem.leftLogicalShift(4));
                        }
                    } else {
                        // [rem 2345][in 012345] -> [out [rem 2345][in 0123]][rem 45]
                        value outputByte = rem.leftLogicalShift(4)
                            .or(inputByte.rightLogicalShift(2));
                        remainder = inputByte.and($11.byte);
                        output.put(outputByte);
                    }
                    intraQuantum = fourth;
                }
                case (fourth) {
                    // Fourth 6 bits, or pad
                    if (inputByte == padCharIndex) {
                        if (padSeen || rem == 0.byte) {
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
                            }
                            case (resetStrategy) {
                                reset();
                            }
                        } else {
                            // [rem 45][in 012345] -> [out [rem 45][in 012345]]
                            value outputByte = rem.leftLogicalShift(6).or(inputByte);
                            output.put(outputByte);
                        }
                    }
                    reset();
                }
            } else {
                // First 6 bits
                // Don't have enough to construct 8 bits yet, put entire input into remainder
                remainder = inputByte;
            }
            output.flip();
            return output;
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
                    }
                    case (resetStrategy) {
                        reset();
                    }
                    return empty;
                }
                case (third) {
                    // [rem 2345][pad 000000] -> [out [rem 2345][pad 0000]]
                    if (rem != 0.byte) {
                        value outputByte = rem.leftLogicalShift(4);
                        output.put(outputByte);
                    }
                }
                case (fourth) {
                    // [rem 45][pad 000000] -> [out [rem 45][pad 0000]]
                    if (rem != 0.byte) {
                        value outputByte = rem.leftLogicalShift(6);
                        output.put(outputByte);
                    }
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

shared abstract class Base64String()
        extends Base64<CharacterBuffer,String,Character>(CharacterBuffer.ofSize)
        satisfies CharacterToByteCodec {
    shared actual Character pad = '=';
}

shared abstract class Base64Byte()
        extends Base64<ByteBuffer,Array<Byte>,Byte>(ByteBuffer.ofSize)
        satisfies ByteToByteCodec {
    shared actual Byte pad = '='.integer.byte;
}

Map<Element,Byte> toReverseTable<Element>([Element+] table)
        given Element satisfies Object {
    return map { for (i->c in table.indexed) c->i.byte };
}
[Character+] standardCharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'];
Map<Character,Byte> standardReverseCharTable = toReverseTable(standardCharTable);
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringStandard extends Base64String() {
    shared actual [Character+] table = standardCharTable;
    shared actual Map<Character,Byte> reverseTable = standardReverseCharTable;
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 55;
}
[Character+] urlCharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '-', '_'];
Map<Character,Byte> urlReverseCharTable = toReverseTable(urlCharTable);
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringUrl extends Base64String() {
    shared actual [Character+] table = urlCharTable;
    shared actual Map<Character,Byte> reverseTable = urlReverseCharTable;
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 50;
}
[Byte+] standardByteTable = standardCharTable*.integer*.byte;
Map<Byte,Byte> standardReverseByteTable = toReverseTable(standardByteTable);
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteStandard extends Base64Byte() {
    shared actual [Byte+] table = standardByteTable;
    shared actual Map<Byte,Byte> reverseTable = standardReverseByteTable;
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 55;
}
[Byte+] urlByteTable = urlCharTable*.integer*.byte;
Map<Byte,Byte> urlReverseByteTable = toReverseTable(urlByteTable);
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteUrl extends Base64Byte() {
    shared actual [Byte+] table = urlByteTable;
    shared actual Map<Byte,Byte> reverseTable = urlReverseByteTable;
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 50;
}
