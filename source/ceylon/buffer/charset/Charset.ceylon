import ceylon.buffer.codec {
    ByteToCharacterCodec
}

"A character set, which allows you to convert characters to bytes and back.
 
 You can find a character set by a String alias with [[charsetsByAlias]]"
shared interface Charset satisfies ByteToCharacterCodec {
}
