import ceylon.io.buffer { ByteBuffer, CharacterBuffer }

"Represents the ISO 8859-1 character set as defined 
 [by the specification](http://www.iso.org/iso/catalogue_detail?csnumber=28245)."
by("Stéphane Épardaud")
shared object iso_8859_1 satisfies Charset {
    
    "Returns `ISO-8859-1`. This deviates a bit from 
     [the internet registry](http://www.iana.org/assignments/character-sets) which defines it as
     `ISO_8859-1:1987`, whereas we use its _preferred MIME name_ because that is more widely known."
    shared actual String name = "ISO-8859-1";

    "The set of aliases, as defined by 
     [the internet registry](http://www.iana.org/assignments/character-sets). Note that
     because we use the _preferred MIME name_ (`ISO-8859-1`) as [[name]], we include the
     official character set name `ISO_8859-1:1987` in the aliases, thereby deviating
     from the spec."
    shared actual String[] aliases = [
        "ISO_8859-1:1987", // official name
        "iso-ir-100",
        "ISO_8859-1",
        "latin1",
        "l1",
        "IBM819",
        "CP819",
        "csISOLatin1",
        // idiot-proof aliases
        "iso-8859_1", 
        "iso_8859_1", 
        "iso8859-1", 
        "iso8859_1", 
        "latin-1", 
        "latin_1"
    ];

    "Returns 1."
    shared actual Integer minimumBytesPerCharacter = 1;

    "Returns 1."
    shared actual Integer maximumBytesPerCharacter = 1;
    
    "Returns 1."
    shared actual Integer averageBytesPerCharacter = 1;

    "Returns a new ISO-8859-1 decoder."
    shared actual Decoder newDecoder()
            => ISO_8859_1Decoder(this);

    "Returns a new ISO-8859-1 encoder."
    shared actual Encoder newEncoder() 
            => ISO_8859_1Encoder(this);
}

class ISO_8859_1Encoder(charset) satisfies Encoder {
    shared actual Charset charset;
    
    shared actual void encode(CharacterBuffer input, ByteBuffer output) {
        // give up if there's no input or no room for output
        while(input.hasAvailable && output.hasAvailable){
            value char = input.get().integer;
            if(char > 255){
                // FIXME: type
                throw Exception("Invalid ISO_8859-1 byte value: `` char ``");
            }
            output.put(char.byte);
        }
    } 
}

class ISO_8859_1Decoder(charset) extends AbstractDecoder()  {
    shared actual Charset charset;
    
    shared actual void decode(ByteBuffer buffer) {
        for(byte in buffer){
            builder.appendCharacter(byte.unsigned.character);
        }
    }
}
