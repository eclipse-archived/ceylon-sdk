import ceylon.io.buffer { ByteBuffer }

shared interface Reader {
    formal shared Integer read(ByteBuffer buffer);
}