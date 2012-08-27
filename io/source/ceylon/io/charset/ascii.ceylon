import ceylon.io.buffer { ByteBuffer, CharacterBuffer }
shared object ascii satisfies Charset {
    shared actual String name = "ASCII";
    shared actual Integer minimumBytesPerCharacter = 1;
    shared actual Integer maximumBytesPerCharacter = 1;
    shared actual Integer averageBytesPerCharacter = 1;

    shared actual Decoder newDecoder(){
        return ASCIIDecoder(this);
    }
    shared actual Encoder newEncoder() {
        return ASCIIEncoder(this);
    }
}

class ASCIIDecoder(charset) extends AbstractDecoder() {
    shared actual Charset charset;

    shared actual void decode(ByteBuffer buffer) {
        for(Integer byte in buffer){
            if(byte < 0 || byte > 127){
                // FIXME: type
                throw Exception("Invalid ASCII byte value: " byte "");
            }
            builder.appendCharacter(byte.character);
        }
    }
}

class ASCIIEncoder(charset) satisfies Encoder {
    shared actual Charset charset;
    
    shared actual void encode(CharacterBuffer input, ByteBuffer output) {
        // give up if there's no input or no room for output
        while(input.hasAvailable && output.hasAvailable){
            value char = input.get().integer;
            if(char > 127){
                // FIXME: type
                throw Exception("Invalid ASCII byte value: " char "");
            }
            output.put(char);
        }
    }

}

