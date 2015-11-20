import ceylon.buffer {
    ByteBuffer
}

shared abstract class ErrorStrategy() of strict | ignore {}
shared object strict extends ErrorStrategy() {}
shared object ignore extends ErrorStrategy() {}

shared interface StatelessCodec<EncodeForm, DecodeForm>
        satisfies Codec {
//        given EncodeForm of String | ByteBuffer
//        given DecodeForm of String | ByteBuffer {
    
    shared formal EncodeForm encode(DecodeForm input, ErrorStrategy error = strict);
    shared formal DecodeForm decode(EncodeForm input, ErrorStrategy error = strict);
}
