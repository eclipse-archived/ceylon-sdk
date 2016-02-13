import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.charset {
    Charset
}

"Transforms a [consumer] method that accepts [[String]]s into a consumer method
 that accepts [[ByteBuffer]]s, according to the given [[charset]].
 
 Another way to see it is that this method returns a method which accepts
 [[ByteBuffer]] parameters, decodes them using the given [[charset]], and
 passes them on to the given [[consumer]] method which accepts decoded
 [[String]] objects."
by ("Stéphane Épardaud")
shared Anything(ByteBuffer) byteConsumerToStringConsumer
        (Charset charset, void consumer(String buffer)) {
    void translator(ByteBuffer buffer) {
        value decoded = charset.decode(buffer);
        if (!decoded.empty) {
            consumer(decoded);
        }
    }
    return translator;
}

"Transforms a [[string]] into a producer method that produces [[ByteBuffer]]s,
 according to the given [[charset]].
 
 Another way to see it is that this method returns a method which accepts
 [[ByteBuffer]] parameters, and fills them with the given [[string]], encoded
 using the given [[charset]]."
by ("Stéphane Épardaud")
shared Anything(ByteBuffer) stringToByteProducer
        (Charset charset, String string) {
    value encoder = charset.chunkEncoder();
    variable value firstCall = true;
    void producer(ByteBuffer buffer) {
        if (firstCall) {
            encoder.convert(buffer, string);
            firstCall = false;
        } else {
            encoder.convert(buffer, empty);
        }
    }
    return producer;
}
