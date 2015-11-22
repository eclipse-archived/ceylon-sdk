import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    newByteBuffer,
    Buffer
}

shared class UncompletedPiecewiseException(description = null, cause = null)
        extends Exception(description, cause) {
    String? description;
    Throwable? cause;
}

shared interface Piecewise<ToSingle, FromSingle> satisfies Destroyable {
    throws (`class UncompletedPiecewiseException`)
    shared formal void checkComplete();
    shared formal {ToSingle*} more(FromSingle input);
}

shared interface IncrementalCodec<ToMutable, ToImmutable, ToSingle,
    FromMutable, FromImmutable, FromSingle>
        satisfies StatelessCodec<ToImmutable,ToSingle,FromImmutable,FromSingle>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given FromMutable satisfies Buffer<FromSingle>
        given FromImmutable satisfies {FromSingle*} {
    
    shared formal Piecewise<ToSingle,FromSingle> encoder();
    shared formal Piecewise<FromSingle,ToSingle> decoder();
    
    shared formal Integer encodeInto(ToMutable into, {FromSingle*} input,
        ErrorStrategy error = strict, Boolean grow = false);
    
    shared formal Integer decodeInto(FromMutable into, {ToSingle*} input,
        ErrorStrategy error = strict, Boolean grow = false);
    
    shared formal Integer encodeBid({FromSingle*} sample);
    shared formal Integer decodeBid({ToSingle*} sample);
}

// ex: compressors (gzip, etc.), ascii binary conversions (base64, base16, etc.)
shared interface ByteToByteCodec
        satisfies IncrementalCodec<ByteBuffer,Array<Byte>,Byte,ByteBuffer,Array<Byte>,Byte> {
}

// this is also CharacterToByte
// ex: charsets (utf8, etc.), ascii string representations (base64, base16, etc.)
shared interface ByteToCharacterCodec
        satisfies IncrementalCodec<ByteBuffer,Array<Byte>,Byte,CharacterBuffer,String,Character> {
    
    shared actual default Array<Byte> encode({Character*} input, ErrorStrategy error) {
        // TODO can we simplify ByteBuffer/ByteBufferImpl, so we don't need newByteBuffer?
        value buffer = newByteBuffer(input.size * averageForwardRatio);
        encodeInto {
            into = buffer;
            input = input;
            grow = true;
        };
        // TODO need to add array output to ByteBuffer, copy on write for efficency?
        return buffer.array;
    }
    
    shared actual Integer encodeInto(into, input, error, grow) {
        ByteBuffer into;
        {Character*} input;
        ErrorStrategy error;
        Boolean grow;
        
        Piecewise<Byte,Character> piecewise = encoder();
        variable Integer readCount = 0;
        void process(Character character) {
            value bytes = piecewise.more(character);
            bytes.each(
                void(Byte byte) {
                    readCount++;
                    if (!into.hasAvailable) {
                        into.resize(input.size * maximumForwardRatio, true);
                    }
                    into.put(byte);
                }
            );
        }
        
        if (grow || into.available >= input.size*maximumForwardRatio) {
            // There is room to process all of input, so use each()
            input.each(process);
        } else {
            // Don't use each() as we might need to stop before all of input is read
            value iter = input.iterator();
            while (into.hasAvailable, is Character character = iter.next()) {
                process(character);
            }
        }
        // TODO is throwing the correct thing to do? might need something that persists the buffer?
        piecewise.checkComplete();
        return readCount;
    }
    
    shared actual default String decode({Byte*} input, ErrorStrategy error) {
        // TODO need to rewrite CharacterBuffer
        value buffer = CharacterBuffer(input.size / averageForwardRatio);
        decodeInto {
            into = buffer;
            input = input;
            grow = true;
        };
        return buffer.string;
    }
    
    shared actual Integer decodeInto(CharacterBuffer into, {Byte*} input, ErrorStrategy error, Boolean grow) {
        Piecewise<Character,Byte> piecewise = decoder();
        variable Integer readCount = 0;
        if (grow || into.available >= input.size*maximumForwardRatio) {
            input.each(
                void(Byte byte) {
                }
            );
        } else {
            // TODO have to stop early, so use for loop instead
        }
        // TODO maybe return the unused bytes instead?
        piecewise.checkComplete();
        return readCount;
    }
}

// ex: rot13
shared interface CharacterToCharacterCodec
        satisfies IncrementalCodec<CharacterBuffer,String,Character,CharacterBuffer,String,Character> {
}
