import ceylon.time { DateTime, Time, Date, DateTimeRange, DateRange, TimeRange}
import ceylon.time.base { UnitOfDate, UnitOfTime }

"Represents all Date/Time types"
shared alias Kind => Date|Time|DateTime;

"Represents all Date/Time Ranges types"
shared alias KindRange => DateRange|TimeRange|DateTimeRange;

"[fromPrecision, toPrecision, from, to]"
alias KindsOrdered => [Integer, Integer, Kind, Kind];

"return padded value of the number as a string"
shared String leftPad(Integer number, String padding = "00"){
    if (number == 0){
        return padding;
    }

    value string = number.string;
    value digits = string.size;
    if (digits < padding.size) {
        value padded = padding + string;
        return padded.segment(
                      padded.size - padding.size,
                      padding.size );
    }

    return string;
}

"Returns if two intervals has intersection"
shared Boolean intersect( Integer start, Integer end, Integer otherStart, Integer otherEnd ) {
    return start <= otherEnd && end >= otherStart;
}

//"Returns the intersection between two intervals as a new Interval"
shared KindRange|Empty overlap(KindRange range, KindRange otherRange, UnitOfDate|UnitOfTime step) {

    "We need to order it because we can have _time(6,0).to(time(2,0))_"
    variable KindsOrdered firstRange = createPairOrdered(range);

    "We need to order it because we can have _time(6,0).to(time(2,0))_"
    variable KindsOrdered secondRange = createPairOrdered(otherRange);
    
    //Order ranges ascending because we can have Range(6,0 to 4,0) overlap Range(2,0 to 0,0)
    if ( firstRange[0] > secondRange[0] ) {
        value aux = firstRange;
        firstRange = secondRange;
        secondRange = aux;
    }
    
    if (intersect(firstRange[0], firstRange[1], secondRange[0], secondRange[1])) {

        "Now that we have an intersection we know that secondRange[2] will always be the first element"
        value newFirst = secondRange[2];
        
        if ( is Time newFirst, is Time fr = firstRange[3], is Time sr = secondRange[3], is UnitOfTime step ) {
            //Then we need to know whats the last element: min({fr,sr})
            return TimeRange(newFirst, min({fr,sr}), step);
        } else if ( is Date newFirst, is Date fr = firstRange[3], is Date sr = secondRange[3], is UnitOfDate step ) {
            //Then we need to know whats the last element: min({fr,sr})
            return DateRange(newFirst, min({fr,sr}), step);
        } else if ( is DateTime newFirst, is DateTime fr = firstRange[3], is DateTime sr = secondRange[3] ) {
            //Then we need to know whats the last element: min({fr,sr})
            return DateTimeRange(newFirst, min({fr,sr}), step);
        } else {
            //Thats an internal method and we know we are doing it right else it throw an exception
            throw;
        }
    }
    return empty;
}

//"Returns the gap between two intervals as a new Range"
shared KindRange|Empty gap( KindRange range, KindRange otherRange, UnitOfDate|UnitOfTime step ) {

    "We need to order it because we can have _time(6,0).to(time(2,0))_"
    variable value firstRange = createPairOrdered(range);

    "We need to order it because we can have _time(6,0).to(time(2,0))_"
    variable value secondRange = createPairOrdered(otherRange);
    
    //Order ranges ascending because we can have Range(6,0 to 4,0) overlap Range(2,0 to 0,0)
    if ( firstRange[0] > secondRange[0] ) {
        value aux = firstRange;
        firstRange = secondRange;
        secondRange = aux;
    }
    
    if ( !intersect(firstRange[0], firstRange[1], secondRange[0], secondRange[1])) {
        
        
        "Now we know next step will always be firstRange[to].sucessor"
        value sucessor = firstRange[3].successor;
        
        "Now we know next step will always be secondRange[from].predecessor"
        value predecessor = secondRange[2].predecessor;

        if ( is Time sucessor, is Time predecessor, is UnitOfTime step, is Time sec = secondRange[2] ) {
            //Not enough gap to be considered.
            if( sucessor >= sec ) {
                return empty;
            }
            return TimeRange( sucessor, predecessor, step );
        } else if ( is Date sucessor, is Date predecessor, is UnitOfDate step, is Date sec = secondRange[2] ) {
            //Not enough gap to be considered.
            if( sucessor >= sec ) {
                return empty;
            }
            return DateRange( sucessor, predecessor, step );
        }  else if ( is DateTime sucessor, is DateTime predecessor, is DateTime sec = secondRange[2] ) {
            //Not enough gap to be considered.
            if( sucessor >= sec ) {
                return empty;
            }
            return DateTimeRange( sucessor, predecessor, step );
        } else {
            throw;
        }
    }
    return empty;
}

"Utility to order: [X, Y, today, yesterday] in this: [Y,X, yesterday, today]"
KindsOrdered orderPair( KindsOrdered pair ) {
    return pair[0] <= pair[1] then pair else [pair[1],pair[0], pair[3], pair[2]];
}

"Create a KindsOrdered based on each Kind precision"
KindsOrdered createPairOrdered( KindRange range ) {
    if ( is DateRange range ) {
        return orderPair( [range.from.dayOfEra, range.to.dayOfEra, range.from, range.to] );
    } else if ( is DateTimeRange range ) {
        return  orderPair( [range.from.instant().millisecondsOfEra, range.to.instant().millisecondsOfEra, range.from, range.to ] );
    } else if ( is TimeRange range ) {
        return orderPair( [range.from.millisecondsOfDay, range.to.millisecondsOfDay, range.from, range.to] );
    } else {
        throw;
    }
}