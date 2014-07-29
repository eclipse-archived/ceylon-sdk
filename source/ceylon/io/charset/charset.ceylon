import ceylon.io.buffer {
    newByteBuffer,
    ByteBuffer,
    CharacterBuffer,
    newCharacterBufferWithData
}

"Represents a character set, which allows you to convert 
 characters to bytes and back.
 
 You can get the list of available character sets with 
 [[charsets]] and get a character set by name (or alias) 
 with [[getCharset]]."
by("Stéphane Épardaud")
shared interface Charset {
    
    "The name of the character set. In general this is the 
     _preferred MIME name_ as defined by [the internet registry][],
     rather than the official standard name of the character
     set, which we add to the aliases.
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared formal String name;

    "Returns a list of aliases for this character set, as 
     defined by [the internet registry][].
     
     [the internet registry]: http://www.iana.org/assignments/character-sets"
    shared default String[] aliases {
        return [];
    }

    "Returns a new [[Decoder]] which allows you to decode 
     byte buffers into characters."
    shared formal Decoder newDecoder();

    "Returns a new [[Encoder]] which allows you to encode 
     characters into byte buffers."
    shared formal Encoder newEncoder();

    "The minimum number of bytes taken when encoding a 
     character into bytes."    
    shared formal Integer minimumBytesPerCharacter;

    "The maximum number of bytes taken when encoding a 
     character into bytes.
     Defaults to [[minimumBytesPerCharacter]]."    
    shared default Integer maximumBytesPerCharacter {
        return minimumBytesPerCharacter;
    }

    "The average number of bytes taken when encoding a 
     character into bytes. Defaults to the average of 
     [[minimumBytesPerCharacter]] and 
     [[maximumBytesPerCharacter]]."
    shared default Integer averageBytesPerCharacter 
            => (maximumBytesPerCharacter - minimumBytesPerCharacter) 
                    / 2 + minimumBytesPerCharacter;
    
    "Encodes the given [[string]] into a newly-created 
     [[ByteBuffer]]. This is a convenience method."
    shared ByteBuffer encode(String string){
        value output = newByteBuffer(string.size * averageBytesPerCharacter);
        value input = newCharacterBufferWithData(string);
        value encoder = newEncoder();
        while(input.hasAvailable || !encoder.done){
            // grow the output buffer if our estimate turned out wrong
            if(!output.hasAvailable){
                output.resize(string.size * maximumBytesPerCharacter, true);
            }
            encoder.encode(input, output);
        }
        // flip and return
        output.flip();
        return output;
    }
    
    "Decodes the given [[ByteBuffer]] into a newly-created 
     [[String]]. This is a convenience method."
    shared String decode(ByteBuffer buffer){
        value decoder = newDecoder();
        decoder.decode(buffer);
        return decoder.done();
    }
}

"Encodes a sequence of characters into a sequence of bytes."
by("Stéphane Épardaud")
shared interface Encoder {
    
    "The character set for this encoder."
    shared formal Charset charset;
    
    "Returns true if there are no bytes pending to be output. 
     Returns false if there are some characters that were 
     read but could not yet be entirely output due to output 
     buffer availability."
    shared default Boolean done {
        return true;
    }
    
    "Encodes the given [[input]] character buffer into the 
     given [[output]] byte buffer. Attempts to encode as 
     many characters as are available and fit in the output 
     buffer."
    shared formal void encode(CharacterBuffer input, 
        ByteBuffer output);
}

"Decodes a sequence of bytes into a sequence of characters."
by("Stéphane Épardaud")
shared interface Decoder {

    "The character set for this decoder."
    shared formal Charset charset;

    "Decodes the given byte [[buffer]] into an underlying 
     character buffer. Attempts to decode as many bytes as 
     are available."
    shared formal void decode(ByteBuffer buffer);

    "Returns a [[String]] consisting of all the decoded 
     characters so far. Returns `null` if there are no 
     decoded characters yet."
    shared formal String? consumeAvailable();

    "Returns a [[String]] consisting of all the decoded 
     characters so far. Returns `null` if there are no 
     decoded characters yet."
    throws(`class Exception`,
        "If there were not enough bytes decoded to finish 
         decoding the last character.")
    shared formal String done();
}
