import ceylon.buffer.base64 {
    Base64String,
    Base64Byte,
    base64StringStandard,
    base64StringUrl,
    base64ByteStandard,
    base64ByteUrl
}
import ceylon.buffer {
    ByteBuffer
}

shared Map<String,CodecOrLower> buildCodecLookup<CodecOrLower>({CodecOrLower*} codecs)
        given CodecOrLower satisfies Codec {
    return map<String,CodecOrLower> {
        for (codec in codecs) for (codecAlias in codec.aliases) codecAlias->codec
    };
}

//shared Map<String,Codec> codecsByAlias = buildCodecLookup(nothing);
shared Map<String,Charset> charsetsByAlias = buildCodecLookup {
    utf8
};
shared Map<String,Base64String> base64StringByAlias = buildCodecLookup {
    base64StringStandard,
    base64StringUrl
};
shared Map<String,Base64Byte> base64ByteByAlias = buildCodecLookup {
    base64ByteStandard,
    base64ByteUrl
};

shared [IncrementalCodec<ToMutable,ToImmutable,ToSingle,FromMutable,FromImmutable,FromSingle>*]
buildAuction<ToMutable, ToImmutable, ToSingle, FromMutable, FromImmutable, FromSingle>
        ({IncrementalCodec<ToMutable,ToImmutable,ToSingle,
        FromMutable,FromImmutable,FromSingle>+} bidders)
        ({FromSingle*} lot) {
    value bids = map<Integer,
        IncrementalCodec<ToMutable,ToImmutable,ToSingle,FromMutable,FromImmutable,FromSingle>>
        { for (bidder in bidders) bidder.encodeBid(lot) -> bidder };
    return bids.sort(increasingKey)*.item;
}

shared [IncrementalCodec<ByteBuffer,Array<Byte>,Byte,
    ByteBuffer,Array<Byte>,Byte>*]({Byte*}) auctionByteToByteEncode = buildAuction {
    base64ByteStandard,
    base64ByteUrl
};

void asd() {
    value bytes = [0.byte];
    value results = auctionByteToByteEncode(bytes);
    assert(nonempty results);
    results.first.encode(bytes);
}

// TODO single and multi-round bidding of IncrementalCodecs for a small sample. With hint/force param?

// TODO should be something like https://github.com/libarchive/libarchive/wiki/FormatDetection
// TODO eventually need to add Format for things like tar, as libarchive has. IncrementalCodec is equiv. to libarchive filter?
// TODO stream Formats probably be done here, but to actually exctract need to do I/O,
// TODO so addon functionality for that goes into ceylon.io.
