import ceylon.io.buffer { newByteBuffer, ByteBuffer, CharacterBuffer, newCharacterBufferWithData }

shared interface Charset {
    shared formal Decoder newDecoder();
    shared formal String name;
    
    shared formal Encoder newEncoder();
    
    shared formal Integer minimumBytesPerCharacter;
    shared default Integer maximumBytesPerCharacter {
        return minimumBytesPerCharacter;
    }
    shared default Integer averageBytesPerCharacter {
        return (maximumBytesPerCharacter - minimumBytesPerCharacter) / 2 + minimumBytesPerCharacter;
    }
    
    shared ByteBuffer encode(String string){
        value output = newByteBuffer(string.size * averageBytesPerCharacter);
        value input = newCharacterBufferWithData(string);
        value encoder = newEncoder();
        while(input.hasAvailable){
            // grow the output buffer if our estimate turned out wrong
            if(!output.hasAvailable){
                output.resize(string.size * maximumBytesPerCharacter);
            }
            encoder.encode(input, output);
        }
        // flip and return
        output.flip();
        return output;
    }
    
    shared String decode(ByteBuffer buffer){
        value decoder = newDecoder();
        decoder.decode(buffer);
        return decoder.done();
    }
}

shared interface Encoder {
    shared formal Charset charset;
    shared formal void encode(CharacterBuffer input, ByteBuffer output);
}

shared interface Decoder {
    shared formal Charset charset;
    shared formal void decode(ByteBuffer buffer);
    shared formal String? consumeAvailable();
    shared formal String done();
}





