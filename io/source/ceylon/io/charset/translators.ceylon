import ceylon.io.buffer { ByteBuffer, newCharacterBufferWithData, CharacterBuffer }
import ceylon.io.charset { Charset, Decoder }

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


shared Callable<Void,ByteBuffer> stringToByteProducer(Charset charset, String string){
    Encoder encoder = charset.newEncoder();
    CharacterBuffer input = newCharacterBufferWithData(string);
    void producer(ByteBuffer buffer){
        print("Translator called");
        encoder.encode(input, buffer);
    }
    return producer;
}
