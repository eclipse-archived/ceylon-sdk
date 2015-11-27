import ceylon.buffer.codec {
    buildCodecLookup
}

"A mapping of all supported character sets.
 
 Currently this lists contains:
 
 - ASCII
 - ISO 8859 1
 - UTF-8
 - UTF-16
 "
shared Map<String,Charset> charsetsByAlias = buildCodecLookup {
    utf8
};
