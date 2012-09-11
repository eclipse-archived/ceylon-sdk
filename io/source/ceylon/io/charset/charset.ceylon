import ceylon.io.buffer { newByteBuffer, ByteBuffer, CharacterBuffer, newCharacterBufferWithData }

doc "Represents a character set, which allows you to convert characters to bytes
     and back.
     
     You can get the list of available character sets with [[charsets]] and
     get a character set by name (or alias) with [[getCharset]]."
shared interface Charset {
    
    doc "This character set's name."
    shared formal String name;

    doc "Returns this character set's name."
    shared default String[] aliases {
        return {};
    }

    doc "Returns a new [[Decoder]] which allows you to decode byte buffers
         into characters."
    shared formal Decoder newDecoder();

    doc "Returns a new [[Encoder]] which allows you to encode characters
         into byte buffers."
    shared formal Encoder newEncoder();

    doc "The minimum number of bytes taken when encoding a character into bytes."    
    shared formal Integer minimumBytesPerCharacter;

    doc "The maximum number of bytes taken when encoding a character into bytes.
         Defaults to [[minimumBytesPerCharacter]]."    
    shared default Integer maximumBytesPerCharacter {
        return minimumBytesPerCharacter;
    }

    doc "The average number of bytes taken when encoding a character into bytes.
         Defaults to the average of [[minimumBytesPerCharacter]] and [[maximumBytesPerCharacter]]."
    shared default Integer averageBytesPerCharacter {
        return (maximumBytesPerCharacter - minimumBytesPerCharacter) / 2 + minimumBytesPerCharacter;
    }
    
    doc "Encodes the given [[string]] into a newly-created [[ByteBuffer]]. This is a convenience method."
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
    
    doc "Decodes the given [[ByteBuffer]] into a newly-created [[String]]. This is a convenience method."
    shared String decode(ByteBuffer buffer){
        value decoder = newDecoder();
        decoder.decode(buffer);
        return decoder.done();
    }
}

doc "Allows you to encode a sequence of characters into a sequence of bytes."
shared interface Encoder {
    
    doc "The character set for this encoder."
    shared formal Charset charset;
    
    doc "Returns true if there are no bytes pending to be output. Returns false
         if there are some characters that were read but could not yet be
         entirely output due to output buffer availability."
    shared default Boolean done {
        return true;
    }
    
    doc "Encodes the given [[input]] character buffer into the given [[output]]
         byte buffer. Attempts to encode as many characters as are available
         and fit in the output buffer."
    shared formal void encode(CharacterBuffer input, ByteBuffer output);
}

doc "Allows you to decode a sequence of bytes into a sequence of characters."
shared interface Decoder {

    doc "The character set for this decoder."
    shared formal Charset charset;

    doc "Decodes the given byte [[buffer]] into an underlying character buffer.
         Attempts to decode as many bytes as are available."
    shared formal void decode(ByteBuffer buffer);

    doc "Returns a [[String]] consisting of all the decoded characters so far.
         Returns `null` if there are no decoded characters yet."
    shared formal String? consumeAvailable();

    doc "Returns a [[String]] consisting of all the decoded characters so far.
         Returns `null` if there are no decoded characters yet."
    throws "If there were not enough bytes decoded to finish decoding the last
            character."
    shared formal String done();
}
