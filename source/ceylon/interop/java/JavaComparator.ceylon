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
    JComparator=Comparator
}

"A Java [[java.util::Comparator]] that wraps a function
 returning [[Comparison]]. The given [[compareElements]] function will
 be used to compare null values if [[Element]] covers [[Null]]. Otherwise,
 nulls will be ordered according to the [[nulls]] parameter."
shared
class JavaComparator<Element>(compareElements, nulls=smaller)
        satisfies JComparator<Element> {

    Comparison compareElements(Element x, Element y);

    "[[smaller]] to consider null less than non-null, or [[larger]] to consider
     null greater than non-null."
    \Ismaller|\Ilarger nulls;

    function toInteger(Comparison comparison)
        =>  switch (comparison)
            case (equal)    0
            case (larger)   1
            case (smaller) -1;

    Comparison ceylonCompare(Element? first, Element? second)
        =>  if (is Element first, is Element second) then
                // Element may actually support Null
                compareElements(first, second)
            else if (exists first) then
                if (exists second) then
                    compareElements(first, second)
                else
                    nulls.reversed // second is null
            else if (exists second) then
                nulls // first is null
            else
                equal; // both are null

    compare(Element? first, Element? second)
        =>  toInteger(ceylonCompare(first, second));

    equals(Object that)
        =>  (super of Basic).equals(that);

}
