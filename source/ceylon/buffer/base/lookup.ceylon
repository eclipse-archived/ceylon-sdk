import ceylon.buffer.codec {
    buildCodecLookup,
    CharacterToByteCodec,
    ByteToByteCodec
}

"A mapping of all supported String base variants.
 
 Currently this contains:
 
 - Base64 Standard
 - Base64 URL Safe
 - Base16
 "
shared Map<String,CharacterToByteCodec> baseStringByAlias = buildCodecLookup {
    base64StringStandard,
    base64StringUrl,
    base16String
};

"A mapping of all supported Byte base variants.
 
 Currently this contains:
 
 - Base64 Standard
 - Base64 URL Safe
 - Base16
 "
shared Map<String,ByteToByteCodec> baseByteByAlias = buildCodecLookup {
    base64ByteStandard,
    base64ByteUrl,
    base16Byte
};
