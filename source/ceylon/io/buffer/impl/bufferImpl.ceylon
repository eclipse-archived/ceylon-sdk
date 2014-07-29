import java.nio { JavaByteBuffer = ByteBuffer { allocateJavaByteBuffer = allocate }}
import ceylon.io.buffer { ByteBuffer }
import ceylon.interop.java { toByteArray }


shared class ByteBufferImpl(Integer initialCapacity) extends ByteBuffer(){
    
    variable JavaByteBuffer buf = allocateJavaByteBuffer(initialCapacity);
    shared JavaByteBuffer underlyingBuffer => buf;
    
    capacity => buf.capacity();
    
    shared actual Integer limit => buf.limit();
    assign limit => buf.limit(limit);
    
    shared actual Integer position => buf.position();
    assign position => buf.position(position);
    
    get() => buf.get();
    put(Byte byte) => buf.put(byte);
    clear() => buf.clear();
    flip() => buf.flip();
    
    shared actual void resize(Integer newSize, Boolean growLimit) {
        if(newSize == capacity){
            return;
        }
        if(newSize < 0){
            // FIXME: type
            throw;
        }
        JavaByteBuffer dest = allocateJavaByteBuffer(newSize);
        // save our position and limit
        value position = smallest(this.position, newSize);
        Integer limit;
        if(newSize < capacity){
            // shrink the limit
            limit = smallest(this.limit, newSize);
        }else if(growLimit && this.limit == capacity){
            // grow the limit if it was the max and we want that
            limit = newSize;
        }else{
            // keep it if it was less than max
            limit = this.limit;
        }
        // copy everything unless we shrink
        value copyUntil = smallest(this.capacity, newSize);
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
    
    shared actual Array<Byte> bytes() {
        //TODO: could it be buf.array().byteArray
        //downside: that exposes the internal state
        //of the underyling Java buffer
        return toByteArray(buf.array());
    }
    
    shared actual Object? implementation => underlyingBuffer;
    
}

