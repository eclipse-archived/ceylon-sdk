import ceylon.io.buffer {
    newByteBuffer,
    ByteBuffer,
    CharacterBuffer
}
import ceylon.collection {
    StringBuilder
}

"Represents a UTF-8 character set as defined by
 (the specification)[http://tools.ietf.org/html/rfc3629]."
by("Stéphane Épardaud")
shared object utf8 satisfies Charset {
    
    "Returns `UTF-8`."
    shared actual String name = "UTF-8";
    
    "Returns a list of common aliases such as `utf8` and 
     `utf_8` even though these are not defined officially as 
     aliases by [the internet registry][].
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String[] aliases = ["utf8", "utf_8"];
    
    "Returns 1."
    shared actual Integer minimumBytesPerCharacter = 1;

    "Returns 4."
    shared actual Integer maximumBytesPerCharacter = 4;

    "Returns 2."
    shared actual Integer averageBytesPerCharacter = 2;

    shared actual class Encoder() 
            extends super.Encoder() {
        
        ByteBuffer bytes = newByteBuffer(3);
        // set its limit to 0 for reading
        bytes.flip();
        
        done => !bytes.hasAvailable;
        
        shared actual void encode(CharacterBuffer input, ByteBuffer output) {
            // give up if there's no input or no room for output
            while((input.hasAvailable || bytes.hasAvailable) && output.hasAvailable) {
                // first flush our buffer
                if(bytes.hasAvailable) {
                    output.putByte(bytes.get());
                }else{
                    // now read from input
                    value codePoint = input.get().integer;
                    // how many bytes?
                    if(codePoint < #80) {
                        // single byte
                        output.putByte(codePoint.byte);
                    }else if(codePoint < #800) {
                        // two bytes
                        value b1 = codePoint.and($11111000000).rightLogicalShift(6).or($11000000).byte;
                        value b2 = codePoint.and($111111).or($10000000).byte;
                        output.putByte(b1);
                        // save it for later
                        bytes.clear();
                        bytes.putByte(b2);
                        bytes.flip();
                    }else if(codePoint < #10000) {
                        // three bytes
                        value b1 = codePoint.and($1111000000000000).rightLogicalShift(12).or($11100000).byte;
                        value b2 = codePoint.and($111111000000).rightLogicalShift(6).or($10000000).byte;
                        value b3 = codePoint.and($111111).or($10000000).byte;
                        output.putByte(b1);
                        // save it for later
                        bytes.clear();
                        bytes.putByte(b2);
                        bytes.putByte(b3);
                        bytes.flip();
                    }else if(codePoint < #10FFFF) {
                        // four bytes
                        value b1 = codePoint.and($111000000000000000000).rightLogicalShift(18).or($11110000).byte;
                        value b2 = codePoint.and($111111000000000000).rightLogicalShift(12).or($10000000).byte;
                        value b3 = codePoint.and($111111000000).rightLogicalShift(6).or($10000000).byte;
                        value b4 = codePoint.and($111111).or($10000000).byte;
                        output.putByte(b1);
                        // save it for later
                        bytes.clear();
                        bytes.putByte(b2);
                        bytes.putByte(b3);
                        bytes.putByte(b4);
                        bytes.flip();
                    }else{
                        // FIXME: type
                        throw Exception("Invalid unicode code point");
                    }
                }
            }
        }
    }
    
    shared actual class Decoder() 
            extends super.Decoder()  {
        
        variable Integer needsMoreBytes = 0;
        ByteBuffer bytes = newByteBuffer(3);
        variable Boolean byteOrderMarkSeen = false;
        
        value builder = StringBuilder();
        
        done => needsMoreBytes==0;
        
        shared actual String consume() {
            if(needsMoreBytes > 0) {
                // type
                throw Exception("Invalid UTF-8 sequence: missing `` needsMoreBytes `` bytes");
            }
            value result = builder.string;
            builder.clear();
            return result;
        }
        
        shared actual void decode(ByteBuffer buffer) {
            for(byte in buffer) {
                value unsigned = byte.unsigned;
                // are we looking at the first byte?
                if(needsMoreBytes == 0) {
                    // 0b0000 0000 <= byte < 0b1000 0000
                    if(unsigned < #80) {
                        // one byte
                        builder.appendCharacter(unsigned.character);
                        continue;
                    }
                    // invalid range
                    if(unsigned < $11000000) {
                        // FIXME: type
                        throw Exception("Invalid UTF-8 byte value: `` byte ``");
                    }
                    // invalid range
                    if(unsigned >= $11111000) {
                        throw Exception("Invalid UTF-8 first byte value: `` byte ``");
                    }
                    // keep this byte in any case
                    bytes.putByte(byte);
                    if(unsigned < $11100000) {
                        needsMoreBytes = 1;
                        continue;
                    }
                    if(unsigned < $11110000) {
                        needsMoreBytes = 2;
                        continue;
                    }
                    // 0b1111 0000 <= byte < 0b1111 1000
                    if(unsigned < $11111000) {
                        needsMoreBytes = 3;
                        continue;
                    }
                }
                // if we got this far, we must have a second byte at least
                if(unsigned < $10000000 || unsigned >= $11000000) {
                    // FIXME: type
                    throw Exception("Invalid UTF-8 second byte value: `` byte ``");
                }
                if(--needsMoreBytes > 0) {
                    // not enough bytes
                    bytes.putByte(byte);
                    continue;
                }
                // we have enough bytes! they are all in the bytes buffer except the last one
                // they have all been checked already
                bytes.flip();
                Integer char;
                if(bytes.available == 1) {
                    Integer part1 = bytes.get().and($00011111.byte).unsigned;
                    Integer part2 = byte.and($00111111.byte).unsigned;
                    char = part1.leftLogicalShift(6)
                            .or(part2);
                }else if(bytes.available == 2) {
                    Integer part1 = bytes.get().and($00001111.byte).unsigned;
                    Integer part2 = bytes.get().and($00111111.byte).unsigned;
                    Integer part3 = byte.and($00111111.byte).unsigned;
                    char = part1.leftLogicalShift(12)
                            .or(part2.leftLogicalShift(6))
                            .or(part3);
                }else{
                    Integer part1 = bytes.get().and($00000111.byte).unsigned;
                    Integer part2 = bytes.get().and($00111111.byte).unsigned;
                    Integer part3 = bytes.get().and($00111111.byte).unsigned;
                    Integer part4 = byte.and($00111111.byte).unsigned;
                    char = part1.leftLogicalShift(18)
                            .or(part2.leftLogicalShift(12))
                            .or(part3.leftLogicalShift(6))
                            .or(part4);
                }
                // 0xFEFF is the Byte Order Mark in UTF8
                if(char == #FEFF && builder.size == 0 && !byteOrderMarkSeen) {
                    byteOrderMarkSeen = true;
                }else{
                    builder.appendCharacter(char.character);
                }
                // needsMoreBytes is already 0
                // bytes needs to be reset
                bytes.clear();
            }
        }
    }}

