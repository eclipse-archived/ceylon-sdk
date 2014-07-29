import java.nio { JavaByteBuffer = ByteBuffer { allocateJavaByteBuffer = allocate }}
import ceylon.io.buffer { ByteBuffer }
import ceylon.interop.java { toByteArray }


shared class ByteBufferImpl(Integer initialCapacity) extends ByteBuffer(){
    variable JavaByteBuffer buf = allocateJavaByteBuffer(initialCapacity);
    shared JavaByteBuffer underlyingBuffer {
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
    shared actual Byte get() {
        return buf.get();
    }
    shared actual void put(Byte byte) {
        buf.put(byte);
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
        JavaByteBuffer dest = allocateJavaByteBuffer(newSize);
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
    shared actual Array<Byte> bytes() {
        return toByteArray(buf.array());
    }
    
    shared actual Object? implementation => underlyingBuffer;

}

