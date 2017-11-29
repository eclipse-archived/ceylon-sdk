/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.readers {
    readArray=readByteArray
}

"Represents an object that can read data from a source
 into byte buffers."
by ("Stéphane Épardaud")
shared abstract class Reader() {
    
    "Reads data into the given [[buffer]] and returns the
     number of bytes read, or `-1` if the end of the file is
     reached."
    formal shared Integer read(ByteBuffer buffer);
    
    variable ByteBuffer? byteBuffer = null;
    value buffer = byteBuffer else (byteBuffer = ByteBuffer.ofSize(1));
    
    "Reads a single byte. Returns the byte read, or `null`
     at the end of the file. 
     
     This method blocks the current thread until a byte is
     read or end of file is reached, so if the underlying
     reader is non-blocking then this method will do very
     expensive active polling."
    shared default Byte? readByte() {
        buffer.clear();
        while (read(buffer) >= 0) {
            // did we get anything?
            if (!buffer.hasAvailable) {
                buffer.flip();
                return buffer.get();
            }
            // try again
        }
        // EOF
        return null;
    }
    
    "Reads data into the given [[byte array|array]] and
     returns the number of bytes read, or `-1` if the end of
     the file is reached."
    shared default Integer readByteArray(Array<Byte> array)
            => readArray(array, this);
}
