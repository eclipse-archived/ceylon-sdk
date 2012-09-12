import ceylon.io.buffer { ByteBuffer, CharacterBuffer }

doc "Represents the ISO 8859-1 character set as defined 
     [by the specification](http://www.iso.org/iso/catalogue_detail?csnumber=28245)."
shared object iso_8859_1 satisfies Charset {
    
    doc "Returns `ISO-8859-1`. This deviates a bit from 
         [the internet registry](http://www.iana.org/assignments/character-sets) which defines it as
         `ISO_8859-1:1987`, whereas we use its _preferred MIME name_ because that is more widely known."
    shared actual String name = "ISO_8859-1";

    doc "The set of aliases, as defined by 
         [the internet registry](http://www.iana.org/assignments/character-sets). Note that
         because we use the _preferred MIME name_ (`ISO-8859-1`) as [[name]], we include the
         official character set name `ISO_8859-1:1987` in the aliases, thereby deviating
         from the spec."
    shared actual String[] aliases = {"iso-8859-1", "iso-8859_1", "iso_8859_1", "iso8859-1", "iso8859_1", "latin1", "latin-1", "latin_1"};

    doc "Returns 1."
    shared actual Integer minimumBytesPerCharacter = 1;

    doc "Returns 1."
    shared actual Integer maximumBytesPerCharacter = 1;
    
    doc "Returns 1."
    shared actual Integer averageBytesPerCharacter = 1;

    doc "Returns a new ISO-8859-1 decoder."
    shared actual Decoder newDecoder(){
        return ISO_8859_1Decoder(this);
    }

    doc "Returns a new ISO-8859-1 encoder."
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
