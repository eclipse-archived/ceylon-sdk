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

void resizeByteBuffer(newSize, growLimit, current, intoNew) {
    Integer newSize;
    Boolean growLimit;
    ByteBuffer current;
    Anything() intoNew;
    
    if (newSize == current.capacity) {
        return;
    }
    if (newSize < 0) {
        // FIXME: type
        throw;
    }
    // save our position and limit
    value position = smallest(current.position, newSize);
    Integer limit;
    if (newSize < current.capacity) {
        // shrink the limit
        limit = smallest(current.limit, newSize);
    } else if (growLimit && current.limit==current.capacity) {
        // grow the limit if it was the max and we want that
        limit = newSize;
    } else {
        // keep it if it was less than max
        limit = current.limit;
    }
    // copy everything unless we shrink
    value copyUntil = smallest(current.capacity, newSize);
    // prepare our limits for copying
    current.position = 0;
    current.limit = copyUntil;
    // copy and change buffer implementation
    intoNew();
    // now restore positions
    current.limit = limit;
    current.position = position;
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
        resizeByteBuffer {
            newSize = newSize;
            growLimit = growLimit;
            current = this;
            intoNew = () {
                // copy
                value dest = Array.ofSize(newSize, 0.byte);
                buf.copyTo(dest, 0, 0, this.available);
                // change buffer
                buf = dest;
            };
        };
    }
    
    shared actual native ("js") Object? implementation => buf;
}

shared native ("jvm") class ByteBufferImpl(Integer initialCapacity)
        extends ByteBuffer() {
    
    variable JavaByteBuffer buf = allocateJavaByteBuffer(initialCapacity);
    
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
        resizeByteBuffer {
            newSize = newSize;
            growLimit = growLimit;
            current = this;
            intoNew = () {
                // copy
                JavaByteBuffer dest = allocateJavaByteBuffer(newSize);
                dest.put(buf);
                // change buffer
                buf = dest;
            };
        };
    }
    
    //shared actual Array<Byte> bytes() {
    //    //TODO: could it be buf.array().byteArray
    //    //downside: that exposes the internal state
    //    //of the underyling Java buffer
    //    return toByteArray(buf.array());
    //}
    
    shared actual native ("jvm") Object? implementation => buf;
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
