import ceylon.time.base { Range, UnitOfDate, milliseconds, UnitOfTime, UnitOfYear, UnitOfMonth, UnitOfDay, UnitOfHour, UnitOfMinute, UnitOfSecond, UnitOfMillisecond }
import ceylon.time.internal { _gap = gap, _overlap = overlap }

see( Range )
shared class DateTimeRange( from, to, step = milliseconds ) satisfies Range<DateTime, UnitOfDate|UnitOfTime> {

    shared actual DateTime from;
    shared actual DateTime to;

    shared actual UnitOfDate|UnitOfTime step;

    shared actual Period period => from.periodTo(to);	

    shared actual Duration duration  {
        return Duration(to.instant().millisecondsOfEpoch - from.instant().millisecondsOfEpoch);	
    }

    shared actual Boolean equals( Object other ) => (super of Range<DateTime, UnitOfDate|UnitOfTime>).equals(other); 

    shared actual DateTimeRange|Empty overlap(Range<DateTime, UnitOfDate|UnitOfTime> other) {
        value response = _overlap([from,to], [other.from, other.to]);
        if ( is [DateTime,DateTime] response) {
            return DateTimeRange(*response);
        }
        assert( is Empty response);
        return response;
    }

    shared actual DateTimeRange|Empty gap( Range<DateTime, UnitOfDate|UnitOfTime> other ) {
        value response = _gap([from,to], [other.from, other.to]);
        if ( is [DateTime,DateTime] response) {
            return DateTimeRange(response[0], response[1]);
        }
        assert( is Empty response);
        return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"	
    shared actual Iterator<DateTime> iterator()  {
        object listIterator satisfies Iterator<DateTime> {
            variable Integer count = 0;
            shared actual DateTime|Finished next() {
                value date = from > to then previousByStep(count++) else nextByStep(count++);
                value continueLoop = from <= to then date <= to else date >= to;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }

    "Define how this Range will get next or previous element while iterating."
    shared actual DateTimeRange stepBy( UnitOfDate|UnitOfTime step ) {
        return step == this.step then this 
               else DateTimeRange(from, to, step);
    }

    DateTime nextByStep( Integer jump = 1 ) {
        if ( is UnitOfDate step ) {
            switch( step )
            case( is UnitOfYear )  { return from.plusYears(jump); }
            case( is UnitOfMonth ) { return from.plusMonths(jump); }
            case( is UnitOfDay )   { return from.plusDays(jump); }
        }
        if ( is UnitOfTime step ) {
            switch( step )
            case( is UnitOfHour )  { return from.plusHours(jump); }
            case( is UnitOfMinute ) { return from.plusMinutes(jump); }
            case( is UnitOfSecond )   { return from.plusSeconds(jump); }
            case( is UnitOfMillisecond )   { return from.plusMilliseconds(jump); }
        }
        throw;
    }

    DateTime previousByStep( Integer jump = 1 ) {
        if ( is UnitOfDate step ) {
            switch( step )
            case( is UnitOfYear )  { return from.minusYears(jump); }
            case( is UnitOfMonth ) { return from.minusMonths(jump); }
            case( is UnitOfDay )   { return from.minusDays(jump); }
        }
        if ( is UnitOfTime step ) {
            switch( step )
            case( is UnitOfHour )  { return from.minusHours(jump); }
            case( is UnitOfMinute ) { return from.minusMinutes(jump); }
            case( is UnitOfSecond )   { return from.minusSeconds(jump); }
            case( is UnitOfMillisecond )   { return from.minusMilliseconds(jump); }
        }
        throw;
    }

}
