/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Create a backing array for storing linked lists of hash map
 entries"
Array<Cell<Key->Item>?> entryStore<Key,Item>(Integer size) 
        given Key satisfies Object
        => Array<Cell<Key->Item>?>.ofSize(size, null);

"Create a backing array for storing linked lists of hash set
 elements"
Array<Cell<Element>?> elementStore<Element>(Integer size) 
        => Array<Cell<Element>?>.ofSize(size, null);

"Create a backing array for storing linked lists of hash map
 entries"
Array<CachingCell<Key->Item>?> cachingEntryStore<Key,Item>(Integer size) 
        given Key satisfies Object
        => Array<CachingCell<Key->Item>?>.ofSize(size, null);

"Create a backing array for storing linked lists of hash set
 elements"
Array<CachingCell<Element>?> cachingElementStore<Element>(Integer size) 
        => Array<CachingCell<Element>?>.ofSize(size, null);