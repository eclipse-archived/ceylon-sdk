import ceylon.io.buffer { ByteBuffer, CharacterBuffer }
shared object iso_8859_1 satisfies Charset {
    shared actual String name = "ISO_8859-1";

    shared actual String[] aliases = {"iso-8859-1", "iso-8859_1", "iso_8859_1", "iso8859-1", "iso8859_1", "latin1", "latin-1", "latin_1"};

    shared actual Integer minimumBytesPerCharacter = 1;
    shared actual Integer maximumBytesPerCharacter = 1;
    shared actual Integer averageBytesPerCharacter = 1;

    shared actual Decoder newDecoder(){
        return ISO_8859_1Decoder(this);
    }
    shared actual Encoder newEncoder() {
        return ISO_8859_1Encoder(this);
    }
}

class ISO_8859_1Encoder(charset) satisfies Encoder {
    shared actual Charset charset;
    
    shared actual void encode(CharacterBuffer input, ByteBuffer output) {
        // give up if there's no input or no room for output
        while(input.hasAvailable && output.hasAvailable){
            value char = input.get().integer;
            if(char > 255){
                // FIXME: type
                throw Exception("Invalid ISO_8859-1 byte value: " char "");
            }
            output.put(char);
        }
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
