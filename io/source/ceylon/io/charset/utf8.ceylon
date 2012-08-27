import ceylon.io.buffer { newByteBuffer, ByteBuffer }

shared object utf8 satisfies Charset {
    shared actual String name = "UTF-8";
    shared actual Integer minimumBytesPerCharacter = 1;
    shared actual Integer maximumBytesPerCharacter = 4;
    shared actual Integer averageBytesPerCharacter = 2;

    shared actual Decoder newDecoder(){
        return UTF8Decoder(this);
    }
    shared actual Encoder newEncoder() {
        // FIXME
        return bottom;
    }
}

class UTF8Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    variable Integer needsMoreBytes := 0;
    ByteBuffer bytes = newByteBuffer(3);
    variable Boolean byteOrderMarkSeen := false;
    
    shared actual String done() {
        if(needsMoreBytes > 0){
            // type
            throw Exception("Invalid UTF-8 sequence: missing " needsMoreBytes " bytes");
        }
        return super.done();
    }
    
    shared actual void decode(ByteBuffer buffer) {
        for(Integer byte in buffer){
            if(byte < 0 || byte > 255){
                // FIXME: type
                throw Exception("Invalid UTF-8 byte value: " byte "");
            }
            // are we looking at the first byte?
            if(needsMoreBytes == 0){
                // 0b0000 0000 <= byte < 0b1000 0000
                if(byte < hex('80')){
                    // one byte
                    builder.appendCharacter(byte.character);
                    continue;
                }
                // invalid range
                if(byte < bin('11000000')){
                    // FIXME: type
                    throw Exception("Invalid UTF-8 byte value: " byte "");
                }
                // invalid range
                if(byte >= bin('11111000')){
                    throw Exception("Invalid UTF-8 first byte value: " byte "");
                }
                // keep this byte in any case
                bytes.put(byte);
                if(byte < bin('11100000')){
                    needsMoreBytes := 1;
                    continue;
                }
                if(byte < bin('11110000')){
                    needsMoreBytes := 2;
                    continue;
                }
                // 0b1111 0000 <= byte < 0b1111 1000
                if(byte < bin('11111000')){
                    needsMoreBytes := 3;
                    continue;
                }
            }
            // if we got this far, we must have a second byte at least
            if(byte < bin('10000000') || byte >= bin('11000000')){
                // FIXME: type
                throw Exception("Invalid UTF-8 second byte value: " byte "");
            }
            if(--needsMoreBytes > 0){
                // not enough bytes
                bytes.put(byte);
                continue;
            }
            // we have enough bytes! they are all in the bytes buffer except the last one
            // they have all been checked already
            bytes.flip();
            Integer char;
            if(bytes.available == 1){
                Integer part1 = bytes.get().and(bin('00011111'));
                Integer part2 = byte.and(bin('00111111'));
                char = part1.leftLogicalShift(6)
                    .or(part2);
            }else if(bytes.available == 2){
                Integer part1 = bytes.get().and(bin('00001111'));
                Integer part2 = bytes.get().and(bin('00111111'));
                Integer part3 = byte.and(bin('00111111'));
                char = part1.leftLogicalShift(12)
                    .or(part2.leftLogicalShift(6))
                    .or(part3);
            }else{
                Integer part1 = bytes.get().and(bin('00000111'));
                Integer part2 = bytes.get().and(bin('00111111'));
                Integer part3 = bytes.get().and(bin('00111111'));
                Integer part4 = byte.and(bin('00111111'));
                char = part1.leftLogicalShift(18)
                    .or(part2.leftLogicalShift(12))
                    .or(part3.leftLogicalShift(6))
                    .or(part4);
            }
            // 0xFEFF is the Byte Order Mark in UTF8
            if(char == hex('FEFF') && builder.size == 0 && !byteOrderMarkSeen){
                byteOrderMarkSeen := true;
            }else{
                builder.appendCharacter(char.character);
            }
            // needsMoreBytes is already 0
            // bytes needs to be reset
            bytes.clear();
        }
    }
}
