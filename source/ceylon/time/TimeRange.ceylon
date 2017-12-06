/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time.base { Range, UnitOfTime, milliseconds, UnitOfHour, UnitOfMinute, UnitOfSecond, UnitOfMillisecond }
import ceylon.time.internal { _gap = gap, _overlap = overlap }

"Implementation of [[Range]] and allows easy iteration between [[Time]] types.
 
 Provides all power of [[Iterable]] features and complements with:
 * Easy way to recover [[Period]]
 * Easy way to recover [[Duration]]
 * Recover the overlap between [[TimeRange]] types
 * Recover the gap between [[TimeRange]] types
 * Allows customized way to iterate as navigate between values by [[UnitOfTime]] cases
 "
see(`interface Range`)
shared serializable class TimeRange( from, to, step = milliseconds ) satisfies Range<Time, UnitOfTime> {

    "The first Element returned by the iterator, if any.
     This should always produce the same value as
     `iterable.iterator().head`.
     It also represents the _caller_ that created the Range:
     
     Example: today().to(tomorrow) -> in this case today() is the caller/creator of the range."
    shared actual Time from;

    "The limit of the Range where. 

     Example:

     Given: today().to(tomorrow) then tomorrow is the _to_ element.
     
     Given: tomorrow.to(today()) then today() is the _to_ element."
    shared actual Time to;

    "Customized way to iterate over each element, it does not interfer in _from_
     and _to_ fields, but it does not guarantee that _to_ will be included in iterator."
    shared actual UnitOfTime step;

    "Returns the Period between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 1 day.
     
     Given: tomorrow().to(today).duration then duration is -1 day."
    shared actual Period period => from.periodTo(to);

    "Returns the Duration between _from_ and _to_ fields.

     Example: 
     
     Given: today().to(tomorrow).duration then duration is 86400000 milliseconds.
     
     Given: tomorrow().to(today).duration then duration is -86400000 milliseconds."
    shared actual Duration duration => Duration(to.millisecondsOfDay - from.millisecondsOfDay);

    "Returns true if both: this and other are same type and have equal fields _from_ and _to_."
    shared actual Boolean equals( Object other ) => (super of Range<Time, UnitOfTime>).equals(other);

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared actual Integer hash => (super of Range<Time, UnitOfTime>).hash;

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
    shared actual TimeRange|Empty overlap(Range<Time, UnitOfTime> other) {
        value response = _overlap([from,to], [other.from, other.to]);
        if (is [Time,Time] response) {
            return TimeRange(response[0], response[1]);
        }
        else {
            return response;
        }
    }

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
    shared actual TimeRange|Empty gap( Range<Time, UnitOfTime> other ) {
        value response = _gap([from,to], [other.from, other.to]);
        switch( response )
        case( is [Time,Time] ) {
            return response[0].successor < response[1] 
                       then TimeRange(response[0].successor, response[1].predecessor)
                       else [];
        }
        case( is Empty ) {
            return response;
        }
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range."
    shared actual Iterator<Time> iterator()  {
        object listIterator satisfies Iterator<Time> {
            variable Integer count = 0;
            shared actual Time|Finished next() {
                value date = from > to then previousByStep(count++) else nextByStep(count++);
                value continueLoop = from <= to then date <= to else date >= to && date <= from;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }

    "Define how this Range will get next or previous element while iterating."
    shared actual TimeRange stepBy( UnitOfTime step ) {
        return step == this.step then this else TimeRange(from, to, step);
    }

    "The iteration for each element should always start from same point."
    Time nextByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfHour )  { return from.plusHours(jump); }
        case( is UnitOfMinute ) { return from.plusMinutes(jump); }
        case( is UnitOfSecond )   { return from.plusSeconds(jump); }
        case( is UnitOfMillisecond )   { return from.plusMilliseconds(jump); }
    }

    "The iteration for each element should always start from same point."
    Time previousByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfHour )  { return from.minusHours(jump); }
        case( is UnitOfMinute ) { return from.minusMinutes(jump); }
        case( is UnitOfSecond )   { return from.minusSeconds(jump); }
        case( is UnitOfMillisecond )   { return from.minusMilliseconds(jump); }
    }

}
