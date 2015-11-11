import ceylon.buffer {
    newByteBuffer,
    ByteBuffer
}
import ceylon.buffer.readers {
    Reader
}
import ceylon.interop.java {
    javaByteArray
}

import java.nio {
    JavaByteBuffer=ByteBuffer {
        allocateJavaByteBuffer=allocate
    }
}

shared native class ByteBufferImpl(Integer initialCapacity) extends ByteBuffer() {
    shared actual native Integer capacity;
    shared actual native void clear();
    shared actual native void flip();
    shared actual native Byte get();
    shared actual native Byte getByte();
    shared actual native Object? implementation;
    shared actual native variable Integer limit;
    shared actual native variable Integer position;
    shared actual native void put(Byte element);
    shared actual native void putByte(Byte byte);
    shared actual native void resize(Integer newSize, Boolean growLimit);
}

shared native ("js") class ByteBufferImpl(Integer initialCapacity) extends ByteBuffer() {
    variable Array<Byte> buf = Array.ofSize(initialCapacity, 0.byte);
    
    shared actual native ("js") Integer capacity => buf.size;
    
    variable Integer _position = 0;
    shared actual native ("js") Integer position => _position;
    // Have to define assign for position after limit due to circular dependency
    
    variable Integer _limit = initialCapacity;
    shared actual native ("js") Integer limit => _limit;
    native ("js") assign limit {
        // Limit must be non-negative and no larger than capacity
        assert (limit >= 0);
        assert (limit <= capacity);
        // Position must be be no larger than the limit
        if (position > limit) {
            position = limit;
        }
        _limit = limit;
    }
    
    native ("js") assign position {
        // Position must be non-negative and no larger than limit
        assert (position >= 0);
        assert (position <= limit);
        _position = position;
    }
    
    shared actual native ("js") Byte get() {
        value byte = buf.get(position);
        assert (exists byte); // i.e. position < limit
        position++;
        return byte;
    }
    shared actual native ("js") void put(Byte element) {
        buf.set(position, element);
        position++;
    }
    
    shared actual native ("js") Byte getByte() => get();
    shared actual native ("js") void putByte(Byte byte) => put(byte);
    
    shared actual native ("js") void clear() {
        position = 0;
        limit = capacity;
    }
    
    shared actual native ("js") void flip() {
        limit = position;
        position = 0;
    }
    
    shared actual native ("js") void resize(Integer newSize, Boolean growLimit) {
        if (newSize == capacity) {
            return;
        }
        if (newSize < 0) {
            // FIXME: type
            throw;
        }
        value dest = Array.ofSize(newSize, 0.byte);
        // save our position and limit
        value position = smallest(this.position, newSize);
        Integer limit;
        if (newSize < capacity) {
            // shrink the limit
            limit = smallest(this.limit, newSize);
        } else if (growLimit && this.limit==capacity) {
            // grow the limit if it was the max and we want that
            limit = newSize;
        } else {
            // keep it if it was less than max
            limit = this.limit;
        }
        // copy everything unless we shrink
        value copyUntil = smallest(this.capacity, newSize);
        // prepare our limits for copying
        this.position = 0;
        this.limit = copyUntil;
        // copy
        while (this.hasAvailable) {
            dest.set(this.position, this.get());
        }
        // change buffer
        buf = dest;
        // now restore positions
        this.limit = limit;
        this.position = position;
    }
    
    shared actual native ("js") Object? implementation => buf;
}

shared native ("jvm") class ByteBufferImpl(Integer initialCapacity)
        extends ByteBuffer() {
    
    variable JavaByteBuffer buf = allocateJavaByteBuffer(initialCapacity);
    JavaByteBuffer underlyingBuffer => buf;
    
    shared actual native ("jvm") Integer capacity => buf.capacity();
    
    shared actual native ("jvm") Integer limit => buf.limit();
    native ("jvm") assign limit => buf.limit(limit);
    
    shared actual native ("jvm") Integer position => buf.position();
    native ("jvm") assign position => buf.position(position);
    
    shared actual native ("jvm") Byte getByte() => buf.get();
    shared actual native ("jvm") void putByte(Byte byte) => buf.put(byte);
    
    shared actual native ("jvm") Byte get() => buf.get();
    shared actual native ("jvm") void put(Byte element) => buf.put(element);
    
    shared actual native ("jvm") void clear() => buf.clear();
    shared actual native ("jvm") void flip() => buf.flip();
    
    shared actual native ("jvm") void resize(Integer newSize, Boolean growLimit) {
        if (newSize == capacity) {
            return;
        }
        if (newSize < 0) {
            // FIXME: type
            throw;
        }
        JavaByteBuffer dest = allocateJavaByteBuffer(newSize);
        // save our position and limit
        value position = smallest(this.position, newSize);
        Integer limit;
        if (newSize < capacity) {
            // shrink the limit
            limit = smallest(this.limit, newSize);
        } else if (growLimit && this.limit==capacity) {
            // grow the limit if it was the max and we want that
            limit = newSize;
        } else {
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
    
    //shared actual Array<Byte> bytes() {
    //    //TODO: could it be buf.array().byteArray
    //    //downside: that exposes the internal state
    //    //of the underyling Java buffer
    //    return toByteArray(buf.array());
    //}
    
    shared actual native ("jvm") Object? implementation => underlyingBuffer;
}
shared native Integer readByteArray(Array<Byte> array, Reader reader);
shared native ("js") Integer readByteArray(Array<Byte> array, Reader reader) {
    value buffer = newByteBuffer(array.size);
    value result = reader.read(buffer);
    for (i in 0:result) {
        array.set(i, buffer.getByte());
    }
    return result;
}
shared native ("jvm") Integer readByteArray(Array<Byte> array, Reader reader) {
    //TODO: is it horribly inefficient to allocate
    //      a new byte buffer here??
    value buffer = newByteBuffer(array.size);
    value result = reader.read(buffer);
    value byteArray = javaByteArray(array);
    for (i in 0:result) {
        byteArray.set(i, buffer.getByte());
    }
    return result;
}
