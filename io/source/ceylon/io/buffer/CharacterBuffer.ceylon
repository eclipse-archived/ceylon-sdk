
shared class CharacterBuffer(String string) extends Buffer<Character>(){
    shared actual Integer capacity = string.size;
    shared variable actual Integer limit := string.size;
    shared variable actual Integer position := 0;

    shared actual Boolean writable = false;

    shared actual void clear() {
        position := 0;
        limit := capacity;
    }

    shared actual void flip() {
        limit := position;
        position := 0;
    }

    shared actual Character get() {
        if(is Character c = string[position++]){
            return c;
        }
        // FIXME: type
        throw Exception("Buffer depleted");
    }

    shared actual void put(Character element) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
    
    shared actual void resize(Integer integer) {
        // FIXME: type
        throw Exception("Buffer is read-only");
    }
}

shared CharacterBuffer newCharacterBufferWithData(String data){
    return CharacterBuffer(data);
}
