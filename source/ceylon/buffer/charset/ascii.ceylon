import ceylon.buffer {
    ByteBuffer,
    CharacterBuffer
}
import ceylon.buffer.codec {
    ErrorStrategy,
    PieceConvert,
    DecodeException,
    strict,
    EncodeException
}

"The ASCII character set, as defined by [its specification]
 (http://tools.ietf.org/html/rfc20)."
by ("Stéphane Épardaud")
shared object ascii satisfies Charset {
    shared actual [String+] aliases = [
        "us-ascii",
        "ansi_X3.4-1968",
        "iso-ir-6",
        "ansi_X3.4-1986",
        "iso_646.irv:1991",
        "iso646-US",
        "ascii",
        "us",
        "ibm367",
        "cp367"
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
            if (int > 127) {
                if (error == strict) {
                    throw EncodeException("Invalid ASCII byte value: ``input``");
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
            if (input.signed < 0) {
                if (error == strict) {
                    throw DecodeException("Invalid ASCII byte value: ``input``");
                }
            } else {
                output.put(input.signed.character);
            }
            output.flip();
            return output;
        }
    };
}
