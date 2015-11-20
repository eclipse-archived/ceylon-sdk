import ceylon.buffer {
    ByteBuffer
}


shared abstract class Base64Byte()
        satisfies IncrementalCodec<ByteBuffer, ByteBuffer>{
    // TODO direct to ascii byte encoding, since b64 charset is within ascii and usually needs to be written out
}

shared abstract class Base64String()
        satisfies IncrementalCodec<ByteBuffer, String>{
}