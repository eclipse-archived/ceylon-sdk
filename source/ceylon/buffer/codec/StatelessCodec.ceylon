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
shared abstract class ErrorStrategy() of strict | ignore {}
"Throw a [[ConvertException]]"
shared object strict extends ErrorStrategy() {}
"Attempt to continue without throwing an exception"
shared object ignore extends ErrorStrategy() {}

"Codecs that can take an input all at once, and return the output all at once."
shared interface StatelessCodec<ToImmutable, ToSingle, FromImmutable, FromSingle>
        satisfies Codec
        given ToImmutable satisfies {ToSingle*}
        given FromImmutable satisfies {FromSingle*} {
    
    "Encode all of [[input]], returning all of the output."
    shared formal ToImmutable encode({FromSingle*} input, ErrorStrategy error = strict);
    "Decode all of [[input]], returning all of the output."
    shared formal FromImmutable decode({ToSingle*} input, ErrorStrategy error = strict);
}
