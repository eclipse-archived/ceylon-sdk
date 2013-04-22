
doc "Represents a read-only [[Character]] [[Buffer]] whose underlying data
     is read from the given [[string]]. This buffer starts ready to be read,
     with the [[position]] set to `0` and the [[limit]] set to size of the
     given [[string]]."
by "Stéphane Épardaud"
see (Buffer, newCharacterBufferWithData)
shared class CharacterBuffer(String string) extends Buffer<Character>(){
    
    doc "The size of the given [[string]]."
    shared actual Integer capacity = string.size;
    
    doc "Initially set to the [[string]] size."
    shared variable actual Integer limit = string.size;
    
    doc "The current position index within this buffer. Starts at `0`
         and grows with each [[get]] or [[put]] operation, until it reaches
         the [[limit]]."
    shared variable actual Integer position = 0;

    doc "Returns false. This buffer is read-only."
    shared actual Boolean writable = false;

    doc "Resets the [[position]] to `0` and the [[limit]] to the [[capacity]]. Use
         this after reading to start reading the whole buffer again."
    shared actual void clear() {
        position = 0;
        limit = capacity;
    }

    doc "This will and set its [[limit]] to the current [[position]],
         and reset its [[position]] to `0`. This essentially means that you will be able
         to read from the beginning of the buffer until the last object you read with [[get]]
         while reading."
    shared actual void flip() {
        limit = position;
        position = 0;
    }

    doc "Reads a [[Character]] from this buffer at the current [[position]].
         Increases the [[position]] by `1`."
    shared actual Character get() {
        if(is Character c = string[position++]){
            return c;
        }
        // FIXME: type
        throw Exception("Buffer depleted");
    }

    doc "Not supported"
    throws(Exception,"Always")
    shared actual void put(Character element) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
    
    doc "Not supported"
    throws(Exception,"Always")
    shared actual void resize(Integer newSize, Boolean growLimit) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
}

doc "Allocates a new [[CharacterBuffer]] with the underlying [[data]]."
by "Stéphane Épardaud"
see (CharacterBuffer)
shared CharacterBuffer newCharacterBufferWithData(String data){
    return CharacterBuffer(data);
}
