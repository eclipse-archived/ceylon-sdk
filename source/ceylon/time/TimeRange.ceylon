import ceylon.time.base { Range, UnitOfTime, milliseconds, UnitOfHour, UnitOfMinute, UnitOfSecond, UnitOfMillisecond }
import ceylon.time.internal { _gap = gap, _overlap = overlap }

see( Range )
shared class TimeRange( from, to, step = milliseconds ) satisfies Range<Time, TimeRange, UnitOfTime> {

    shared actual Time from;
    shared actual Time to;
    shared actual UnitOfTime step;

    shared actual Period period  {
        return from.periodTo(to);	
    }

    shared actual Duration duration  {
        return Duration(to.millisecondsOfDay - from.millisecondsOfDay);	
    }

    shared actual Boolean equals( Object other ) {
        return Range::equals(other); 
    }

    shared actual TimeRange|Empty overlap(TimeRange other) {
        assert( is TimeRange|Empty response = _overlap(this, other));
        return response;
    }

    shared actual TimeRange|Empty gap( TimeRange other ) {
        assert( is TimeRange|Empty response  = _gap(this, other));
        return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"
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

    Time nextByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfHour )  { return from.plusHours(jump); }
        case( is UnitOfMinute ) { return from.plusMinutes(jump); }
        case( is UnitOfSecond )   { return from.plusSeconds(jump); }
        case( is UnitOfMillisecond )   { return from.plusMilliseconds(jump); }
    }

    Time previousByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfHour )  { return from.minusHours(jump); }
        case( is UnitOfMinute ) { return from.minusMinutes(jump); }
        case( is UnitOfSecond )   { return from.minusSeconds(jump); }
        case( is UnitOfMillisecond )   { return from.minusMilliseconds(jump); }
    }

}