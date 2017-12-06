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
    JIterable=Iterable
}

"A Ceylon [[Iterable]] that adapts an instance of Java's 
 [[java.lang::Iterable]], allowing its elements to be 
 iterated using a `for` loop.
     
     IntArray ints = ... ;
     for (int in CeylonIterable(Arrays.asList(*ints.array))) {
         ...
     }

 If the given [[iterable]] contains null elements, an
 optional [[Element]] type must be explicitly specified, for
 example:

     CeylonIterable<String?>(javaStringStream)

 If a non-optional `Element` type is specified, an
 [[AssertionError]] will occur whenever a null value is
 encountered while iterating the stream.

 **Note**: Since Ceylon 1.2.1 it is possible to use 
 [[java.lang::Iterable]] directly in a Ceylon `for` statement:
 
     JavaIterable<Foo> iterable = ... ;
     for (foo in iterable) {
         ...
     }
 "
shared class CeylonIterable<Element>(iterable)
        satisfies Iterable<Element> {

    JIterable<out Element> iterable;

    iterator() => CeylonIterator(iterable.iterator());    
}
