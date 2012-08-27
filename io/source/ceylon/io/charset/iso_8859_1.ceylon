import ceylon.io.buffer { ByteBuffer }
shared object iso_8859_1 satisfies Charset {
    shared actual String name = "ISO_8859-1";
    shared actual Integer minimumBytesPerCharacter = 1;
    shared actual Integer maximumBytesPerCharacter = 1;
    shared actual Integer averageBytesPerCharacter = 1;

    shared actual Decoder newDecoder(){
        return ISO_8859_1Decoder(this);
    }
    shared actual Encoder newEncoder() {
        // FIXME
        return bottom;
    }
}

class ISO_8859_1Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    shared actual void decode(ByteBuffer buffer) {
        for(Integer byte in buffer){
            if(byte < 0 || byte > 255){
                // FIXME: type
                throw Exception("Invalid ISO_8859-1 byte value: " byte "");
            }
            builder.appendCharacter(byte.character);
        }
    }
}
