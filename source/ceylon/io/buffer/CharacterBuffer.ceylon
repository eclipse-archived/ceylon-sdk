import ceylon.io.buffer.impl { StringBackedCharacterBufferImpl, CharacterBufferImpl }

"Represents a buffer of characters.
 
 You can create new instances with [[newCharacterBuffer]] (empty) and
 [[newCharacterBufferWithData]] (wrapping a [[String]])."
by("Stéphane Épardaud")
see(`class Buffer`,
`function newByteBuffer`,
`function newByteBufferWithData`)
shared abstract class CharacterBuffer() extends Buffer<Character>(){
	shared formal Array<Character> characters();
	
	"The platform-specific implementation object, if any."
	shared formal Object? implementation;
}

"Allocates a new empty [[CharacterBuffer]] with the given [[capacity]]."
by("Stephen Crawley")
see(`class CharacterBuffer`,
    `function newCharacterBufferWithData`,
    `class Buffer`)
shared CharacterBuffer newCharacterBuffer(Integer capacity){
    return CharacterBufferImpl(capacity);
}

"Allocates a new [[CharacterBuffer]] with the underlying [[data]]."
by("Stéphane Épardaud")
see(`class CharacterBuffer`)
shared CharacterBuffer newCharacterBufferWithData(String data){
    return StringBackedCharacterBufferImpl(data);
}
