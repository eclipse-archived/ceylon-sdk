import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer
}
import ceylon.buffer.codec {
    strict,
    EncodeException,
    ErrorStrategy,
    PieceConvert
}

"The ISO 8859-1 character set, as defined by [its specification]
 (http://www.iso.org/iso/catalogue_detail?csnumber=28245)."
by ("Stéphane Épardaud")
shared object iso_8859_1 satisfies Charset {
    shared actual [String+] aliases = [
        "ISO-8859-1",
        "ISO_8859-1:1987", // official name
        "iso-ir-100",
        "ISO_8859-1",
        "latin1",
        "l1",
        "IBM819",
        "CP819",
        "csISOLatin1",
        // idiot-proof aliases
        "iso-8859_1",
        "iso_8859_1",
        "iso8859-1",
        "iso8859_1",
        "latin-1",
        "latin_1"
    ];
    
    shared actual Integer averageEncodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumEncodeSize(Integer inputSize) => inputSize;
    shared actual Integer averageDecodeSize(Integer inputSize) => inputSize;
    shared actual Integer maximumDecodeSize(Integer inputSize) => inputSize;
    
    shared actual Integer decodeBid({Byte*} sample) => nothing;
    shared actual Integer encodeBid({Character*} sample) => nothing;
    
    shared actual PieceConvert<Byte,Character> pieceEncoder(ErrorStrategy error)
            => object satisfies PieceConvert<Byte,Character> {
        ByteBuffer output = ByteBuffer.ofSize(1);
        shared actual {Byte*} more(Character input) {
            output.clear();
            value int = input.integer;
            if (int > 255) {
                if (error == strict) {
                    throw EncodeException("Invalid ISO_8859-1 byte value: ``input``");
                }
            } else {
                output.put(int.byte);
            }
            output.flip();
            return output;
        }
    };
    
    shared actual PieceConvert<Character,Byte> pieceDecoder(ErrorStrategy error)
            => object satisfies PieceConvert<Character,Byte> {
        CharacterBuffer output = CharacterBuffer.ofSize(1);
        shared actual {Character*} more(Byte input) {
            output.clear();
            output.put(input.signed.character);
            output.flip();
            return output;
        }
    };
}
