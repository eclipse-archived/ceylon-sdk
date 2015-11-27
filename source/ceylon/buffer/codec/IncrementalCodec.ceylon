import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer,
    Buffer
}
import ceylon.collection {
    LinkedList
}

"Converts single pieces of input into output pieces"
shared interface PieceConvert<ToSingle, FromSingle> {
    shared formal {ToSingle*} more(FromSingle input);
    shared default {ToSingle*} done() => empty;
}

shared class ChunkConvert<ToMutable, FromImmutable, ToSingle, FromSingle>(pieceConverter)
        given ToMutable satisfies Buffer<ToSingle>
        given FromImmutable satisfies {FromSingle*} {
    PieceConvert<ToSingle,FromSingle> pieceConverter;
    
    value remainder = LinkedList<ToSingle>();
    shared Boolean done => remainder.empty;
    
    "Converts in portions dictated by the size of the output buffer, which will
     not be resized."
    shared Integer convert(ToMutable output, FromImmutable input) {
        // If there is remainder, write that first
        while (output.hasAvailable, exists element = remainder.pop()) {
            output.put(element);
        }
        if (!remainder.empty || !output.hasAvailable) {
            return 0;
        }
        
        // Don't use each() as we might need to stop before all of input is read
        variable Integer readCount = 0;
        for (inputElement in input) {
            readCount++;
            value elements = pieceConverter.more(inputElement).iterator();
            while (is ToSingle element = elements.next()) {
                if (output.hasAvailable) {
                    output.put(element);
                } else {
                    // Output is full, append to the remainder
                    remainder.offer(element);
                    while (is ToSingle remaining = elements.next()) {
                        remainder.offer(remaining);
                    }
                    return readCount;
                }
            }
        }
        return readCount;
    }
}

"Codecs that can process input into output in portions of the whole."
shared interface IncrementalCodec<ToMutable, ToImmutable, ToSingle,
    FromMutable, FromImmutable, FromSingle>
        satisfies StatelessCodec<ToImmutable,ToSingle,FromImmutable,FromSingle>
        given ToMutable satisfies Buffer<ToSingle>
        given ToImmutable satisfies {ToSingle*}
        given FromMutable satisfies Buffer<FromSingle>
        given FromImmutable satisfies {FromSingle*} {
    
    "The certainty that that the given [[sample]] is suitable for encoding with
     this codec.
     
     A number 1 or greater indicates that (based on the sample at
     least) the input should encode without error. The higher the number is
     beyond 1, the more appropriate this codec is likely to be."
    shared formal Integer encodeBid({FromSingle*} sample);
    "The certainty that that the given [[sample]] is suitable for decoding with
     this codec.
     
     A number 1 or greater indicates that (based on the sample at
     least) the input should decode without error. The higher the number is
     beyond 1, the more appropriate this codec is likely to be."
    shared formal Integer decodeBid({ToSingle*} sample);
    
    "Encodes one input piece to zero or more output pieces. This is mostly
     intended for refinement by subtypes. Higher level encode methods are
     provided for general use."
    shared formal PieceConvert<ToSingle,FromSingle> pieceEncoder(ErrorStrategy error = strict);
    "Decodes one output piece to zero or more input pieces. This is mostly
     intended for refinement by subtypes. Higher level decode methods are
     provided for general use."
    shared formal PieceConvert<FromSingle,ToSingle> pieceDecoder(ErrorStrategy error = strict);
    
    "Encodes in portions dictated by the size of the output buffer, which will
     not be resized."
    shared ChunkConvert<ToMutable,{FromSingle*},ToSingle,FromSingle> chunkEncoder(error = strict) {
        ErrorStrategy error;
        return ChunkConvert<ToMutable,{FromSingle*},ToSingle,FromSingle>(pieceEncoder(error));
    }
    "Decodes in portions dictated by the size of the output buffer, which will
     not be resized."
    shared ChunkConvert<FromMutable,{ToSingle*},FromSingle,ToSingle> chunkDecoder(error = strict) {
        ErrorStrategy error;
        return ChunkConvert<FromMutable,{ToSingle*},FromSingle,ToSingle>(pieceDecoder(error));
    }
    
    "Encode all of [[input]], writing the result into [[the provided
     buffer|into]]. The buffer will be resized if its too small to receive all
     of the output."
    shared void encodeInto(ToMutable into, {FromSingle*} input, ErrorStrategy error = strict) {
        void add(ToSingle element) {
            if (!into.hasAvailable) {
                into.resize(maximumEncodeSize(input.size), true);
            }
            into.put(element);
        }
        value pieceConverter = pieceEncoder(error);
        input.each(
            (FromSingle inputElement) => pieceConverter.more(inputElement).each(add)
        );
        pieceConverter.done().each(add);
    }
    "Decode all of [[input]], writing the result into [[the provided
     buffer|into]]. The buffer will be resized if its too small to receive all
     of the output."
    shared void decodeInto(FromMutable into, {ToSingle*} input, ErrorStrategy error = strict) {
        void add(FromSingle element) {
            if (!into.hasAvailable) {
                into.resize(maximumEncodeSize(input.size), true);
            }
            into.put(element);
        }
        value pieceConverter = pieceDecoder(error);
        input.each(
            (ToSingle inputElement) => pieceConverter.more(inputElement).each(add)
        );
        pieceConverter.done().each(add);
    }
}

"Common interface for Codecs that convert between bytes and bytes. Examples:
 gzip, and base64."
shared interface ByteToByteCodec
        satisfies IncrementalCodec<ByteBuffer,Array<Byte>,Byte,ByteBuffer,Array<Byte>,Byte> {
    
    shared actual default Array<Byte> encode({Byte*} input, ErrorStrategy error) {
        value buffer = ByteBuffer.ofSize(averageEncodeSize(input.size));
        encodeInto(buffer, input);
        return buffer.array;
    }
    shared actual default Array<Byte> decode({Byte*} input, ErrorStrategy error) {
        value buffer = ByteBuffer.ofSize(averageDecodeSize(input.size));
        decodeInto(buffer, input);
        return buffer.array;
    }
}

"Common interface for Codecs that convert between bytes and characters.
 Examples: utf8, ascii."
shared interface ByteToCharacterCodec
        satisfies IncrementalCodec<ByteBuffer,Array<Byte>,Byte,CharacterBuffer,String,Character> {
    
    shared actual default Array<Byte> encode({Character*} input, ErrorStrategy error) {
        value buffer = ByteBuffer.ofSize(averageEncodeSize(input.size));
        encodeInto(buffer, input);
        return buffer.array;
    }
    shared actual default String decode({Byte*} input, ErrorStrategy error) {
        value buffer = CharacterBuffer.ofSize(averageDecodeSize(input.size));
        decodeInto(buffer, input);
        return buffer.string;
    }
}

"Common interface for Codecs that convert between characters and bytes.
 Examples: base64."
shared interface CharacterToByteCodec
        satisfies IncrementalCodec<CharacterBuffer,String,Character,ByteBuffer,Array<Byte>,Byte> {
    
    shared actual default String encode({Byte*} input, ErrorStrategy error) {
        value buffer = CharacterBuffer.ofSize(averageEncodeSize(input.size));
        encodeInto(buffer, input);
        return buffer.string;
    }
    shared actual default Array<Byte> decode({Character*} input, ErrorStrategy error) {
        value buffer = ByteBuffer.ofSize(averageDecodeSize(input.size));
        decodeInto(buffer, input);
        return buffer.array;
    }
}


"Common interface for Codecs that convert between characters and characters.
 Examples: rot13."
shared interface CharacterToCharacterCodec
        satisfies IncrementalCodec<CharacterBuffer,String,Character,CharacterBuffer,String,Character> {
    shared actual default String encode({Character*} input, ErrorStrategy error) {
        value buffer = CharacterBuffer.ofSize(averageEncodeSize(input.size));
        encodeInto(buffer, input);
        return buffer.string;
    }
    shared actual default String decode({Character*} input, ErrorStrategy error) {
        value buffer = CharacterBuffer.ofSize(averageDecodeSize(input.size));
        decodeInto(buffer, input);
        return buffer.string;
    }
}
