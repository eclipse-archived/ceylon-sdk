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

shared sealed interface Closeable {
    "Closes this file descriptor."
    shared formal void close();
}

"Represents anything that you can read from, much like
 the UNIX notion of file descriptor."
by("Stéphane Épardaud")
shared sealed interface ReadableFileDescriptor satisfies Closeable {
    "Reads everything we can from this file descriptor into 
     the specified buffer.
     
     If this file descriptor is in `blocking` mode, it will 
     block the current thread until the buffer is full, or 
     until we reached end of file.
     
     If this file descriptor is in `non-blocking` mode, it 
     will only read the data that is available for reading 
     without blocking, which may be less than the buffer's 
     available space.
     
     In both cases, it returns the number of bytes read, or 
     `-1` when the end of file is reached."
    shared formal Integer read(ByteBuffer buffer);
    
    "Reads data until the end of file is reached, in a 
     blocking way, by passing it to the specified consumer. 
     This method makes no sense if the file descriptor is in
     `non-blocking` mode."
    shared void readFully(void consume(ByteBuffer buffer), 
        ByteBuffer buffer = newBuffer()) {
        // FIXME: should we allocate the buffer ourselves?
        // FIXME: should we clear the buffer passed?
        // I guess not, because there might be something left 
        // by the consumer at the beginning that we don't want 
        // to override?
        // FIXME: should we check that the FD is in blocking mode? 
        while(read(buffer) >= 0) {
            buffer.flip();
            consume(buffer);
            // FIXME: should we clear the buffer or should 
            //        the consumer do it?
            // I suppose the consumer should do it, because 
            // he might find it convenient to leave something 
            // that he couldn't consume?
            // In which case we should probably not try to 
            // read if the buffer is still full?
            // OTOH we could require him to consume it all
            buffer.clear();
        }
    }
}

"Represents anything that you can write to, much like
 the UNIX notion of file descriptor."
by("Stéphane Épardaud")
shared sealed interface WritableFileDescriptor satisfies Closeable {
    "Writes everything we can from the specified buffer to 
     this file descriptor.
     
     If this file descriptor is in `blocking` mode, it will 
     block the current thread until the buffer is written 
     entirely, or until we reached end of file.
     
     If this file descriptor is in `non-blocking` mode, it 
     will only write the data that can be written without 
     blocking, which may be less than the buffer's available 
     data.
     
     In both cases, it returns the number of bytes written, 
     or `-1` when the end of file is reached."
    shared formal Integer write(ByteBuffer buffer);
    
    "Writes the given buffer to this file descriptor 
     entirely, until either the buffer has been entirely 
     written, or until end of file. This method makes no 
     sense if the file descriptor is in `non-blocking` mode."
    shared void writeFully(ByteBuffer buffer) {
        while(buffer.hasAvailable && write(buffer) >= 0) {}
    }
    
    "Writes all the data produced by the given producer to 
     this file descriptor, until the producer stops filling 
     the buffer, or end of file. This method will repeatedly
     invoke the producer so that it can push data to the 
     buffer. If the producer wants to indicate end of input, 
     it only has to stop adding data to the buffer. This
     method makes no sense in `non-blocking` mode."
    shared void writeFrom(void producer(ByteBuffer buffer), 
        ByteBuffer buffer = newBuffer()) {
        // refill
        while(true) {
            // fill our buffer
            producer(buffer);
            // flip it for reading
            buffer.flip();
            if(!buffer.hasAvailable) {
                // EOI
                return;
            }
            writeFully(buffer);
            buffer.clear();
        }
    }
}

"Represents anything that you can read/write to, much like 
 the UNIX notion of file descriptor.
 
 This supports synchronous and asynchronous reading."
see (`interface Socket`,
    `interface SelectableFileDescriptor`)
by ("Stéphane Épardaud")
shared sealed interface FileDescriptor
        satisfies ReadableFileDescriptor & WritableFileDescriptor {
}
