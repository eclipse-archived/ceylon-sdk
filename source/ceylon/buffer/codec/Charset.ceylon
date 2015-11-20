import ceylon.buffer {
    ByteBuffer
}

// TODO probably should move to the charset sibling package, once ready

shared class Charset()
        satisfies IncrementalCodec<String,ByteBuffer> {
}
