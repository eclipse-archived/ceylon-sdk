import ceylon.time.base { Range, milliseconds, UnitOfDate, days }
import ceylon.time.internal { previousByStep, nextByStep, gapUtil = gap, overlapUtil = overlap }

see( Range )
shared class DateRange( from, to, step = days ) satisfies Range<Date, DateRange> {

    shared actual Date from;
    shared actual Date to;

    shared actual UnitOfDate step;

    Date smaller = from <= to then from else to;
    Date greater = from > to then from else to;
    Boolean reversed = from > to; 	

    shared actual Period period  {
        return smaller.periodTo(greater);	
    }

    shared actual Duration duration  {
        return Duration((greater.dayOfEra - smaller.dayOfEra) * milliseconds.perDay);	
    }

    shared actual Boolean equals( Object other ) {
        return Range::equals(other); 
    }

    shared actual DateRange? overlap(DateRange other) {
        value response = overlapUtil(this, other, step);
        assert( is DateRange? response );
        return response;
        //assert( is DateRange? response = overlapUtil(this, other, step));
        //return response;
    }

    shared actual DateRange? gap( DateRange other ) {
        value response = gapUtil(this, other, step);
        assert( is DateRange? response );
        return response;
        //assert( is DateRange? response = gapUtil(this, other, step) );
        //return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"
    shared actual Iterator<Date> iterator()  {
        object listIterator satisfies Iterator<Date> {
            variable Integer count = 0;
            shared actual Date|Finished next() {
                value date = reversed then previousByStep(from, step, count++) else nextByStep(from, step, count++);
                assert( is Date date );
                value continueLoop = from <= to then date <= to else date >= to;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }
    
    "Define how this Range will get next or previous element while iterating."
    shared DateRange stepBy( UnitOfDate step ) {
        return step == this.step then this else DateRange(from, to, step);
    }

}