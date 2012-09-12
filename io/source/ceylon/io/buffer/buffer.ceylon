
doc "Represents a memory buffer that can be read and written to with no
     allocation. The easiest way to get an idea of what a buffer is, is that
     it constists in an array of a given [[capacity]], a [[position]] index within the 
     array, and a [[limit]] index.
     
     Typical operations on a buffer will be to fill it, which you do with [[put]]
     until you reach the [[limit]].
     
     Then if you want to read the data you just put in the buffer, you [[flip]] the
     buffer, which will and set its [[limit]] to the current [[position]],
     and reset its [[position]] to `0`. This essentially means that you will be able
     to read from the beginning of the buffer until the last object you [[put]] in
     it when writing.
     
     You can then start calling [[get]] to read objects from this buffer until you
     reach its [[limit]].
     
     Once you are done reading from the buffer, you will [[clear]] the buffer to start
     writing to it again. That will reset the [[position]] to `0` and the [[limit]]
     to the [[capacity]], allowing you to write to the full underlying array.
     
     Buffers can be resized (grown and expanded), which will cause an underlying
     array reallocation and copy.
     "
by "Stéphane Épardaud"
see (ByteBuffer, newByteBuffer, newByteBufferWithData,
     CharacterBuffer, newCharacterBufferWithData)
shared abstract class Buffer<T>() satisfies Iterable<T> {
    
    doc "The current position index within this buffer. Starts at `0`
         and grows with each [[get]] or [[put]] operation, until it reaches
         the [[limit]]."
    shared formal variable Integer position;
    
    doc "The underlying array maximum capacity. Both the [[position]] and
         [[limit]] cannot exceed the capacity. You can [[resize]] the array
         to change the [[capacity]]."
    shared formal Integer capacity;
    
    doc "The limit at which to stop reading and writing. The limit will always
         be greater or equal to the [[position]] and smaller or equal to the
         [[capacity]]."
    shared formal variable Integer limit;

    doc "Resizes the underlying array, by growing or shrinking it. This implies
         a new array allocation and copy. 
         
         The [[position]] will only be affected
         if the [[newSize]] is smaller than the [[position]], in which case the
         [[position]] will be reset down to the [[newSize]] (at the end of the
         buffer).
         
         The [[limit]] will be brought down to the [[newSize]] if it would
         otherwise exceed it (when shrinking the buffer below the old [[limit]]),
         effectively making the new [[limit]] be at the end of the buffer.
         
         If you are growing the array, the [[limit]] will not be changed unless
         the optional parameter [[growLimit]] is set to `true` (defaults to `false`),
         because when you are writing it makes sense to grow the limit, but when
         you are reading it usually does not, as growing a buffer does not generate
         new meaningfull data."
    shared formal void resize(Integer newSize, Boolean growLimit = false);

    doc "Returns `true` if this buffer is writable, or `false` if it is read-only."
    shared default Boolean writable = true;
    
    doc "Returns `true` if the current [[position]] is smaller than the [[limit]]."
    shared Boolean hasAvailable {
        return available > 0;
    }
    
    doc "Returns the number of objects that can be read/written from the current
         [[position]] until we reach the [[limit]]."
    shared Integer available {
        return limit - position;
    }
    
    doc "Reads an object from this buffer at the current [[position]].
         Increases the [[position]] by `1`."
    shared formal T get();

    doc "Writes an object to this buffer at the current [[position]].
         Increases the [[position]] by `1`."
    shared formal void put(T element);

    doc "Resets the [[position]] to `0` and the [[limit]] to the [[capacity]]. Use
         this after reading to start writing to a clear buffer."
    shared formal void clear();

    doc "Flips this buffer after a write operation, so that it is ready to be read.
         
         This will and set its [[limit]] to the current [[position]],
         and reset its [[position]] to `0`. This essentially means that you will be able
         to read from the beginning of the buffer until the last object you [[put]] in
         it when writing."
    shared formal void flip();
    
    doc "Returns an [[Iterator]] object to read from the current [[position]] until the
         [[limit]]. This iterator modifies the buffer directly, so you will need to
         [[clear]] or [[flip]] it afterwards if you wish to iterate it again."
    shared actual Iterator<T> iterator {
        object it satisfies Iterator<T> {
            shared actual T|Finished next() {
                if(hasAvailable){
                    return get();
                }
                return exhausted;
            }
        }
        return it;
    } 
}
