/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
class PeekingIterator<Element>(Iterator<Element> delegate)
        satisfies Iterator<Element>
        given Element satisfies Object {

    variable Element | Finished | Null peeked = null;

    shared Element | Finished peek()
        =>  peeked else (peeked = delegate.next());

    shared actual Element | Finished next() {
        if (exists p = peeked) {
            peeked = null;
            return p;
        }
        return delegate.next();
    }
}
