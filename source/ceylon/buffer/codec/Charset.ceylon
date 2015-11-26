import ceylon.buffer {
    ByteBuffer
}

// TODO probably should move to the charset sibling package, once ready

shared interface Charset satisfies ByteToCharacterCodec {
    // TODO needed?
}

shared object utf8 satisfies Charset {
    shared actual [String+] aliases => ["utf-8", "utf8", "utf_8"];
    
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize * 2;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize * 4;
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize / 2;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize / 4;
    
    shared actual Integer decodeBid({Byte*} sample) => nothing;
    shared actual Integer encodeBid({Character*} sample) => nothing;
    
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
            } else if (cp < #10FFFF) {
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
                    output.clear();
                }
            }
            output.flip();
            return output;
        }
    };
    
    shared actual PieceConvert<Character,Byte> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Byte> {
        variable Boolean initalOutput = true;
        ByteBuffer intermediate = ByteBuffer.ofSize(4);
        
        void reset() {
            intermediate.clear();
            intermediate.limit = 0;
        }
        reset();
        
        shared actual {Character*} more(Byte input) {
            value unsigned = input.unsigned;
            if (intermediate.limit == 0) {
                // 0b0000 0000 <= byte < 0b1000 0000
                if (unsigned < #80) {
                    // one byte
                    return { unsigned.character };
                }
                // invalid range
                if (unsigned < $11000000) {
                    switch (error)
                    case (strict) {
                        throw DecodeException("Invalid UTF-8 byte value: ``input``");
                    }
                    case (ignore) {
                        reset();
                        return empty;
                    }
                }
                // invalid range
                if (unsigned >= $11111000) {
                    switch (error)
                    case (strict) {
                        throw DecodeException("Invalid UTF-8 first byte value: ``input``");
                    }
                    case (ignore) {
                        reset();
                        return empty;
                    }
                }
                
                if (unsigned < $11100000) {
                    intermediate.limit = 1; // 0 more before final (2 total)
                }
                if (unsigned < $11110000) {
                    intermediate.limit = 2; // 1 more before final (3 total)
                }
                // 0b1111 0000 <= byte < 0b1111 1000
                if (unsigned < $11111000) {
                    intermediate.limit = 3; // 2 more before final (4 total)
                }
                // keep this byte in any case
                intermediate.put(input);
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
                    reset();
                    return empty;
                }
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
            if (initalOutput && char==#FEFF) {
                output = empty;
            } else {
                output = { char.character };
            }
            initalOutput = false;
            reset();
            return output;
        }
    };
}
