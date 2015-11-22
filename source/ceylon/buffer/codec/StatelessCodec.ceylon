shared class ConvertException(description = null, cause = null)
        extends Exception(description, cause) {
    String? description;
    Throwable? cause;
}
shared class EncodeException(description = null, cause = null)
        extends ConvertException(description, cause) {
    String? description;
    Throwable? cause;
}
shared class DecodeException(description = null, cause = null)
        extends ConvertException(description, cause) {
    String? description;
    Throwable? cause;
}

shared abstract class ErrorStrategy() of strict | ignore {}
shared object strict extends ErrorStrategy() {}
shared object ignore extends ErrorStrategy() {}

shared interface StatelessCodec<ToImmutable, ToSingle, FromImmutable, FromSingle>
        satisfies Codec
        given ToImmutable satisfies {ToSingle*}
        given FromImmutable satisfies {FromSingle*} {
    
    shared formal ToImmutable encode({FromSingle*} input, ErrorStrategy error = strict);
    shared formal FromImmutable decode({ToSingle*} input, ErrorStrategy error = strict);
}
