import ceylon.io.buffer {
    ByteBuffer,
    CharacterBuffer
}
import ceylon.collection {
    StringBuilder
}

"Implementation of the ASCII character set. See 
 [the ASCII specification][] for more information.
 
 [the ASCII specification]: http://tools.ietf.org/html/rfc20"
by("Stéphane Épardaud")
shared object ascii satisfies Charset {
    
    "Returns `US-ASCII`. This deviates a bit from 
     [the internet registry][] which defines it as
     `ANSI_X3.4-1968`, whereas we use its _preferred MIME 
     name_ because that is more widely known.
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String name = "US-ASCII";

    "The set of aliases, as defined by [the internet registry][]. 
     Note that because we use the _preferred MIME name_ 
     (`US-ASCII`) as [[name]], we include the official 
     character set name `ANSI_X3.4-1968` in the aliases, 
     thereby deviating from the spec.
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared actual String[] aliases = [
        "ANSI_X3.4-1968",
        "iso-ir-6",
        "ANSI_X3.4-1986",
        "ISO_646.irv:1991",
        "ISO646-US",
        "ASCII",
        "us",
        "IBM367",
        "cp367"
    ];

    "Returns 1."
    shared actual Integer minimumBytesPerCharacter => 1;
    
    "Returns 1."
    shared actual Integer maximumBytesPerCharacter => 1;

    "Returns 1."
    shared actual Integer averageBytesPerCharacter => 1;

    shared actual class Decoder() 
            extends super.Decoder() {
        
        value builder = StringBuilder();
        
        shared actual void decode(ByteBuffer buffer) {
            for(byte in buffer) {
                if(byte.signed < 0) {
                    // FIXME: type
                    throw Exception("Invalid ASCII byte value: ``byte``");
                }
                builder.appendCharacter(byte.signed.character);
            }
        }

        shared actual String consume() {
            value result = builder.string;
            builder.clear();
            return result;
        }
    }
    
    shared actual class Encoder() 
            extends super.Encoder() {
        
        shared actual void encode(CharacterBuffer input, ByteBuffer output) {
            // give up if there's no input or no room for output
            while(input.hasAvailable && output.hasAvailable) {
                value char = input.get().integer;
                if(char > 127) {
                    // FIXME: type
                    throw Exception("Invalid ASCII byte value: ``char``");
                }
                output.putByte(char.byte);
            }
        }
        
    }
}


