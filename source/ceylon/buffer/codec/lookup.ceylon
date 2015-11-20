shared Map<String,CodecOrLower> buildCodecLookup<CodecOrLower>({CodecOrLower*} codecs)
        given CodecOrLower satisfies Codec {
    return map<String,CodecOrLower> {
        for (codec in codecs) for (codecAlias in codec.aliases) codecAlias->codec
    };
}

shared Map<String,Codec> codecsByAlias = buildCodecLookup(nothing);

shared Map<String,Charset> charsetsByAlias = buildCodecLookup(nothing);

// TODO single and multi-round bidding of IncrementalCodecs for a small sample. With hint/force param?

// TODO should be something like https://github.com/libarchive/libarchive/wiki/FormatDetection
// TODO eventually need to add Format for things like tar, as libarchive has. IncrementalCodec is equiv. to libarchive filter?
// TODO stream Formats probably be done here, but to actually exctract need to do I/O,
// TODO so addon functionality for that goes into ceylon.io.