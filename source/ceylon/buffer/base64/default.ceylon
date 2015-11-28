import ceylon.buffer.codec {
    ErrorStrategy,
    strict
}

"Short form of calling `encode` from [[base64ByteStandard]]"
shared Array<Byte> base64Encode({Byte*} input, ErrorStrategy error = strict)
        => base64ByteStandard.encode(input, error);

"Short form of calling `decode` from [[base64ByteStandard]]"
shared Array<Byte> base64Decode({Byte*} input, ErrorStrategy error = strict)
        => base64ByteStandard.decode(input, error);

"Short form of calling `encode` from [[base64StringStandard]]"
shared String base64EncodeString({Byte*} input, ErrorStrategy error = strict)
        => base64StringStandard.encode(input, error);

"Short form of calling `decode` from [[base64StringStandard]]"
shared Array<Byte> base64DecodeString({Character*} input, ErrorStrategy error = strict)
        => base64StringStandard.decode(input, error);
