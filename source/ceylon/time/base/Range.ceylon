/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Duration, Period }

"An interface to represent a Range between same kinds of _Date_ or _DateTime_ or _Time_."
shared interface Range<Element, StepBy> 
       satisfies Iterable<Element, Null>
       given Element satisfies Enumerable<Element> {

    "The first Element returned by the iterator, if any.
     This should always produce the same value as
     `iterable.iterator().head`.
     It also represents the _caller_ that created the Range:
     
     Example: today().to(tomorrow) -> in this case today() is the caller/creator of the range."
    shared formal Element from;

    "The limit of the Range where. 

     Example:

     Given: today().to(tomorrow) then tomorrow is the _to_ element.
     
     Given: tomorrow.to(today()) then today() is the _to_ element."
    shared formal Element to;

    "Customized way to iterate over each element, it does not interfer in _from_
     and _to_ fields, but it does not guarantee that _to_ will be included in iterator."
    shared formal UnitOfDate|UnitOfTime step;

    "Returns the Duration between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 86400000 milliseconds.
     
     Given: tomorrow().to(today).duration then duration is -86400000 milliseconds."
    shared formal Duration duration;

    "Returns the Period between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 1 day.
     
     Given: tomorrow().to(today).duration then duration is -1 day."
    shared formal Period period;
    
    "Returns empty or a new Range:
     - Each Range is considered a _set_ then [A..B] is equivalent to [B..A]
     - The precision is based on the lowest unit
     - When the new Range exists it will follow these rules:\n
     Given: [A..B] overlap [C..D]\n 
     When: AB < CD\n
         [1..6] overlap [3..9] = [3,6]\n
         [1..6] overlap [9..3] = [3,6]\n
         [6..1] overlap [3..9] = [3,6]\n
         [6..1] overlap [9..3] = [3,6]\n\n

     Given: [A..B] overlap [C..D]\n 
     When: AB > CD\n
         [3..9] overlap [1..6] = [3,6]\n
         [3..9] overlap [6..1] = [3,6]\n
         [9..3] overlap [1..6] = [3,6]\n
         [9..3] overlap [6..1] = [3,6]"
    shared formal Range<Element, StepBy>|Empty overlap( Range<Element, StepBy> other );

    "Returns empty or a new Range:
     - Each Range is considered a _set_ then [A..B] is equivalent to [B..A] 
     - The precision is based on the lowest unit 
     - When the new Range exists it will follow these rules:\n
     Given: [A..B] gap [C..D]\n 
     When: AB < CD\n
         [1..2] gap [5..6] = (2,5)\n
         [1..2] gap [6..5] = (2,5)\n
         [2..1] gap [5..6] = (2,5)\n
         [2..1] gap [6..5] = (2,5)\n\n

     Given: [A..B] gap [C..D]\n 
     When: AB > CD\n
         [5..6] gap [1..2] = (2,5)\n
         [5..6] gap [2..1] = (2,5)\n
         [6..5] gap [1..2] = (2,5)\n
         [6..5] gap [2..1] = (2,5)"
    shared formal Range<Element, StepBy>|Empty gap( Range<Element, StepBy> other );

    "Returns true if both: this and other are same type and have equal fields _from_ and _to_."
    shared default actual Boolean equals( Object other ) {
        if ( is Range<Element, StepBy> other ) {
            return from == other.from && to == other.to;
        }
        return false;
    }

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared default actual Integer hash {
        value prime = 31;
        variable Integer result = 1;
        result = prime * result + from.hash;
        result = prime * result + to.hash;
        return result;
    }

    "Define how this Range will get next or previous element while iterating."
    shared formal Range<Element, StepBy> stepBy( StepBy step );

    "Returns ISO-8601 formatted String representation of this Range.\n
     Reference: https://en.wikipedia.org/wiki/ISO_8601#Time_intervals"
     shared default actual String string => "``from``/``to``";
}
