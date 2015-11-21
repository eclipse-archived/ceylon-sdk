import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    newByteBuffer,
    Buffer
}

shared interface IncrementalCodec<ToMutable, ToImmutable, ToSingle,
    FromMutable, FromImmutable, FromSingle>
        satisfies StatelessCodec<ToImmutable,ToSingle,FromImmutable,FromSingle>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given FromMutable satisfies Buffer<FromSingle>
        given FromImmutable satisfies {FromSingle*} {
    
    // TODO return Integer?
    shared formal void encodeInto(ToMutable into, {FromSingle*} input,
        ErrorStrategy error = strict, Boolean grow = false);
    
    // TODO return Integer?
    shared formal void decodeInto(FromMutable into, {ToSingle*} input,
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
    
    shared actual Array<Byte> encode({Character*} input, ErrorStrategy error) {
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
    
    // TODO leave encodeInto/decodeInto as formal (is that the smallest unit of functionality subtypes can implement)?
    
    //shared actual void encodeInto(ByteBuffer into, {Character*} input, ErrorStrategy error, Boolean grow) {
    //    if (grow || input.size<=into.available) {
    //        input.each(
    //            void(Character character) {
    //            }
    //        );
    //    } else {
    //        // TODO have to stop early, so use for loop instead
    //    }
    //}
    
    shared actual String decode({Byte*} input, ErrorStrategy error) {
        // TODO need to rewrite CharacterBuffer
        value buffer = CharacterBuffer(input.size / averageForwardRatio);
        decodeInto {
            into = buffer;
            input = input;
            grow = true;
        };
        return buffer.string;
    }
    
    //shared actual void decodeInto(CharacterBuffer into, {Byte*} input, ErrorStrategy error, Boolean grow) {
    //    if (grow || input.size<=into.available) {
    //        input.each(
    //            void(Byte byte) {
    //            }
    //        );
    //    } else {
    //        // TODO have to stop early, so use for loop instead
    //    }
    //}
}

// ex: rot13
shared interface CharacterToCharacterCodec
        satisfies IncrementalCodec<CharacterBuffer,String,Character,CharacterBuffer,String,Character> {
}
