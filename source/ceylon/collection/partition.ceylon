/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Groups the given [[elements]] into two sequences, the first 
 containing elements selected by the given [[predicate 
 function|selecting]], and the second containing elements 
 rejected by the given predicate function."
shared [Element[],Element[]] partition<Element>
        ({Element*} elements, selecting) {
    
    "A predicate function that determines if a specified 
     element should be selected or rejected. Returns `true`
     to indicate that the element is selected, or `false`
     to indicate that the element is rejected."
    Boolean selecting(Element element);
    
    value selected = ArrayList<Element>();
    value rejected = ArrayList<Element>();
    for (element in elements) {
        if (selecting(element)) {
            selected.add(element);
        }
        else {
            rejected.add(element);
        }
    }
    return [selected.sequence(), rejected.sequence()];
}
