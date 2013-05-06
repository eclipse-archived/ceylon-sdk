import ceylon.time.base { Range, milliseconds, UnitOfDate, days, UnitOfYear, UnitOfMonth, UnitOfDay }
import ceylon.time.internal { _gap = gap, _overlap = overlap }

see( Range )
shared class DateRange( from, to, step = days ) satisfies Range<Date, DateRange, UnitOfDate> {

    shared actual Date from;
    shared actual Date to;
    shared actual UnitOfDate step;

    shared actual Period period  {
        return from.periodTo(to);
    }

    shared actual Duration duration  {
        return Duration((to.dayOfEra - from.dayOfEra) * milliseconds.perDay);	
    }

    shared actual Boolean equals( Object other ) {
        return Range::equals(other); 
    }

    shared actual DateRange|Empty overlap(DateRange other) {
        value response = _overlap([from,to], [other.from, other.to]);
        if ( is [Date,Date] response) {
            return DateRange(response[0], response[1]);
        }
        assert( is Empty response);
        return response;
    }

    shared actual DateRange|Empty gap( DateRange other ) {
        value response = _gap([from,to], [other.from, other.to]);
        if ( is [Date,Date] response) {
            return DateRange(response[0], response[1]);
        }
        assert( is Empty response);
        return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"
    shared actual Iterator<Date> iterator()  {
        object listIterator satisfies Iterator<Date> {
            variable Integer count = 0;
            shared actual Date|Finished next() {
                value date = from > to then previousByStep(count++) else nextByStep(count++);
                value continueLoop = from <= to then date <= to else date >= to;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }
    
    "Define how this Range will get next or previous element while iterating."
    shared actual DateRange stepBy( UnitOfDate step ) {
        return step == this.step then this else DateRange(from, to, step);
    }

    Date nextByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfYear )  { return from.plusYears(jump); }
        case( is UnitOfMonth ) { return from.plusMonths(jump); }
        case( is UnitOfDay )   { return from.plusDays(jump); }
    }

    Date previousByStep( Integer jump = 1 ) {
        switch( step )
        case( is UnitOfYear )  { return from.minusYears(jump); }
        case( is UnitOfMonth ) { return from.minusMonths(jump); }
        case( is UnitOfDay )   { return from.minusDays(jump); }
    } 

}