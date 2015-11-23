import ceylon.buffer {
    Buffer,
    CharacterBuffer
}

shared class CharacterBufferTests() extends BufferTests<Character>() {
    shared actual Buffer<Character>(Array<Character>) bufferOfArray = CharacterBuffer.ofArray;
    shared actual Buffer<Character>({Character*}) bufferOfData = CharacterBuffer;
    shared actual Buffer<Character>(Integer) bufferOfSize = CharacterBuffer.ofSize;
    
    shared actual Array<Character> zeroSizeSample => Array<Character> { };
    shared actual Array<Character> oneSizeSample => Array { 'a' };
    shared actual Array<Character> twoSizeSample => Array { 'a', 'Z' };
    shared actual Array<Character> threeSizeSample => Array { 'W', 'n', 'A' };
    shared actual Array<Character> largeSample
            => Array { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        'p', 'q', 'r', 's', 't', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'B', 'E', 'F', 'G', 'H', 'I',
        'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
}
