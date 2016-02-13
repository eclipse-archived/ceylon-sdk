import ceylon.buffer {
    Buffer
}

"Thrown by failed conversion operations"
shared class ConvertException(description = null, cause = null)
        extends Exception(description, cause) {
    String? description;
    Throwable? cause;
}
"Thrown by failed encode operations"
shared class EncodeException(description = null, cause = null)
        extends ConvertException(description, cause) {
    String? description;
    Throwable? cause;
}
"Thrown by failed decode operations"
shared class DecodeException(description = null, cause = null)
        extends ConvertException(description, cause) {
    String? description;
    Throwable? cause;
}

"Action to take when an error is encountered during encoding or decoding."
shared abstract class ErrorStrategy() of strict | ignore | reset {}
"Throw a [[ConvertException]]"
shared object strict extends ErrorStrategy() {}
"Continue without throwing an exception"
shared object ignore extends ErrorStrategy() {}
"Reset the internal state, then continue without throwing an exception"
shared object reset extends ErrorStrategy() {}

"Codecs that can take an input all at once, and return the output all at once."
shared interface StatelessCodec<ToMutable, ToImmutable, ToSingle,
    FromMutable, FromImmutable, FromSingle>
        satisfies Codec
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given FromMutable satisfies Buffer<FromSingle>
        given FromImmutable satisfies {FromSingle*} {
    
    "Encode all of [[input]], returning all of the output."
    throws (`class EncodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal ToImmutable encode({FromSingle*} input, ErrorStrategy error = strict);
    "Decode all of [[input]], returning all of the output."
    throws (`class DecodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal FromImmutable decode({ToSingle*} input, ErrorStrategy error = strict);
    
    "Encode all of [[input]] into a new buffer and return it."
    throws (`class EncodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal ToMutable encodeBuffer({FromSingle*} input, ErrorStrategy error = strict);
    
    "Decode all of [[input]] into a new buffer and return it."
    throws (`class DecodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal FromMutable decodeBuffer({ToSingle*} input, ErrorStrategy error = strict);
}
