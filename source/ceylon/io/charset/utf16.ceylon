import ceylon.io.buffer { ByteBuffer, newByteBuffer, CharacterBuffer }

doc "Represents a UTF-16 character set as defined by
     (the specification)[http://www.ietf.org/rfc/rfc2781.txt].
     
     Decoders for UTF-16 will properly recognize `BOM` 
     (_byte order mark_) markers for both big and little endian
     encodings, but encoders will generate big-endian UTF-16 with
     no `BOM` markers."
by "Stéphane Épardaud"
shared object utf16 satisfies Charset {
    
    doc "Returns `UTF-16`."
    shared actual String name = "UTF-16";

    doc "Returns a list of common aliases such as `utf16` and `utf_16` even
         though these are not defined officially as aliases by
         [the internet registry](http://www.iana.org/assignments/character-sets)."
    shared actual String[] aliases = {"utf16", "utf_16"};
    
    doc "Returns 2."
    shared actual Integer minimumBytesPerCharacter = 2;

    doc "Returns 4."
    shared actual Integer maximumBytesPerCharacter = 4;

    doc "Returns 2."
    shared actual Integer averageBytesPerCharacter = 2;

    doc "Returns a new UTF-16 decoder."
    shared actual Decoder newDecoder(){
        return UTF16Decoder(this);
    }

    doc "Returns a new UTF-16 encoder."
    shared actual Encoder newEncoder() {
        return UTF16Encoder(this);
    }
}

class UTF16Encoder(charset) satisfies Encoder {
    
    shared actual Charset charset;
    ByteBuffer bytes = newByteBuffer(3);
    // set its limit to 0 for reading
    bytes.flip();

    shared actual Boolean done {
        return !bytes.hasAvailable;
    }

    shared actual void encode(CharacterBuffer input, ByteBuffer output) {
        // give up if there's no input or no room for output
        while((input.hasAvailable || bytes.hasAvailable) && output.hasAvailable){
            // first flush our buffer
            if(bytes.hasAvailable){
                output.put(bytes.get());
            }else{
                // now read from input
                value codePoint = input.get().integer;
                // how many bytes?
                if(codePoint < hex('10000')){
                    // single 16-bit value
                    // two bytes
                    value b1 = codePoint.and(hex('FF00')).rightLogicalShift(8);
                    value b2 = codePoint.and(hex('FF'));
                    output.put(b1);
                    // save it for later
                    bytes.clear();
                    bytes.put(b2);
                    bytes.flip();
                }else if(codePoint < hex('10FFFF')){
                    // two 16-bit values
                    value u = codePoint - hex('10000');
                    // keep the high 10 bits
                    value high = u.and(bin('11111111110000000000')).rightLogicalShift(10).or(hex('D800'));
                    // and the low 10 bits
                    value low = u.and(bin('1111111111')).or(hex('DC00'));
                    // now turn them into four bytes
                    value b1 = high.and(hex('FF00')).rightLogicalShift(8);
                    value b2 = high.and(hex('FF'));
                    value b3 = low.and(hex('FF00')).rightLogicalShift(8);
                    value b4 = low.and(hex('FF'));
                    output.put(b1);
                    // save it for later
                    bytes.clear();
                    bytes.put(b2);
                    bytes.put(b3);
                    bytes.put(b4);
                    bytes.flip();
                }else{
                    // FIXME: type
                    throw Exception("Invalid unicode code point");
                }
            }
        }
    }
}


class UTF16Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    variable Boolean needsMoreBytes = false;
    variable Integer firstByte = 0;

    variable Boolean needsLowSurrogate = false;
    variable Integer highSurrogate = 0;
    
    variable Boolean bigEndian = true;

    variable Boolean byteOrderMarkSeen = false;
    
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
                firstByte = byte;
                needsMoreBytes = true;
                continue;
            }
            // are we looking at the second byte?
            if(needsMoreBytes){
                Integer char;
                
                // assemble the two bytes
                Integer word = assembleBytes(firstByte, byte);
                needsMoreBytes = false;
                
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
                        highSurrogate = word;
                        needsLowSurrogate = true;
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
                    
                    needsLowSurrogate = false; 
                }

                // 0xFEFF is the Byte Order Mark in UTF8
                if(char == hex('FEFF') && builder.size == 0 && !byteOrderMarkSeen){
                    byteOrderMarkSeen = true;
                }else if(char == hex('FFFE') && builder.size == 0 && !byteOrderMarkSeen){
                    byteOrderMarkSeen = true;
                    bigEndian = false;
                }else{
                    builder.appendCharacter(char.character);
                }
            }
        }
    }
}
