/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Produces the [[stream|ceylon.language::Iterable]] that results from repeated
 calls to the given [[function|next]]. The stream is infinite.

 This function produces a result similar to:

     { next() }.cycled
 "
InfiniteStream<Element> stream<Element>(
        "The function that produces the next element of the stream."
        Element next()) {

    value paramNext = next;
    object it satisfies InfiniteStream<Element> & InfiniteIterator<Element> {
        shared actual
        InfiniteIterator<Element> iterator() => this;

        shared actual
        Element next() => paramNext();

        shared actual
        Element first => paramNext();

        shared actual
        InfiniteStream<Element> rest => this;
    }
    return it;
}

interface InfiniteStream<Element>
        satisfies {Element+} {

    shared actual formal
    InfiniteStream<Element> rest;

    shared actual formal
    InfiniteIterator<Element> iterator();
}

interface InfiniteIterator<Element>
        satisfies Iterator<Element> {

    shared actual formal
    Element next();
}
