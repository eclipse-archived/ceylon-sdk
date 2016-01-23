import ceylon.buffer {
    Buffer,
    ByteBuffer,
    CharacterBuffer
}
import ceylon.buffer.codec {
    IncrementalCodec,
    ByteToByteCodec,
    CharacterToByteCodec,
    ErrorStrategy,
    PieceConvert
}

abstract class Base32PieceEncoderState()
        of
    b32EncodeFirst |
    b32EncodeSecond |
    b32EncodeThird |
    b32EncodeFourth |
    b32EncodeFifth {}
object b32EncodeFirst extends Base32PieceEncoderState() {}
object b32EncodeSecond extends Base32PieceEncoderState() {}
object b32EncodeThird extends Base32PieceEncoderState() {}
object b32EncodeFourth extends Base32PieceEncoderState() {}
object b32EncodeFifth extends Base32PieceEncoderState() {}

shared sealed abstract class Base32<ToMutable, ToImmutable, ToSingle>(toMutableOfSize)
        satisfies IncrementalCodec<ToMutable,ToImmutable,ToSingle,ByteBuffer,Array<Byte>,Byte>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given ToSingle satisfies Object {
    ToMutable(Integer) toMutableOfSize;
    
    shared formal ToSingle[] encodeTable;
    shared Byte[] decodeTable = [];
    shared formal Integer decodeToIndex(ToSingle input);
    
    "The padding character, used where required to terminate discrete blocks of
     encoded data so they may be concatenated without making the seperation
     point ambiguous."
    shared formal ToSingle pad;
    shared Byte padCharIndex = 32.byte;
    
    shared actual Integer averageEncodeSize(Integer inputSize) => ceiling(inputSize, 5.0) * 8;
    shared actual Integer maximumEncodeSize(Integer inputSize) => averageEncodeSize(inputSize);
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize * 5 / 8;
    shared actual Integer maximumDecodeSize(Integer inputSize) => averageDecodeSize(inputSize);
    
    shared actual PieceConvert<ToSingle,Byte> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<ToSingle,Byte> {
                ToMutable output = toMutableOfSize(8);
                
                variable Base32PieceEncoderState state = b32EncodeFirst;
                variable Byte? remainder = null;
                
                void reset() {
                    state = b32EncodeFirst;
                    remainder = null;
                }
                
                ToSingle byteToChar(Byte byte) {
                    // Not using ErrorStrategy / EncodeException here since if this
                    // doesn't succeed the implementation is wrong. All input bytes are
                    // valid.
                    "5 bit split is too large. Internal error."
                    assert (byte.signed < 32);
                    "5 bit split is negative. Internal error."
                    assert (byte.signed >= 0);
                    "Base32 table is invalid. Internal error."
                    assert (exists char = encodeTable[byte.signed]);
                    return char;
                }
                
                shared actual {ToSingle*} more(Byte input) {
                    output.clear();
                    // Five byte repeating quantum, producing 8 characters of 5-bits each
                    switch (state)
                    case (b32EncodeFirst) {
                        // [in 01234567] -> [char 01234][rem 567]
                        remainder = input.and($111.byte);
                        output.put(byteToChar(input.rightLogicalShift(3)));
                        state = b32EncodeSecond;
                    }
                    case (b32EncodeSecond) {
                        // [rem 567][in 01234567] -> [char [rem 567]01][char 23456][rem 7]
                        assert (exists rem = remainder);
                        remainder = input.and($1.byte);
                        output.put(byteToChar {
                                rem.leftLogicalShift(2).or(input.rightLogicalShift(6));
                            });
                        output.put(byteToChar {
                                input.rightLogicalShift(1).and($11111.byte);
                            });
                        state = b32EncodeThird;
                    }
                    case (b32EncodeThird) {
                        // [rem 7][in 01234567] -> [char [rem 7]0123][rem 4567]
                        assert (exists rem = remainder);
                        remainder = input.and($1111.byte);
                        output.put(byteToChar {
                                rem.leftLogicalShift(4).or(input.rightLogicalShift(4));
                            });
                        state = b32EncodeFourth;
                    }
                    case (b32EncodeFourth) {
                        // [rem 4567][in 01234567] -> [char [rem 4567]0][char 12345][rem 67]
                        assert (exists rem = remainder);
                        remainder = input.and($11.byte);
                        output.put(byteToChar {
                                rem.leftLogicalShift(1).or(input.rightLogicalShift(7));
                            });
                        output.put(byteToChar {
                                input.rightLogicalShift(2).and($11111.byte);
                            });
                        state = b32EncodeFifth;
                    }
                    case (b32EncodeFifth) {
                        // [rem 67][in 01234567] -> [char [rem 67]012][char 34567]
                        assert (exists rem = remainder);
                        output.put(byteToChar {
                                rem.leftLogicalShift(3).or(input.rightLogicalShift(5));
                            });
                        output.put(byteToChar {
                                input.and($11111.byte);
                            });
                        reset();
                    }
                    output.flip();
                    return output;
                }
                
                shared actual {ToSingle*} done() {
                    output.clear();
                    switch (state)
                    case (b32EncodeFirst) {
                        // At quantum boundary, nothing to return
                    }
                    case (b32EncodeSecond) {
                        // [rem 567] -> [char [rem 567][pad 00]][char [pad 00000]] pad*5
                        assert (exists rem = remainder);
                        output.put(byteToChar(rem.leftLogicalShift(2)));
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                    }
                    case (b32EncodeThird) {
                        // [rem 7] -> [char [rem 7][pad 0000]] pad pad pad pad
                        assert (exists rem = remainder);
                        output.put(byteToChar(rem.leftLogicalShift(4)));
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                    }
                    case (b32EncodeFourth) {
                        // [rem 4567] -> [char [rem 4567][pad 0]][char [pad 00000]] pad pad
                        assert (exists rem = remainder);
                        output.put(byteToChar(rem.leftLogicalShift(1)));
                        output.put(pad);
                        output.put(pad);
                        output.put(pad);
                    }
                    case (b32EncodeFifth) {
                        assert (exists rem = remainder);
                        // [rem 67] -> [char [rem 67][pad 000]][char [pad 00000]]
                        output.put(byteToChar(rem.leftLogicalShift(3)));
                        output.put(pad);
                    }
                    reset();
                    output.flip();
                    return output;
                }
            };
    
    shared actual PieceConvert<Byte,ToSingle> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,ToSingle> {
                shared actual {Byte*} more(ToSingle input) => nothing;
                shared actual {Byte*} done() => nothing;
            };
    
    shared actual Integer decodeBid({ToSingle*} sample) {
        if (sample.every((s) => s==pad || s in encodeTable)) {
            return 50;
        } else {
            return 0;
        }
    }
}

shared abstract class Base32String()
        extends Base32<CharacterBuffer,String,Character>(CharacterBuffer.ofSize)
        satisfies CharacterToByteCodec {
    shared actual Character pad = '=';
}

shared abstract class Base32Byte()
        extends Base32<ByteBuffer,Array<Byte>,Byte>(ByteBuffer.ofSize)
        satisfies ByteToByteCodec {
    shared actual Byte pad = '='.integer.byte;
}

Character[] standardBase32CharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '2', '3', '4', '5',
    '6', '7'
];
shared object base32StringStandard extends Base32String() {
    shared actual Character[] encodeTable = standardBase32CharTable;
    shared actual [String+] aliases = ["base32", "base-32", "base_32"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
    shared actual Integer decodeToIndex(Character input) => input.integer;
}
Byte[] standardBase32ByteTable = standardBase32CharTable*.integer*.byte.sequence();
shared object base32ByteStandard extends Base32Byte() {
    shared actual Byte[] encodeTable = standardBase32ByteTable;
    shared actual [String+] aliases = ["base32", "base-32", "base-32"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
}

Character[] hexBase32CharTable = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
    'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V'
];
shared object base32StringHex extends Base32String() {
    shared actual Character[] encodeTable = hexBase32CharTable;
    shared actual [String+] aliases = ["base32hex", "base-32-hex", "base_32_hex"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
    shared actual Integer decodeToIndex(Character input) => input.integer;
}
Byte[] hexBase32ByteTable = hexBase32CharTable*.integer*.byte.sequence();
shared object base32ByteHex extends Base32Byte() {
    shared actual Byte[] encodeTable = hexBase32ByteTable;
    shared actual [String+] aliases = ["base32hex", "base-32-hex", "base_32_hex"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
}
