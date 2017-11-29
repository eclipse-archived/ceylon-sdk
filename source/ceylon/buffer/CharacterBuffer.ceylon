/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a buffer of [[Character]]s."
by ("Stéphane Épardaud", "Alex Szczuczko")
shared class CharacterBuffer extends Buffer<Character> {
    variable Array<Character> buf;
    
    "Allocates a new [[CharacterBuffer]] filled with the given [[initialData]].
     The capacity of the new buffer will be the number of bytes given. The
     returned buffer will be ready to be `read`, with its `position` set to `0`
     and its limit set to the buffer `capacity`."
    shared new ({Character*} initialData) extends Buffer<Character>() {
        buf = Array(initialData);
    }
    
    "Creates a [[CharacterBuffer]] initally backed by the given
     [[initialArray]]. The capacity of the new buffer will be the size of the
     array. The returned buffer will be ready to be `read`, with its `position`
     set to `0` and its limit set to the buffer `capacity`."
    shared new ofArray(Array<Character> initialArray) extends Buffer<Character>() {
        buf = initialArray;
    }
    
    "Allocates a new zeroed [[CharacterBuffer]] of the given
     [[initialCapacity]]."
    shared new ofSize(Integer initialCapacity) extends Buffer<Character>() {
        buf = Array.ofSize(initialCapacity, 0.character);
    }
    
    shared actual Integer capacity => buf.size;
    
    variable Integer _position = 0;
    shared actual Integer position => _position;
    // Have to define assign for position after limit due to circular dependency
    
    variable Integer _limit = buf.size;
    shared actual Integer limit => _limit;
    assign limit {
        "Limit must be non-negative"
        assert (limit >= 0);
        "Limit must be no larger than capacity"
        assert (limit <= capacity);
        // Position must be be no larger than the limit
        if (position > limit) {
            position = limit;
        }
        _limit = limit;
    }
    
    assign position {
        "Position must be non-negative"
        assert (position >= 0);
        "Position must be no larger than limit"
        assert (position <= limit);
        _position = position;
    }
    
    shared actual Character get() {
        if (exists char = buf[position]) {
            position++;
            return char;
        } else {
            throw BufferUnderflowException("No Character at position ``position``");
        }
    }
    shared actual void put(Character element) {
        if (position > limit) {
            throw BufferOverflowException("No space at position ``position``");
        }
        buf[position] = element;
        position++;
    }
    
    shared actual void clear() {
        position = 0;
        limit = capacity;
    }
    
    shared actual void flip() {
        limit = position;
        position = 0;
    }
    
    shared actual void resize(Integer newSize, Boolean growLimit) {
        resizeBuffer {
            newSize = newSize;
            growLimit = growLimit;
            current = this;
            intoNew = () {
                // copy
                value dest = Array.ofSize(newSize, 0.character);
                buf.copyTo(dest, 0, 0, this.available);
                // change buffer
                buf = dest;
            };
        };
    }
    
    shared actual Array<Character> array => buf;
    shared actual Object? implementation => buf;
    
    "The concatenation of the [[Character]]s from [[position]] to [[limit]], by
     repeatedly calling [[get]]."
    shared actual String string => "".join(this);
}
