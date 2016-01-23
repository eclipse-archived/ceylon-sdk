import ceylon.buffer.codec {
    buildCodecLookup
}

"A mapping of all supported character sets.
 
 Currently this contains:
 
 - ASCII
 - ISO 8859 1
 - UTF-8
 - UTF-16
 "
shared Map<String,Charset> charsetsByAlias = buildCodecLookup {
    utf8,
    utf16,
    iso_8859_1,
    ascii
};
