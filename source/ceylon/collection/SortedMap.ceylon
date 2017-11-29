/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[Map]] that maintains its entries in sorted order."
by ("Gavin King")
shared interface SortedMap<Key,out Item>
        satisfies Map<Key,Item> 
                  & Ranged<Key,Key->Item,SortedMap<Key,Item>>
        given Key satisfies Object {
    
    "The entries with keys larger than or equal to the given 
     [[key]], sorted by key in ascending order. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted map."
    shared formal {<Key->Item>*} higherEntries(Key key);
    
    "The entries with keys smaller than or equal to the 
     given [[key]], sorted by key _in descending order_. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted map."
    shared formal {<Key->Item>*} lowerEntries(Key key);
    
    "The entries with keys larger than or equal to the first 
     given [[value|from]], and smaller than or equal to the 
     second given [[value|to]], sorted in ascending order. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted map."
    shared formal {<Key->Item>*} ascendingEntries
            (Key from, Key to);
    
    "The entries with keys smaller than or equal to the 
     first given [[value|from]], and larger than or equal to 
     the second given [[value|to]], sorted _in descending 
     order_. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted map."
    shared formal {<Key->Item>*} descendingEntries
            (Key from, Key to);
}