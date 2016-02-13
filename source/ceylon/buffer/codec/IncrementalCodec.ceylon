import ceylon.buffer {
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

shared class ChunkConvert<ToMutable, FromImmutable, ToSingle, FromSingle>(converter, error)
        given ToMutable satisfies Buffer<ToSingle>
        given FromImmutable satisfies {FromSingle*} {
    PieceConvert<ToSingle,FromSingle>(ErrorStrategy) converter;
    ErrorStrategy error;
    
    value pieceConverter = converter(error);
    
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

"Convert into a new buffer as portions arrive and return the buffer when the
 input is complete."
shared class CumulativeConvert<ToMutable, FromImmutable, ToSingle, FromSingle>(converter,
    error, sizeOf, inputSize, growthFactor, averageSize)
        given ToMutable satisfies Buffer<ToSingle>
        given FromImmutable satisfies {FromSingle*} {
    PieceConvert<ToSingle,FromSingle>(ErrorStrategy) converter;
    ErrorStrategy error;
    ToMutable(Integer) sizeOf;
    Integer? inputSize;
    Float growthFactor;
    Integer(Integer) averageSize;
    
    "Must be > 1 to allow for growth"
    assert (growthFactor > 1.0);
    
    value pieceConverter = converter(error);
    ToMutable output = sizeOf(if (exists inputSize) then averageSize(inputSize) else 0);
    
    void add(ToSingle element) {
        if (!output.hasAvailable) {
            output.resize(max { output.capacity * growthFactor, 64.0 }.integer, true);
        }
        output.put(element);
    }
    
    shared void more(FromImmutable input) {
        input.each((inputElement) => pieceConverter.more(inputElement).each(add));
    }
    
    shared ToMutable done() {
        pieceConverter.done().each(add);
        output.flip();
        return output;
    }
}

"Codecs that can process input into output in portions of the whole."
shared interface IncrementalCodec<ToMutable, ToImmutable, ToSingle,
    FromMutable, FromImmutable, FromSingle>
        satisfies StatelessCodec<ToMutable,ToImmutable,ToSingle,
                    FromMutable,FromImmutable,FromSingle>
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
    throws (`class EncodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal PieceConvert<ToSingle,FromSingle> pieceEncoder(ErrorStrategy error = strict);
    
    "Decodes one output piece to zero or more input pieces. This is mostly
     intended for refinement by subtypes. Higher level decode methods are
     provided for general use."
    throws (`class DecodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared formal PieceConvert<FromSingle,ToSingle> pieceDecoder(ErrorStrategy error = strict);
    
    "Encodes in portions dictated by the size of the output buffer, which will
     not be resized."
    throws (`class EncodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared ChunkConvert<ToMutable,{FromSingle*},ToSingle,FromSingle> chunkEncoder
            (ErrorStrategy error = strict)
            => ChunkConvert<ToMutable,{FromSingle*},ToSingle,FromSingle>(pieceEncoder, error);
    
    "Decodes in portions dictated by the size of the output buffer, which will
     not be resized."
    throws (`class DecodeException`,
        "When an error is encountered and [[error]] == [[strict]]")
    shared ChunkConvert<FromMutable,{ToSingle*},FromSingle,ToSingle> chunkDecoder
            (ErrorStrategy error = strict)
            => ChunkConvert<FromMutable,{ToSingle*},FromSingle,ToSingle>(pieceDecoder, error);
    
    "Encode into a new buffer as portions arrive and return the buffer when the
     input is complete. [[inputSize]] can be used to hint the expected total
     size of the input, to avoid resizing the output buffer unnecessarily."
    shared formal CumulativeConvert<ToMutable,{FromSingle*},ToSingle,FromSingle> cumulativeEncoder
            (Integer? inputSize = null, Float growthFactor = 1.5, ErrorStrategy error = strict);
    
    "Decode into a new buffer as portions arrive and return the buffer when the
     input is complete. [[inputSize]] can be used to hint the expected total
     size of the input, to avoid resizing the output buffer unnecessarily."
    shared formal CumulativeConvert<FromMutable,{ToSingle*},FromSingle,ToSingle> cumulativeDecoder
            (Integer? inputSize = null, Float growthFactor = 1.5, ErrorStrategy error = strict);
}
