import ceylon.buffer.codec {
    buildCodecLookup
}

"A mapping of all supported String base64 variants.
 
 Currently this lists contains:
 
 - Standard
 - URL Safe
 "
shared Map<String,Base64String> base64StringByAlias = buildCodecLookup {
    base64StringStandard,
    base64StringUrl
};

"A mapping of all supported Byte base64 variants.
 
 Currently this lists contains:
 
 - Standard
 - URL Safe
 "
shared Map<String,Base64Byte> base64ByteByAlias = buildCodecLookup {
    base64ByteStandard,
    base64ByteUrl
};