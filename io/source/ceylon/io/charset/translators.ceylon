import ceylon.io.buffer { ByteBuffer, newCharacterBufferWithData, CharacterBuffer }
import ceylon.io.charset { Charset, Decoder }

doc "Transforms a [consumer] method that accepts [[String]]s into a consumer method
     that accepts [[ByteBuffer]]s, according to the given [[charset]].
     
     Another way to see it is that this method returns a method which accepts
     [[ByteBuffer]] parameters, decodes them using the given [[charset]],
     and passes them on to the given [[consumer]]
     method which accepts decoded [[String]] objects."
by "Stéphane Épardaud"
shared Callable<Void,ByteBuffer> byteConsumerToStringConsumer(Charset charset, void consumer(String buffer)){
    Decoder decoder = charset.newDecoder();
    void translator(ByteBuffer buffer){
        print("Translator called");
        decoder.decode(buffer);
        value decoded = decoder.consumeAvailable();
        if(exists decoded){
            consumer(decoded);
        }
    }
    return translator;
}

doc "Transforms a [[string]] into a producer method
     that produces [[ByteBuffer]]s, according to the given [[charset]].
     
     Another way to see it is that this method returns a method which accepts
     [[ByteBuffer]] parameters, and fills them with the given [[string]],
     encoded using the given [[charset]]."
by "Stéphane Épardaud"
shared Callable<Void,ByteBuffer> stringToByteProducer(Charset charset, String string){
    Encoder encoder = charset.newEncoder();
    CharacterBuffer input = newCharacterBufferWithData(string);
    void producer(ByteBuffer buffer){
        encoder.encode(input, buffer);
    }
    return producer;
}
