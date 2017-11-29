/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.lang {
    LongArray
}

native Words wordsOfSize(Integer size);

native("jvm") Words wordsOfSize(Integer size)
    =>  WordsJVM.ofSize(size);

native("js") Words wordsOfSize(Integer size)
    =>  WordsJS.ofSize(size);

native Words wordsOfOne(Integer word);

native("jvm") Words wordsOfOne(Integer word)
    =>  WordsJVM.ofOne(word);

native("js") Words wordsOfOne(Integer word)
    =>  WordsJS.ofOne(word);

native Words copyAppend(Integer wordsSize, Words words, Integer other);

native("jvm") Words copyAppend(Integer wordsSize, Words words, Integer other)
    =>  WordsJVM.copyAppend(wordsSize, words, other);

native("js") Words copyAppend(Integer wordsSize, Words words, Integer other)
    =>  WordsJS.copyAppend(wordsSize, words, other);

Boolean wordsEqual(Integer firstSize, Words first,
                   Integer secondSize, Words second) {
    if (firstSize != secondSize) {
        return false;
    } else if (first === second) {
        return true;
    } else {
        for (i in 0:firstSize) {
            if (first.get(i) != second.get(i)) {
                return false;
            }
        }
        return true;
    }
}

interface Words satisfies Identifiable {
    shared formal
    void copyTo(
            "The container into which to copy the elements."
            Words destination,
            "The index of the first element in this array to
             copy."
            Integer sourcePosition = 0,
            "The index in the given container into which to
             copy the first element."
            Integer destinationPosition = 0,
            "The number of elements to copy."
            Integer length =
                    smallest(size - sourcePosition,
                        destination.size - destinationPosition));

    shared formal
    Integer size;

    shared formal
    void set(Integer index, Integer word);

    shared formal
    Integer get(Integer index);

    shared formal
    Words clone();
}

native("jvm") class WordsJVM satisfies Words {
    LongArray storage;

    new using(LongArray storage) {
        this.storage = storage;
    }

    shared
    new ofSize(Integer size) {
        storage = LongArray(size, 0);

    }

    shared
    new ofOne(Integer word) {
        storage = LongArray(1, word);
    }

    shared
    new copyAppend(
            Integer wordsSize, Words words, Integer other)
            extends ofSize(wordsSize + 1) {
        assert (is WordsJVM words);
        words.storage.copyTo(storage, 0, 0, wordsSize);
        storage[wordsSize] = other;
    }

    shared actual
    void copyTo(
            Words destination,
            Integer sourcePosition,
            Integer destinationPosition,
            Integer length) {
        assert (is WordsJVM destination);
        storage.copyTo(
                destination.storage, sourcePosition,
                destinationPosition, length);
    }

    shared actual
    Integer size => storage.size;

    shared actual
    void set(Integer index, Integer word)
        =>  storage[index] = word;

    shared actual
    Integer get(Integer index)
        =>  storage[index];

    shared actual
    Words clone()
        =>  using(storage.clone());

    shared actual
    String string
        =>  storage.iterable.string;
}

native("js") class WordsJS satisfies Words {
    Array<Integer> storage;

    new using(Array<Integer> storage) {
        this.storage = storage;
    }

    shared
    new ofSize(Integer size) {
        storage = Array.ofSize(size, 0);
    }

    shared
    new ofOne(Integer word) {
        storage = Array.ofSize(1, word);
    }

    shared
    new copyAppend(
            Integer wordsSize, Words words, Integer other)
            extends ofSize(wordsSize + 1) {
        assert (is WordsJS words);
        words.storage.copyTo(storage, 0, 0, wordsSize);
        storage[wordsSize] = other;
    }

    shared actual
    void copyTo(
            Words destination,
            Integer sourcePosition,
            Integer destinationPosition,
            Integer length) {
        assert (is WordsJS destination);
        storage.copyTo(
                destination.storage, sourcePosition,
                destinationPosition, length);
    }

    shared actual
    Integer size => storage.size;

    shared actual
    void set(Integer index, Integer word)
        =>  storage[index] = word;

    shared actual
    Integer get(Integer index) {
        assert (exists result = storage[index]);
        return result;
    }

    shared actual
    Words clone()
        =>  using(storage.clone());

    shared actual
    String string
        =>  storage.string;
}
