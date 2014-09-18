import ceylon.io.buffer {
    ByteBuffer,
    newByteBuffer,
    CharacterBuffer
}
import ceylon.collection {
    StringBuilder
}

"Represents a UTF-16 character set as defined by
 (the specification)[http://www.ietf.org/rfc/rfc2781.txt].
 
 Decoders for UTF-16 will properly recognize `BOM` 
 (_byte order mark_) markers for both big and little endian
 encodings, but encoders will generate big-endian UTF-16 
 with no `BOM` markers."
by("Stéphane Épardaud")
shared object utf16 satisfies Charset {
    
    "Returns `UTF-16`."
    shared actual String name = "UTF-16";

    "Returns a list of common aliases such as `utf16` and 
     `utf_16` even though these are not defined officially 
     as aliases by [the internet registry][].
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String[] aliases = ["utf16", "utf_16"];
    
    "Returns 2."
    shared actual Integer minimumBytesPerCharacter = 2;

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
                    if(codePoint < #10000) {
                        // single 16-bit value
                        // two bytes
                        value b1 = codePoint.and(#FF00).rightLogicalShift(8).byte;
                        value b2 = codePoint.and(#FF).byte;
                        output.putByte(b1);
                        // save it for later
                        bytes.clear();
                        bytes.putByte(b2);
                        bytes.flip();
                    }else if(codePoint < #10FFFF) {
                        // two 16-bit values
                        value u = codePoint - #10000;
                        // keep the high 10 bits
                        value high = u.and($11111111110000000000).rightLogicalShift(10).or(#D800);
                        // and the low 10 bits
                        value low = u.and($1111111111).or(#DC00);
                        // now turn them into four bytes
                        value b1 = high.and(#FF00).rightLogicalShift(8).byte;
                        value b2 = high.and(#FF).byte;
                        value b3 = low.and(#FF00).rightLogicalShift(8).byte;
                        value b4 = low.and(#FF).byte;
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
        
        variable Boolean needsMoreBytes = false;
        variable Byte firstByte = 0.byte;
        
        variable Boolean needsLowSurrogate = false;
        variable Integer highSurrogate = 0;
        
        variable Boolean bigEndian = true;
        
        variable Boolean byteOrderMarkSeen = false;
        
        value builder = StringBuilder(); 
        
        done => !needsMoreBytes && !needsLowSurrogate;
        
        shared actual String consume() {
            if(needsMoreBytes) {
                // FIXME: type
                throw Exception("Invalid UTF-16 sequence: missing a byte");
            }
            if(needsLowSurrogate) {
                // FIXME: type
                throw Exception("Invalid UTF-16 sequence: missing low surrogate");
            }
            String result = builder.string;
            builder.clear();
            return result;
        }
        
        Integer assembleBytes(Byte a, Byte b) { 
            if(bigEndian) {
                return a.unsigned.leftLogicalShift(8).or(b.unsigned);
            }else{
                return a.unsigned.or(b.unsigned.leftLogicalShift(8));
            }
        }
        
        shared actual void decode(ByteBuffer buffer) {
            for(byte in buffer) {
                // are we looking at the first byte of a 16-bit word?
                if(!needsMoreBytes) {
                    // keep this byte in any case
                    firstByte = byte;
                    needsMoreBytes = true;
                    continue;
                }
                // are we looking at the second byte?
                if(needsMoreBytes) {
                    Integer char;
                    
                    // assemble the two bytes
                    Integer word = assembleBytes(firstByte, byte);
                    needsMoreBytes = false;
                    
                    // are we looking at the first 16-bit word?
                    if(!needsLowSurrogate) {
                        // Single 16bit value
                        if(word < #D800 || word > #DFFF) {
                            // we got the char
                            char = word;
                        }else if(word > #DBFF) {
                            // FIXME: type
                            throw Exception("Invalid UTF-16 high surrogate value: `` word ``");
                        }else{
                            // we're waiting for the second half;
                            highSurrogate = word;
                            needsLowSurrogate = true;
                            continue;
                        }
                    }else{
                        // we have the second 16-bit word, check it
                        if(word < #DC00 || word > #DFFF) {
                            // FIXME: type
                            throw Exception("Invalid UTF-16 low surrogate value: `` word ``");
                        }
                        // now assemble them
                        Integer part1 = highSurrogate.and($1111111111).leftLogicalShift(10);
                        Integer part2 = word.and($1111111111);
                        char = part1.or(part2) + (#10000);
                        
                        needsLowSurrogate = false; 
                    }
                    
                    // 0xFEFF is the Byte Order Mark in UTF8
                    if(char == #FEFF && builder.size == 0 && !byteOrderMarkSeen) {
                        byteOrderMarkSeen = true;
                    }else if(char == #FFFE && builder.size == 0 && !byteOrderMarkSeen) {
                        byteOrderMarkSeen = true;
                        bigEndian = false;
                    }else{
                        builder.appendCharacter(char.character);
                    }
                }
            }
        }
    }}

