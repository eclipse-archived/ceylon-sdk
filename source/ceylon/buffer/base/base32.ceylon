/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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
    PieceConvert,
    strict,
    DecodeException,
    ignore,
    resetStrategy=reset
}

import ceylon.buffer.base {
    Base32PieceEncoderState { ... },
    Base32PieceDecoderState { ... }
}

final class Base32PieceEncoderState
        of
    b32EncodeFirst |
    b32EncodeSecond |
    b32EncodeThird |
    b32EncodeFourth |
    b32EncodeFifth {
    shared new b32EncodeFirst {}
    shared new b32EncodeSecond {}
    shared new b32EncodeThird {}
    shared new b32EncodeFourth {}
    shared new b32EncodeFifth {}
}

final class Base32PieceDecoderState
        of
    b32DecodeFirst |
    b32DecodeSecond |
    b32DecodeThird |
    b32DecodeFourth |
    b32DecodeFifth |
    b32DecodeSixth |
    b32DecodeSeventh |
    b32DecodeEighth {
    shared new b32DecodeFirst {}
    shared new b32DecodeSecond {}
    shared new b32DecodeThird {}
    shared new b32DecodeFourth {}
    shared new b32DecodeFifth {}
    shared new b32DecodeSixth {}
    shared new b32DecodeSeventh {}
    shared new b32DecodeEighth {}
}

shared sealed abstract class Base32<ToMutable, ToImmutable, ToSingle>(toMutableOfSize)
        satisfies IncrementalCodec<ToMutable,ToImmutable,ToSingle,ByteBuffer,List<Byte>,Byte>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given ToSingle satisfies Object {
    ToMutable(Integer) toMutableOfSize;
    
    shared formal ToSingle[] encodeTable;
    shared formal Integer decodeToIndex(ToSingle input);
    shared formal Byte[] decodeTable;
    
    "The padding character, used where required to terminate discrete blocks of
     encoded data so they may be concatenated without making the seperation
     point ambiguous."
    shared formal ToSingle pad;
    
    shared actual Integer averageEncodeSize(Integer inputSize) => ceiling(inputSize, 5.0) * 8;
    shared actual Integer maximumEncodeSize(Integer inputSize) => averageEncodeSize(inputSize);
    shared actual Integer averageDecodeSize(Integer inputSize) => ceiling(inputSize * 5, 8.0);
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
                ByteBuffer output = ByteBuffer.ofSize(1);
                
                variable Base32PieceDecoderState state = b32DecodeFirst;
                variable Boolean padSeen = false;
                variable Byte? remainder = null;
                
                void reset() {
                    state = b32DecodeFirst;
                    padSeen = false;
                    remainder = null;
                }
                
                shared actual {Byte*} more(ToSingle input) {
                    output.clear();
                    void handleState(nextState, handleInputByte, handlePad = null) {
                        variable Base32PieceDecoderState nextState;
                        Anything(Byte) handleInputByte;
                        Anything()? handlePad;
                        if (input == pad) {
                            if (exists handlePad) {
                                padSeen = true;
                                if (exists rem = remainder, rem != 0.byte) {
                                    handlePad();
                                }
                            } else {
                                switch (error)
                                case (strict) {
                                    throw DecodeException {
                                        "Pad element ``input`` is not allowed here";
                                    };
                                }
                                case (ignore) {
                                }
                                case (resetStrategy) {
                                    reset();
                                    nextState = state;
                                }
                            }
                        } else if (padSeen) {
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
                                nextState = state;
                            }
                        } else {
                            Integer inputIndex = decodeToIndex(input);
                            if (exists inByte = decodeTable[inputIndex], inByte != 255.byte) {
                                handleInputByte(inByte);
                            } else {
                                switch (error)
                                case (strict) {
                                    throw DecodeException("``input`` is not a base32 character");
                                }
                                case (ignore) {
                                }
                                case (resetStrategy) {
                                    reset();
                                    nextState = state;
                                }
                            }
                        }
                        state = nextState;
                    }
                    // 8 character (of 5-bits each) repeating quantum, producing 5 bytes
                    switch (state)
                    case (b32DecodeFirst) {
                        handleState {
                            nextState = b32DecodeSecond;
                            // [rem 01234] (insufficent to make a byte)
                            handleInputByte = (b) => remainder = b;
                        };
                    }
                    case (b32DecodeSecond) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeThird;
                            // [rem 01234][in 01234] -> [out [rem 01234][in 012]][rem 34]
                            handleInputByte = (b) {
                                remainder = b.and($11.byte);
                                output.put {
                                    rem.leftLogicalShift(3).or(b.rightLogicalShift(2));
                                };
                            };
                            handlePad = () {
                                // [rem 01234][pad 000] -> [out [[rem 01234][pad 000]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(3));
                            };
                        };
                    }
                    case (b32DecodeThird) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeFourth;
                            // [rem 34][in 01234] -> [rem [rem 34][in 01234]] (insufficent)
                            handleInputByte = (b) {
                                remainder = rem.leftLogicalShift(5).or(b);
                            };
                            handlePad = () {
                                // [rem 34][pad 000000] -> [out [rem 34][pad 000000]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(6));
                            };
                        };
                    }
                    case (b32DecodeFourth) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeFifth;
                            // [rem 3401234][in 01234] -> [out [rem 3401234][in 0]][rem 1234]
                            handleInputByte = (b) {
                                remainder = b.and($1111.byte);
                                output.put {
                                    rem.leftLogicalShift(1).or(b.rightLogicalShift(4));
                                };
                            };
                            handlePad = () {
                                // [rem 3401234][pad 0] -> [out [rem 3401234][pad 0]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(1));
                            };
                        };
                    }
                    case (b32DecodeFifth) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeSixth;
                            // [rem 1234][in 01234] -> [out [rem 1234][in 0123]][rem 4]
                            handleInputByte = (b) {
                                remainder = b.and($1.byte);
                                output.put {
                                    rem.leftLogicalShift(4).or(b.rightLogicalShift(1));
                                };
                            };
                            handlePad = () {
                                // [rem 1234][pad 0000] -> [out [rem 1234][pad 0000]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(4));
                            };
                        };
                    }
                    case (b32DecodeSixth) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeSeventh;
                            // [rem 4][in 01234] -> [rem [rem 4][in 01234]] (insufficent)
                            handleInputByte = (b) {
                                remainder = rem.leftLogicalShift(5).or(b);
                            };
                            handlePad = () {
                                // [rem 4][pad 0000000] -> [rem [rem 4][pad 0000000]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(7));
                            };
                        };
                    }
                    case (b32DecodeSeventh) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeEighth;
                            // [rem 401234][in 01234] -> [out [rem 401234][in 01]][rem 234]
                            handleInputByte = (b) {
                                remainder = b.and($111.byte);
                                output.put {
                                    rem.leftLogicalShift(2).or(b.rightLogicalShift(3));
                                };
                            };
                            handlePad = () {
                                // [rem 401234][pad 00] -> [out [rem 401234][pad 00]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(2));
                            };
                        };
                    }
                    case (b32DecodeEighth) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b32DecodeFirst;
                            // [rem 234][in 01234] -> [out [rem 234][in 01234]]
                            handleInputByte = (b) {
                                remainder = 0.byte;
                                output.put {
                                    rem.leftLogicalShift(5).or(b);
                                };
                            };
                            handlePad = () {
                                // [rem 234][pad 00000] -> [out [rem 234][pad 00000]]
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(5));
                            };
                        };
                        reset();
                    }
                    output.flip();
                    return output;
                }
                
                shared actual {Byte*} done() {
                    output.clear();
                    // Pad termination is optional
                    if (!padSeen) {
                        switch (state)
                        case (b32DecodeFirst) {
                            // At quantum boundary, nothing to return
                        }
                        case (b32DecodeSecond) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(3));
                            }
                        }
                        case (b32DecodeThird) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(6));
                            }
                        }
                        case (b32DecodeFourth) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(1));
                            }
                        }
                        case (b32DecodeFifth) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(4));
                            }
                        }
                        case (b32DecodeSixth) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(7));
                            }
                        }
                        case (b32DecodeSeventh) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(2));
                            }
                        }
                        case (b32DecodeEighth) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(5));
                            }
                        }
                    }
                    reset();
                    output.flip();
                    return output;
                }
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
        extends Base32<ByteBuffer,List<Byte>,Byte>(ByteBuffer.ofSize)
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
    shared actual Integer decodeToIndex(Character input) => input.integer;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base32", "base-32", "base_32"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}
Byte[] standardBase32ByteTable = standardBase32CharTable*.integer*.byte.sequence();
shared object base32ByteStandard extends Base32Byte() {
    shared actual Byte[] encodeTable = standardBase32ByteTable;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base32", "base-32", "base-32"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}

Character[] hexBase32CharTable = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E',
    'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V'
];
shared object base32StringHex extends Base32String() {
    shared actual Character[] encodeTable = hexBase32CharTable;
    shared actual Integer decodeToIndex(Character input) => input.integer;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base32hex", "base-32-hex", "base_32_hex"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}
Byte[] hexBase32ByteTable = hexBase32CharTable*.integer*.byte.sequence();
shared object base32ByteHex extends Base32Byte() {
    shared actual Byte[] encodeTable = hexBase32ByteTable;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base32hex", "base-32-hex", "base_32_hex"];
    shared actual Integer encodeBid({Byte*} sample) => 10;
}
