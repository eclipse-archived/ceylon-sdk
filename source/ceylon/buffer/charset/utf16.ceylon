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
    ErrorStrategy,
    PieceConvert,
    ignore,
    strict,
    EncodeException,
    DecodeException,
    resetStrategy=reset
}

"The UTF-16 character set, as defined by (its specification)
 [http://www.ietf.org/rfc/rfc2781.txt].
 
 Decoders for UTF-16 will properly recognize `BOM` (_byte order mark_) markers
 for both big and little endian encodings, but encoders will generate
 big-endian UTF-16 with no `BOM` markers."
by ("Stéphane Épardaud")
shared object utf16 satisfies Charset {
    shared actual [String+] aliases = ["UTF-16", "UTF16", "UTF_16"];
    
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize * 2;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize * 4;
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize / 2;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize;
    
    shared actual Integer encodeBid({Character*} sample) => 10;
    shared actual Integer decodeBid({Byte*} sample) {
        // There might be a more efficient way to check validity
        value decoder = pieceDecoder();
        try {
            sample.each((byte) { decoder.more(byte); });
            decoder.done();
            return 10;
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
            if (cp < #10000) {
                // single 16-bit value
                // two bytes
                value b1 = cp.and(#FF00).rightLogicalShift(8).byte;
                value b2 = cp.and(#FF).byte;
                output.put(b1);
                output.put(b2);
            } else if (cp < #110000) {
                // two 16-bit values
                value u = cp - #10000;
                // keep the high 10 bits
                value high = u.and($11111111110000000000).rightLogicalShift(10).or(#D800);
                // and the low 10 bits
                value low = u.and($1111111111).or(#DC00);
                // now turn them into four bytes
                value b1 = high.and(#FF00).rightLogicalShift(8).byte;
                value b2 = high.and(#FF).byte;
                value b3 = low.and(#FF00).rightLogicalShift(8).byte;
                value b4 = low.and(#FF).byte;
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
        variable Boolean bigEndian = true;
        variable Byte? firstByte = null;
        variable Integer? firstWord = null;
        
        void reset() {
            firstByte = null;
            firstWord = null;
        }
        reset();
        
        shared actual {Character*} more(Byte input) {
            // UTF-16 is 2 or 4 byte fixed length
            if (exists fb = firstByte) {
                {Character*} output;
                // Assemble the two bytes
                Integer word = if (bigEndian) then
                    fb.unsigned.leftLogicalShift(8).or(input.unsigned) else
                    fb.unsigned.or(input.unsigned.leftLogicalShift(8));
                
                if (exists highSurrogate = firstWord) {
                    if (word<#DC00 || word>#DFFF) {
                        switch (error)
                        case (strict) {
                            throw DecodeException {
                                "Invalid UTF-16 low surrogate value: ``word``";
                            };
                        }
                        case (ignore) {
                        }
                        case (resetStrategy) {
                            reset();
                        }
                        return empty;
                    }
                    // now assemble them
                    Integer part1 = highSurrogate.and($1111111111).leftLogicalShift(10);
                    Integer part2 = word.and($1111111111);
                    Integer char = part1.or(part2) + (#10000);
                    output = { char.character };
                } else {
                    Integer char;
                    if (word<#D800 || word>#DFFF) {
                        // Single 16bit value
                        char = word;
                    } else if (word > #DBFF) {
                        switch (error)
                        case (strict) {
                            throw DecodeException {
                                "Invalid UTF-16 high surrogate value: ``word``";
                            };
                        }
                        case (ignore) {
                        }
                        case (resetStrategy) {
                            reset();
                        }
                        return empty;
                    } else {
                        // Need a low surrogate
                        firstWord = word;
                        firstByte = null;
                        return empty;
                    }
                    // Process Byte Order Marks
                    if (char==#FEFF && initialOutput) {
                        output = empty;
                    } else if (char==#FFFE && initialOutput) {
                        bigEndian = false;
                        output = empty;
                    } else {
                        output = { char.character };
                    }
                }
                initialOutput = false;
                reset();
                return output;
            } else {
                // Store the first byte for later
                firstByte = input;
                return empty;
            }
        }
        
        shared actual {Character*} done() {
            if (firstByte exists) {
                switch (error)
                case (strict) {
                    throw DecodeException {
                        "Invalid UTF-16 sequence: missing 1 byte";
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
