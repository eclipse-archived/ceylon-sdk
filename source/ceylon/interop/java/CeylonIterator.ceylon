/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import java.util {
    JIterator=Iterator
}

"A Ceylon [[Iterator]] that adapts an instance of Java's 
 [[java.util::Iterator]]."
shared class CeylonIterator<T>(JIterator<out T> iterator) 
        satisfies Iterator<T> {

    shared actual T|Finished next() {
        if (iterator.hasNext()) {
            if (exists next = iterator.next()) {
                return next;
            }
            else {
                "Java iterator returned null"
                assert (is T null);
                return null;
            }
        }
        else {
            return finished;
        }
    }
    
}
