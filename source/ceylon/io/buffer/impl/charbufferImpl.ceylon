import ceylon.io.buffer { Buffer, CharacterBuffer, newCharacterBufferWithData }
import java.nio { JavaCharBuffer=CharBuffer{ allocateJavaCharBuffer = allocate } }
import java.lang { CharArray }

"Represents a mutable [[Character]] [[Buffer]] backed by a Java CharBuffer."
by("Stéphane Épardaud", "Stephen Crawley")
shared class CharacterBufferImpl(Integer initialCapacity) extends CharacterBuffer(){
	variable JavaCharBuffer buf = allocateJavaCharBuffer(initialCapacity);
	shared JavaCharBuffer underlyingBuffer {
		return buf;
	}
	
	shared actual Integer capacity {
		return buf.capacity();
	}
	shared actual Integer limit {
		return buf.limit();
	}
	assign limit {
		buf.limit(limit);
	}
	shared actual Integer position {
		return buf.position();
	}
	assign position {
		buf.position(position);
	}
	shared actual Character get() {
		return buf.get();
	}
	shared actual void put(Character char) {
		buf.put(char);
	}
	shared actual void clear() {
		buf.clear();
	}
	shared actual void flip() {
		buf.flip();
	}
	
	shared actual void resize(Integer newSize, Boolean growLimit) {
		if(newSize == capacity){
			return;
		}
		if(newSize < 0){
			// FIXME: type
			throw;
		}
		JavaCharBuffer dest = allocateJavaCharBuffer(newSize);
		// save our position and limit
		value position = min([this.position, newSize]);
		Integer limit;
		if(newSize < capacity){
			// shrink the limit
			limit = min([this.limit, newSize]);
		}else if(growLimit && this.limit == capacity){
			// grow the limit if it was the max and we want that
			limit = newSize;
		}else{
			// keep it if it was less than max
			limit = this.limit;
		}
		// copy everything unless we shrink
		value copyUntil = min([this.capacity, newSize]);
		// prepare our limits for copying
		buf.position(0);
		buf.limit(copyUntil);
		// copy
		dest.put(buf);
		// change buffer
		buf = dest;
		// now restore positions
		buf.limit(limit);
		buf.position(position);
	}
	
	shared actual Array<Character> characters() {
		value nativeArray = buf.array();
		value size = nativeArray.size;
		value result = arrayOfSize<Character>(size, ' ');
		variable value i=0;
		while (i<size) {
			result.set(i, nativeArray.get(i));
			i++;
		}
		return result;
	}
	
	shared actual Object? implementation => underlyingBuffer;
	
}

"Represents a read-only [[Character]] [[Buffer]] whose underlying data
 is read from the given [[string]]. This buffer starts ready to be read,
 with the [[position]] set to `0` and the [[limit]] set to size of the
 given [[string]]."
by("Stéphane Épardaud")
see(`class Buffer`,`function newCharacterBufferWithData`)
shared class StringBackedCharacterBufferImpl(String string) extends CharacterBuffer() {
    
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
    
    shared actual Array<Character> characters() {
        return Array<Character>(string.characters);
    }
    
    shared actual Object? implementation => string;
}
