import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    newByteBuffer
}

//shared class Accumulator<From, To>(chunkConverter, error = strict)
//        given From of String | ByteBuffer
//        given To of String | ByteBuffer {
//    To(From) chunkConverter;
//    ErrorStrategy error;
//    
//    shared formal void reset();
//    
//    shared formal void more(From chunk);
//    
//    shared formal To last(From? chunk = null);
//}

shared interface IncrementalCodec<EncodeForm, DecodeForm> {
    //        given EncodeForm of CharacterBuffer | ByteBuffer
    //        given DecodeForm of CharacterBuffer | ByteBuffer {
    
    // TODO need somthing that allows passing in e.g. an existing ByteBuffer for reuse
    //shared formal EncodeForm chunkEncoder(DecodeForm chunk);
    //shared formal DecodeForm chunkDecoder(EncodeForm chunk);
    
    shared formal void encodeInto(EncodeForm into, DecodeForm chunk);
    shared formal void decodeInto(EncodeForm into, DecodeForm chunk);
    
    shared formal Integer encodeBid(DecodeForm sample);
    shared formal Integer decodeBid(EncodeForm sample);
    
    //shared formal EncodeForm encode(DecodeForm input, ErrorStrategy error)
    //        => encoder(error).last(input);
    //shared formal DecodeForm decode(EncodeForm input, ErrorStrategy error)
    //        => decoder(error).last(input);
    
    //shared Accumulator<DecodeForm,EncodeForm> encoder(ErrorStrategy error = strict)
    //        => Accumulator(encodeInto, error);
    //shared Accumulator<EncodeForm,DecodeForm> decoder(ErrorStrategy error = strict)
    //        => Accumulator((EncodeForm x) => decode(x, error));
}


// TODO forget about Stateless/IncrementalCodec interfaces for now, try to develop these three seperately then extract common later if possible

// ex: compressors (gzip, etc.), ascii binary conversions (base64, base16, etc.)
shared interface ByteToByte satisfies Codec {
    shared Array<Byte> encode({Byte*} input, ErrorStrategy error = strict) {
        return nothing;
    }
    
    shared void encodeInto(ByteBuffer into, {Byte*} input, ErrorStrategy error = strict, Boolean grow = false) {
    }
    
    shared Array<Byte> decode({Byte*} input, ErrorStrategy error = strict) {
        return nothing;
    }
    
    shared void decodeInto(ByteBuffer into, {Byte*} input, ErrorStrategy error = strict, Boolean grow = false) {
    }
}

// this is also CharacterToByte
// ex: charsets (utf8, etc.), ascii string representations (base64, base16, etc.)
shared interface ByteToCharacter satisfies Codec {
    //satisfies IncrementalCodec<ByteBuffer,CharacterBuffer> & // or String or StringBuilder?
    //        StatelessCodec<ByteBuffer,String> {
    shared Array<Byte> encode({Character*} input, ErrorStrategy error = strict) {
        // TODO can we simplify ByteBuffer/ByteBufferImpl, so we don't need newByteBuffer?
        value buffer = newByteBuffer(input.size * averageForwardRatio);
        encodeInto {
            into = buffer;
            input = input;
            grow = true;
        };
        // TODO need to add array output to ByteBuffer
        return buffer.array;
    }
    
    // TODO return how many bytes (or characters??) were able to be added to into?
    shared void encodeInto(ByteBuffer into, {Character*} input, ErrorStrategy error = strict, Boolean grow = false) {
        if (grow || input.size<=into.available) {
            input.each(
                void(Character character) {
                }
            );
        } else {
            // TODO have to stop early, so use for loop instead
        }
    }
    
    shared String decode({Byte*} input, ErrorStrategy error = strict) {
        // TODO need to rewrite CharacterBuffer
        value buffer = CharacterBuffer(input.size / averageForwardRatio);
        decodeInto {
            into = buffer;
            input = input;
            grow = true;
        };
        return buffer.string;
    }
    
    shared void decodeInto(CharacterBuffer into, {Byte*} input, ErrorStrategy error = strict, Boolean grow = false) {
        if (grow || input.size<=into.available) {
            input.each(
                void(Byte byte) {
                }
            );
        } else {
            // TODO have to stop early, so use for loop instead
        }
    }
}

void asd() {
    ByteToCharacter c = nothing;
    ByteBuffer bb = nothing;
    CharacterBuffer cb = nothing;
    c.encode(cb);
    c.encode("");
    c.decode(bb);
    c.decode(Array { 1.byte });
}

// ex: rot13
shared interface CharacterToCharacter satisfies Codec {
//        satisfies IncrementalCodec<CharacterBuffer,CharacterBuffer> &
//                StatelessCodec<String,String> {
    shared Array<Byte> encode({Character*} input, ErrorStrategy error = strict) {
        return nothing;
    }
    
    shared void encodeInto(CharacterBuffer into, {Character*} input, ErrorStrategy error = strict, Boolean grow = false) {
    }
    
    shared Array<Byte> decode({Character*} input, ErrorStrategy error = strict) {
        return nothing;
    }
    
    shared void decodeInto(CharacterBuffer into, {Character*} input, ErrorStrategy error = strict, Boolean grow = false) {
    }
}
