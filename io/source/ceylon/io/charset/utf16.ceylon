import ceylon.io.buffer { ByteBuffer }

shared object utf16 satisfies Charset {
    shared actual String name = "UTF-16";
    
    shared actual Integer minimumBytesPerCharacter = 2;
    shared actual Integer maximumBytesPerCharacter = 4;
    shared actual Integer averageBytesPerCharacter = 2;

    shared actual Decoder newDecoder(){
        return UTF16Decoder(this);
    }
    shared actual Encoder newEncoder() {
        // FIXME
        return bottom;
    }
}

class UTF16Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    variable Boolean needsMoreBytes := false;
    variable Integer firstByte := 0;

    variable Boolean needsLowSurrogate := false;
    variable Integer highSurrogate := 0;
    
    variable Boolean bigEndian := true;

    variable Boolean byteOrderMarkSeen := false;
    
    shared actual String done() {
        if(needsMoreBytes){
            // FIXME: type
            throw Exception("Invalid UTF-16 sequence: missing a byte");
        }
        if(needsLowSurrogate){
            // FIXME: type
            throw Exception("Invalid UTF-16 sequence: missing low surrogate");
        }
        return super.done();
    }
    
    Integer assembleBytes(Integer a, Integer b) { 
        if(bigEndian){
            return a.leftLogicalShift(8).or(b);
        }else{
            return a.or(b.leftLogicalShift(8));
        }
    }
    
    shared actual void decode(ByteBuffer buffer) {
        for(Integer byte in buffer){
            if(byte < 0 || byte > 255){
                // FIXME: type
                throw Exception("Invalid UTF-16 byte value: " byte "");
            }
            // are we looking at the first byte of a 16-bit word?
            if(!needsMoreBytes){
                // keep this byte in any case
                firstByte := byte;
                needsMoreBytes := true;
                continue;
            }
            // are we looking at the second byte?
            if(needsMoreBytes){
                Integer char;
                
                // assemble the two bytes
                Integer word = assembleBytes(firstByte, byte);
                needsMoreBytes := false;
                
                // are we looking at the first 16-bit word?
                if(!needsLowSurrogate){
                    // Single 16bit value
                    if(word < hex('D800') || word > hex('DFFF')){
                        // we got the char
                        char = word;
                    }else if(word > hex('DBFF')){
                        // FIXME: type
                        throw Exception("Invalid UTF-16 high surrogate value: " word "");
                    }else{
                        // we're waiting for the second half;
                        highSurrogate := word;
                        needsLowSurrogate := true;
                        continue;
                    }
                }else{
                    // we have the second 16-bit word, check it
                    if(word < hex('DC00') || word > hex('DFFF')){
                        // FIXME: type
                        throw Exception("Invalid UTF-16 low surrogate value: " word "");
                    }
                    // now assemble them
                    Integer part1 = highSurrogate.and(bin('1111111111')).leftLogicalShift(10);
                    Integer part2 = word.and(bin('1111111111'));
                    char = part1.or(part2) + (hex('10000'));
                    
                    needsLowSurrogate := false; 
                }

                // 0xFEFF is the Byte Order Mark in UTF8
                if(char == hex('FEFF') && builder.size == 0 && !byteOrderMarkSeen){
                    byteOrderMarkSeen := true;
                }else if(char == hex('FFFE') && builder.size == 0 && !byteOrderMarkSeen){
                    byteOrderMarkSeen := true;
                    bigEndian := false;
                }else{
                    builder.appendCharacter(char.character);
                }
            }
        }
    }
}
