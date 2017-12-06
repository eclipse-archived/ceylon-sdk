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

"Represents a [[FileDescriptor]] that you can `select`. 
 This means that you can register listeners for this file 
 descriptor on a given [[Selector]] object that will be 
 called whenever there is data available to be read or 
 written without blocking the reading/writing thread."
by("Stéphane Épardaud")
shared sealed interface SelectableFileDescriptor 
        satisfies FileDescriptor {

    "Register a reading listener to the given [[selector]]. 
     The reading listener will be invoked by the [[Selector]] 
     whenever data can be read from this file descriptor 
     without blocking.
     
     If you are no longer interested in `read` events from 
     the selector, you should return `false` from your 
     listener when invoked."
    see(`interface Selector`)
    shared void readAsync(Selector selector, 
            void consume(ByteBuffer buffer), 
            ByteBuffer buffer = newBuffer()) {
        blocking = false;
        selector.addConsumer(this, (socket) {
            buffer.clear();
            if(socket.read(buffer) >= 0) {
                buffer.flip();
                // FIXME: should the consumer be allowed to stop us?
                consume(buffer);
                return true;
            }else{
                // EOF
                return false;
            }
        });
    }

    "Register a writing listener to the given [[selector]]. 
     The writing listener will be invoked by the [[Selector]] 
     whenever data can be written to this file descriptor 
     without blocking.
     
     If you are no longer interested in `write` events from 
     the selector, you should return `false` from your 
     listener when invoked."
    see(`interface Selector`)
    shared void writeAsync(Selector selector, 
            void producer(ByteBuffer buffer), 
            ByteBuffer buffer = newBuffer()) {
        blocking = false;
        variable Boolean needNewData = true;
        Boolean writeData(FileDescriptor socket) {
            // get new data if we ran out
            if(needNewData) {
                buffer.clear();
                producer(buffer);
                // flip it for reading
                buffer.flip();
                if(!buffer.hasAvailable) {
                    // EOI
                    return false;
                }
                needNewData = false;
            }
            // try to write it
            if(socket.write(buffer) >= 0) {
                // did we manage to write everything?
                needNewData = !buffer.hasAvailable;
                return true;
            }else{
                // EOF
                return false;
            }
        }
        selector.addProducer(this, writeData);
    }

    // FIXME: revisit, pull up
    "The blocking mode."
    shared formal variable Boolean blocking;
}
