
"Represents a read-only [[Character]] [[Buffer]] whose underlying data
 is read from the given [[string]]. This buffer starts ready to be read,
 with the [[position]] set to `0` and the [[limit]] set to size of the
 given [[string]]."
by("Stéphane Épardaud")
see(`class Buffer`,`function newCharacterBufferWithData`)
shared class CharacterBuffer(String string) extends Buffer<Character>(){
    
    "The size of the given [[string]]."
    shared actual Integer capacity = string.size;
    
    "Initially set to the [[string]] size."
    shared variable actual Integer limit = string.size;
    
    "The current position index within this buffer. Starts at `0`
     and grows with each [[get]] or [[put]] operation, until it reaches
     the [[limit]]."
    shared variable actual Integer position = 0;

    "Returns false. This buffer is read-only."
    shared actual Boolean writable = false;

    "Resets the [[position]] to `0` and the [[limit]] to the [[capacity]]. Use
     this after reading to start reading the whole buffer again."
    shared actual void clear() {
        position = 0;
        limit = capacity;
    }

    "This will and set its [[limit]] to the current [[position]],
     and reset its [[position]] to `0`. This essentially means that you will be able
     to read from the beginning of the buffer until the last object you read with [[get]]
     while reading."
    shared actual void flip() {
        limit = position;
        position = 0;
    }

    "Reads a [[Character]] from this buffer at the current [[position]].
     Increases the [[position]] by `1`."
    shared actual Character get() {
        if(is Character c = string[position++]){
            return c;
        }
        // FIXME: type
        throw Exception("Buffer depleted");
    }

    "Not supported"
    throws(`class Exception`,"Always")
    shared actual void put(Character element) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
    
    "Not supported"
    throws(`class Exception`,"Always")
    shared actual void resize(Integer newSize, Boolean growLimit) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
}

"Allocates a new [[CharacterBuffer]] with the underlying [[data]]."
by("Stéphane Épardaud")
see(`class CharacterBuffer`)
shared CharacterBuffer newCharacterBufferWithData(String data){
    return CharacterBuffer(data);
}
