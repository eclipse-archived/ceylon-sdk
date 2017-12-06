/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"A [[Set]] that maintains its entries in sorted order."
by ("Gavin King")
shared interface SortedSet<Element>
        satisfies Set<Element> 
                  & Ranged<Element,Element,SortedSet<Element>>
        given Element satisfies Object {
    
    "The elements larger than or equal to the given 
     [[value|element]], sorted in ascending order. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted set."
    shared formal {Element*} higherElements(Element element);
    
    "The elements smaller than or equal to the given 
     [[value|element]], sorted _in descending order_. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted set."
    shared formal {Element*} lowerElements(Element element);
    
    "The elements larger than or equal to the first given 
     [[value|from]], and smaller than or equal to the second
     given [[value|to]], sorted in ascending order. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted set."
    shared formal {Element*} ascendingElements
            (Element from, Element to);
    
    "The elements smaller than or equal to the first given 
     [[value|from]], and larger than or equal to the second
     given [[value|to]], sorted _in descending order_. 
     
     This is a lazy operation, returning a view of the 
     underlying sorted set."
    shared formal {Element*} descendingElements
            (Element from, Element to);
    
}

