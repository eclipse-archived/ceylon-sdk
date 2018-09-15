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

import ceylon.buffer.base {
    Base64PieceEncoderState { ... },
    Base64PieceDecoderState { ... }
}

final class Base64PieceEncoderState
        of
    b64EncodeFirst |
    b64EncodeSecond |
    b64EncodeThird {
    shared new b64EncodeFirst {}
    shared new b64EncodeSecond {}
    shared new b64EncodeThird {}
}

final class Base64PieceDecoderState
        of
    b64DecodeFirst |
    b64DecodeSecond |
    b64DecodeThird |
    b64DecodeFourth {
    shared new b64DecodeFirst {}
    shared new b64DecodeSecond {}
    shared new b64DecodeThird {}
    shared new b64DecodeFourth {}
}

shared sealed abstract class Base64<ToMutable, ToImmutable, ToSingle>(toMutableOfSize)
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
    
    shared actual Integer averageEncodeSize(Integer inputSize) => ceiling(inputSize, 3.0) * 4;
    shared actual Integer maximumEncodeSize(Integer inputSize) => averageEncodeSize(inputSize);
    shared actual Integer averageDecodeSize(Integer inputSize) => ceiling(inputSize * 3, 4.0);
    shared actual Integer maximumDecodeSize(Integer inputSize) => averageDecodeSize(inputSize);
    
    shared actual PieceConvert<ToSingle,Byte> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<ToSingle,Byte> {
                ToMutable output = toMutableOfSize(3);
                
                variable Base64PieceEncoderState state = b64EncodeFirst;
                variable Byte? remainder = null;
                
                void reset() {
                    state = b64EncodeFirst;
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
                    assert (exists char = encodeTable[byte.signed]);
                    return char;
                }
                
                shared actual {ToSingle*} more(Byte input) {
                    output.clear();
                    // Three byte repeating quantum, producing 4 characters of 6-bits each
                    switch (state)
                    case (b64EncodeFirst) {
                        // [in 01234567] -> [char 012345][rem 67]
                        remainder = input.and($11.byte);
                        output.put(byteToChar(input.rightLogicalShift(2)));
                        state = b64EncodeSecond;
                    }
                    case (b64EncodeSecond) {
                        // [rem 67][in 01234567] -> [char [rem 67]0123][rem 4567]
                        assert (exists rem = remainder);
                        remainder = input.and($1111.byte);
                        output.put(byteToChar {
                                input.rightLogicalShift(4).or(rem.leftLogicalShift(4));
                            });
                        state = b64EncodeThird;
                    }
                    case (b64EncodeThird) {
                        // [rem 4567][in 01234567] -> [char [rem 4567]01][char 234567]
                        assert (exists rem = remainder);
                        output.put(byteToChar {
                                input.rightLogicalShift(6).or(rem.leftLogicalShift(2));
                            });
                        output.put(byteToChar {
                                input.and($111111.byte);
                            });
                        reset();
                    }
                    output.flip();
                    return output;
                }
                
                shared actual {ToSingle*} done() {
                    output.clear();
                    switch (state)
                    case (b64EncodeFirst) {
                        // At quantum boundary, nothing to return
                    }
                    case (b64EncodeSecond) {
                        // [rem 67] -> [char [rem 67][pad 0000]] pad pad
                        assert (exists rem = remainder);
                        output.put(byteToChar(rem.leftLogicalShift(4)));
                        output.put(pad);
                        output.put(pad);
                    }
                    case (b64EncodeThird) {
                        // [rem 4567] -> [char [rem 4567][pad 00]] pad
                        assert (exists rem = remainder);
                        output.put(byteToChar(rem.leftLogicalShift(2)));
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
                
                variable Base64PieceDecoderState state = b64DecodeFirst;
                variable Boolean padSeen = false;
                variable Byte? remainder = null;
                
                void reset() {
                    state = b64DecodeFirst;
                    padSeen = false;
                    remainder = null;
                }
                
                shared actual {Byte*} more(ToSingle input) {
                    output.clear();
                    void handleState(nextState, handleInputByte, handlePad = null) {
                        variable Base64PieceDecoderState nextState;
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
                                    throw DecodeException("``input`` is not a base64 character");
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
                    // Repeating quantum of four 6-bit characters, producing 3 bytes
                    switch (state)
                    case (b64DecodeFirst) {
                        handleState {
                            nextState = b64DecodeSecond;
                            // Don't have enough to construct 8 bits yet
                            handleInputByte = (b) => remainder = b;
                        };
                    }
                    case (b64DecodeSecond) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b64DecodeThird;
                            // [rem 012345][in 012345] -> [out [rem 012345][in 01]][rem 2345]
                            handleInputByte = (b) {
                                remainder = b.and($1111.byte);
                                output.put {
                                    rem.leftLogicalShift(2).or(b.rightLogicalShift(4));
                                };
                            };
                            // [rem 012345][pad 00] -> [out [rem 012345][pad 00]]
                            handlePad = () {
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(2));
                            };
                        };
                    }
                    case (b64DecodeThird) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b64DecodeFourth;
                            // [rem 2345][in 012345] -> [out [rem 2345][in 0123]][rem 45]
                            handleInputByte = (b) {
                                remainder = b.and($11.byte);
                                output.put {
                                    rem.leftLogicalShift(4).or(b.rightLogicalShift(2));
                                };
                            };
                            // [rem 2345][pad 000000] -> [out [rem 2345][pad 0000]]
                            handlePad = () {
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(4));
                            };
                        };
                    }
                    case (b64DecodeFourth) {
                        assert (exists rem = remainder);
                        handleState {
                            nextState = b64DecodeFirst;
                            // [rem 45][in 012345] -> [out [rem 45][in 012345]]
                            handleInputByte = (b) {
                                remainder = 0.byte;
                                output.put {
                                    rem.leftLogicalShift(6).or(b);
                                };
                            };
                            // [rem 45][pad 000000] -> [out [rem 45][pad 0000]]
                            handlePad = () {
                                remainder = 0.byte;
                                output.put(rem.leftLogicalShift(6));
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
                        case (b64DecodeFirst) {
                            // At quantum boundary, nothing to return
                        }
                        case (b64DecodeSecond) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(2));
                            }
                        }
                        case (b64DecodeThird) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(4));
                            }
                        }
                        case (b64DecodeFourth) {
                            if (exists rem = remainder, rem != 0.byte) {
                                output.put(rem.leftLogicalShift(6));
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
            return 100;
        } else {
            return 0;
        }
    }
}

shared abstract class Base64String()
        extends Base64<CharacterBuffer,String,Character>(CharacterBuffer.ofSize)
        satisfies CharacterToByteCodec {
    shared actual Character pad = '=';
}

shared abstract class Base64Byte()
        extends Base64<ByteBuffer,List<Byte>,Byte>(ByteBuffer.ofSize)
        satisfies ByteToByteCodec {
    shared actual Byte pad = '='.integer.byte;
}

Character[] standardBase64CharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', '+', '/'
];
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringStandard extends Base64String() {
    shared actual Character[] encodeTable = standardBase64CharTable;
    shared actual Integer decodeToIndex(Character input) => input.integer;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 55;
}
Byte[] standardBase64ByteTable = standardBase64CharTable*.integer*.byte.sequence();
"The Basic type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteStandard extends Base64Byte() {
    shared actual Byte[] encodeTable = standardBase64ByteTable;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base64", "base-64", "base_64"];
    shared actual Integer encodeBid({Byte*} sample) => 55;
}

Character[] urlBase64CharTable = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', '-', '_'
];
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64StringUrl extends Base64String() {
    shared actual Character[] encodeTable = urlBase64CharTable;
    shared actual Integer decodeToIndex(Character input) => input.integer;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 50;
}
Byte[] urlBase64ByteTable = urlBase64CharTable*.integer*.byte.sequence();
"The URL and Filename safe type base64 encoding scheme of [RFC 4648][rfc4648].
 [rfc4648]: http://tools.ietf.org/html/rfc4648"
shared object base64ByteUrl extends Base64Byte() {
    shared actual Byte[] encodeTable = urlBase64ByteTable;
    shared actual Integer decodeToIndex(Byte input) => input.unsigned;
    shared actual Byte[] decodeTable = toDecodeTable(encodeTable, decodeToIndex);
    shared actual [String+] aliases = ["base64url", "base-64-url", "base_64_url"];
    shared actual Integer encodeBid({Byte*} sample) => 50;
}
