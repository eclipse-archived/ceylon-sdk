/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a memory buffer that can be read and written to
 with no allocation. The easiest way to get an idea of what
 a buffer is, is that it consists in an array of a given
 [[capacity]], a [[position]] index within the array, and a
 [[limit]] index.
 
 Typical operations on a buffer will be to fill it, which
 you do with [[put]] until you reach the [[limit]].
 
 Then if you want to read the data you just put in the
 buffer, you [[flip]] the buffer, which will set its
 [[limit]] to the current [[position]], and reset its
 [[position]] to `0`. This essentially means that you will
 be able to read from the beginning of the buffer until the
 last object you [[put]] in it when writing.
 
 You can then start calling [[get]] to read objects from
 this buffer until you reach its [[limit]].
 
 Once you are done reading from the buffer, you can
 [[clear]] the buffer to start writing to it again. That
 will reset the [[position]] to `0` and the [[limit]] to the
 [[capacity]], allowing you to write to the full underlying
 array.
 
 Buffers can be resized (grown and expanded), which will
 cause an underlying array reallocation and copy."
by ("Stéphane Épardaud")
see (`class ByteBuffer`,
    `class CharacterBuffer`)
shared abstract class Buffer<Element>()
        satisfies Iterable<Element> {
    
    "The current position index within this buffer. Starts
     at `0` and grows with each [[get]] or [[put]] operation,
     until it reaches the [[limit]]."
    throws (`class AssertionError`,
        "On assignment if the new value would be invalid")
    shared formal variable Integer position;
    
    "The underlying array maximum capacity. Both the
     [[position]] and [[limit]] cannot exceed the capacity.
     You can [[resize]] the array to change the [[capacity]]."
    shared formal Integer capacity;
    
    "The limit at which to stop reading and writing. The
     limit will always be greater or equal to the
     [[position]] and smaller or equal to the [[capacity]]."
    throws (`class AssertionError`,
        "On assignment if the new value would be invalid")
    shared formal variable Integer limit;
    
    "Resizes the underlying array, by growing or shrinking
     it. This implies a new array allocation and copy.
     
     The [[position]] will only be affected if the
     [[newSize]] is smaller than the [[position]], in which
     case the [[position]] will be reset down to the
     [[newSize]] (at the end of the buffer).
     
     The [[limit]] will be brought down to the [[newSize]]
     if it would otherwise exceed it (when shrinking the
     buffer below the old [[limit]]), effectively making the
     new [[limit]] be at the end of the buffer.
     
     If you are growing the array, the [[limit]] will not be
     changed unless the optional parameter [[growLimit]] is
     set to `true` (defaults to `false`), because when you
     are writing it makes sense to grow the limit, but when
     you are reading it usually does not, as growing a
     buffer does not generate new meaningful data."
    shared formal void resize(Integer newSize,
        Boolean growLimit = false);
    
    "Returns `true` if the current [[position]] is smaller
     than the [[limit]]."
    shared Boolean hasAvailable => available > 0;
    
    "Returns the number of objects that can be read/written
     from the current
     [[position]] until we reach the [[limit]]."
    shared Integer available => limit - position;
    
    "Reads an object from this buffer at the current
     [[position]]. Increases the [[position]] by `1`."
    throws (`class BufferUnderflowException`,
        "If [[position]] >= [[limit]]")
    shared formal Element get();
    
    "Writes an object to this buffer at the current
     [[position]]. Increases the [[position]] by `1`."
    throws (`class BufferOverflowException`,
        "If [[position]] >= [[limit]]")
    shared formal void put(Element element);
    
    "Resets the [[position]] to `0` and the [[limit]] to the
     [[capacity]]. Use this after reading to start writing
     to a clear buffer."
    shared formal void clear();
    
    "Flips this buffer after a write operation, so that it
     is ready to be read.
     
     This will and set its [[limit]] to the current
     [[position]], and reset its [[position]] to `0`. This
     essentially means that you will be able to read from
     the beginning of the buffer until the last object you
     [[put]] in it when writing."
    shared formal void flip();
    
    "Returns an [[Iterator]] object to read from the current
     [[position]] until the [[limit]]. This iterator modifies
     the buffer directly, so you will need to [[clear]] or
     [[flip]] it afterwards if you wish to iterate it again."
    shared actual Iterator<Element> iterator() {
        object it satisfies Iterator<Element> {
            shared actual Element|Finished next() {
                if (hasAvailable) {
                    return get();
                }
                return finished;
            }
        }
        return it;
    }
    
    "The current underlying Array of the buffer. Any changes
     made to the buffer will be reflected in this array, and
     vice versa.
     
     Reallocations caused by a call to [[resize]] will cause any
     prior references obtained though this attribute to become
     stale."
    shared formal Array<Element> array;
    
    "A sublist view of [[array]] bounded by the current values
     of [[position]] and [[limit]]. The size of the returned
     List will equal [[available]].
     
     Changes made to [[position]]
     or [[limit]] after creation of the view will not be
     synchronized. Also, reallocations caused by a call to
     [[resize]] will cause any existing views to become stale."
    shared default List<Element> visible
            => if (hasAvailable) then array.sublist(position, limit-1) else [];
    
    "The platform-specific implementation object, if any."
    shared formal Object? implementation;
    
    size => available;
    
    shared actual default Boolean equals(Object that) {
        if (is Buffer<Element> that) {
            if (this === that) {
                return true;
            }
            value thisPosition = this.position;
            value thatPosition = that.position;
            value thisNumVisible = this.limit - thisPosition;
            value thatNumVisible = that.limit - thatPosition;
            if (thisNumVisible != thatNumVisible) {
                return false;
            }
            value numVisible = thisNumVisible;
            value thisArray = this.array;
            value thatArray = that.array;
            for (offset in 0:numVisible) {
                value thisElement = thisArray[thisPosition + offset];
                value thatElement = thatArray[thatPosition + offset];
                assert (exists thisElement, exists thatElement);
                if (thisElement != thatElement) {
                    return false;
                }
            }
            return true;
        } else {
            return false;
        }
    }
}
