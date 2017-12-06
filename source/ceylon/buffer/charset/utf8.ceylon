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
    ByteBuffer
}
import ceylon.buffer.codec {
    ignore,
    strict,
    EncodeException,
    ErrorStrategy,
    DecodeException,
    PieceConvert,
    resetStrategy=reset
}

"The UTF-8 character set, as defined by (its specification)
 [http://tools.ietf.org/html/rfc3629]."
by ("Stéphane Épardaud")
shared object utf8 satisfies Charset {
    shared actual [String+] aliases = ["UTF-8", "UTF8", "UTF_8"];
    
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize * 2;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize * 4;
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize / 2;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize;
    
    shared actual Integer encodeBid({Character*} sample) => 15;
    shared actual Integer decodeBid({Byte*} sample) {
        // There might be a more efficient way to check validity
        value decoder = pieceDecoder();
        try {
            sample.each((byte) { decoder.more(byte); });
            decoder.done();
            return 15;
        } catch (DecodeException e) {
            return 0;
        }
    }
    
    shared actual PieceConvert<Byte,Character> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,Character> {
        ByteBuffer output = ByteBuffer.ofSize(4);
        
        shared actual {Byte*} more(Character input) {
            output.clear();
            value cp = input.integer;
            // how many bytes?
            if (cp < #80) {
                // single byte
                output.put(cp.byte);
            } else if (cp < #800) {
                // two bytes
                value b1 = cp.and($11111000000).rightLogicalShift(6).or($11000000).byte;
                value b2 = cp.and($111111).or($10000000).byte;
                output.put(b1);
                output.put(b2);
            } else if (cp < #10000) {
                // three bytes
                value b1 = cp.and($1111000000000000).rightLogicalShift(12).or($11100000).byte;
                value b2 = cp.and($111111000000).rightLogicalShift(6).or($10000000).byte;
                value b3 = cp.and($111111).or($10000000).byte;
                output.put(b1);
                output.put(b2);
                output.put(b3);
            } else if (cp < #110000) {
                // four bytes
                value b1 = cp.and($111000000000000000000).rightLogicalShift(18).or($11110000).byte;
                value b2 = cp.and($111111000000000000).rightLogicalShift(12).or($10000000).byte;
                value b3 = cp.and($111111000000).rightLogicalShift(6).or($10000000).byte;
                value b4 = cp.and($111111).or($10000000).byte;
                output.put(b1);
                output.put(b2);
                output.put(b3);
                output.put(b4);
            } else {
                switch (error)
                case (strict) {
                    throw EncodeException("Invalid unicode code point ``cp``");
                }
                case (ignore) {
                }
                case (resetStrategy) {
                }
            }
            output.flip();
            return output;
        }
    };
    
    shared actual PieceConvert<Character,Byte> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Byte> {
        variable Boolean initialOutput = true;
        ByteBuffer intermediate = ByteBuffer.ofSize(4);
        
        void reset() {
            intermediate.clear();
            intermediate.limit = 0;
        }
        reset();
        
        shared actual {Character*} more(Byte input) {
            // UTF-8 is max 4-byte variable length
            value unsigned = input.unsigned;
            if (intermediate.limit == 0) {
                // 0b0000 0000 <= byte < 0b1000 0000
                if (unsigned < $10000000) {
                    // one byte
                    return { unsigned.character };
                }
                // Select multi-byte limit
                if (unsigned < $11000000) {
                    // invalid range
                    switch (error)
                    case (strict) {
                        throw DecodeException("Invalid UTF-8 first byte value: ``input``");
                    }
                    case (ignore) {
                    }
                    case (resetStrategy) {
                        reset();
                    }
                } else if (unsigned < $11100000) {
                    intermediate.limit = 1; // 0 more before final (2 total)
                } else if (unsigned < $11110000) {
                    intermediate.limit = 2; // 1 more before final (3 total)
                } else if (unsigned < $11111000) {
                    // 0b1111 0000 <= byte < 0b1111 1000
                    intermediate.limit = 3; // 2 more before final (4 total)
                } else {
                    // invalid range
                    switch (error)
                    case (strict) {
                        throw DecodeException("Invalid UTF-8 first byte value: ``input``");
                    }
                    case (ignore) {
                    }
                    case (resetStrategy) {
                        reset();
                    }
                    return empty;
                }
                // keep this byte in any case
                intermediate.put(input);
                return empty;
            }
            // if we got this far, we must have a second byte at least
            if (unsigned<$10000000 || unsigned>=$11000000) {
                switch (error)
                case (strict) {
                    throw DecodeException {
                        "Invalid UTF-8 ``intermediate.position`` byte value: ``input``";
                    };
                }
                case (ignore) {
                }
                case (resetStrategy) {
                    reset();
                }
                return empty;
            }
            if (intermediate.available > 0) {
                // not enough bytes
                intermediate.put(input);
                return empty;
            }
            // we have enough bytes! they are all in the bytes buffer except
            // the last one they have all been checked already
            intermediate.flip();
            Integer char;
            if (intermediate.available == 1) {
                Integer part1 = intermediate.get().and($00011111.byte).unsigned;
                Integer part2 = input.and($00111111.byte).unsigned;
                char = part1.leftLogicalShift(6)
                    .or(part2);
            } else if (intermediate.available == 2) {
                Integer part1 = intermediate.get().and($00001111.byte).unsigned;
                Integer part2 = intermediate.get().and($00111111.byte).unsigned;
                Integer part3 = input.and($00111111.byte).unsigned;
                char = part1.leftLogicalShift(12)
                    .or(part2.leftLogicalShift(6))
                    .or(part3);
            } else { // intermediate.available == 3
                Integer part1 = intermediate.get().and($00000111.byte).unsigned;
                Integer part2 = intermediate.get().and($00111111.byte).unsigned;
                Integer part3 = intermediate.get().and($00111111.byte).unsigned;
                Integer part4 = input.and($00111111.byte).unsigned;
                char = part1.leftLogicalShift(18)
                    .or(part2.leftLogicalShift(12))
                    .or(part3.leftLogicalShift(6))
                    .or(part4);
            }
            
            {Character*} output;
            // 0xFEFF is the Byte Order Mark in UTF8
            if (initialOutput && char==#FEFF) {
                output = empty;
            } else {
                output = { char.character };
            }
            initialOutput = false;
            reset();
            return output;
        }
        
        shared actual {Character*} done() {
            if (intermediate.limit != 0) {
                switch (error)
                case (strict) {
                    throw DecodeException {
                        "Invalid UTF-8 sequence: missing `` intermediate.available + 1 `` bytes";
                    };
                }
                case (ignore) {
                }
                case (resetStrategy) {
                }
            }
            reset();
            return empty;
        }
    };
}
