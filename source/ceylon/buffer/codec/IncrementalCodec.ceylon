import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer
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

// TODO have these three as the subtypes of Codec, and forget about Stateless/IncrementalCodec interfaces?

// ex: compressors (gzip, etc.), ascii binary conversions (base64, base16, etc.)
shared interface ByteToByte
        satisfies IncrementalCodec<ByteBuffer,ByteBuffer> &
                StatelessCodec<ByteBuffer,ByteBuffer> {
}

// this is also CharacterToByte
// ex: charsets (utf8, etc.), ascii string representations (base64, base16, etc.)
shared interface ByteToCharacter
        satisfies IncrementalCodec<ByteBuffer,CharacterBuffer> & // or String or StringBuilder?
                StatelessCodec<ByteBuffer,String> {
}

// ex: rot13
shared interface CharacterToCharacter
        satisfies IncrementalCodec<CharacterBuffer,CharacterBuffer> &
                StatelessCodec<String,String> {
}
