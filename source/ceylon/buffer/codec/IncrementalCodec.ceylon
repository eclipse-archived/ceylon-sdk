import ceylon.buffer {
    ByteBuffer
}

shared class Accumulator<From, To>(chunkConverter, error = strict)
        given From of String | ByteBuffer
        given To of String | ByteBuffer {
    To(From) chunkConverter;
    ErrorStrategy error;
    
    shared formal void reset();
    
    shared formal void more(From chunk);
    
    shared formal To last(From? chunk = null);
}

shared interface IncrementalCodec<EncodeForm, DecodeForm>
        satisfies StatelessCodec<EncodeForm,DecodeForm>
        given EncodeForm of StringBuilder | ByteBuffer
        given DecodeForm of StringBuilder | ByteBuffer {
    
    // TODO need somthing that allows passing in e.g. an existing ByteBuffer for reuse
    //shared formal EncodeForm chunkEncoder(DecodeForm chunk);
    //shared formal DecodeForm chunkDecoder(EncodeForm chunk);
    
    shared Integer encodeInto(EncodeForm into, DecodeForm chunk) {
        
        return nothing;
    }
    shared Integer decodeInto(EncodeForm into, DecodeForm chunk) {
        
        return nothing;
    }
    
    shared formal Integer encodeBid(DecodeForm sample);
    shared formal Integer decodeBid(EncodeForm sample);

    //shared formal EncodeForm encode(DecodeForm input, ErrorStrategy error)
    //        => encoder(error).last(input);
    //shared formal DecodeForm decode(EncodeForm input, ErrorStrategy error)
    //        => decoder(error).last(input);
    
    shared actual default EncodeForm encode(DecodeForm input, ErrorStrategy error)
            => encoder(error).last(input);
    shared actual default DecodeForm decode(EncodeForm input, ErrorStrategy error)
            => decoder(error).last(input);
    
    shared Accumulator<DecodeForm,EncodeForm> encoder(ErrorStrategy error = strict)
            => Accumulator(encodeInto, error);
    shared Accumulator<EncodeForm,DecodeForm> decoder(ErrorStrategy error = strict)
            => Accumulator((EncodeForm x) => decode(x, error));
    
}
