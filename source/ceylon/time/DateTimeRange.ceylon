import ceylon.time.base { Range, UnitOfDate, milliseconds, UnitOfTime }
import ceylon.time.internal { nextByStep, previousByStep, gapUtil = gap, overlapUtil = overlap }

see( Range )
shared class DateTimeRange( from, to, step = milliseconds ) satisfies Range<DateTime, DateTimeRange> {

    shared actual DateTime from;
    shared actual DateTime to;

    shared actual UnitOfDate|UnitOfTime step;

    DateTime smaller = from <= to then from else to;
    DateTime greater = from > to then from else to;
    Boolean reversed = from > to; 	

    shared actual Period period  {
        return smaller.periodTo(greater);	
    }

    shared actual Duration duration  {
        return Duration(greater.instant().millisecondsOfEra - smaller.instant().millisecondsOfEra);	
    }

    shared actual Boolean equals( Object other ) {
        return Range::equals(other); 
    }

    shared actual DateTimeRange? overlap(DateTimeRange other) {
        assert( is DateTimeRange? response = overlapUtil(this, other, step));
        return response;
    }

	shared actual DateTimeRange? gap( DateTimeRange other ) {
        assert( is DateTimeRange? response = gapUtil(this, other, step));
        return response;
    }

    "An iterator for the elements belonging to this 
     container. where each jump is based on actual step of this Range"	
    shared actual Iterator<DateTime> iterator()  {
        object listIterator satisfies Iterator<DateTime> {
            variable Integer count = 0;
            shared actual DateTime|Finished next() {
                value date = reversed then nextByStep(from, step, count++) else previousByStep(from, step, count++);
                assert( is DateTime date);
                value continueLoop = from <= to then date <= to else date >= to;
                return continueLoop then date else finished;
            }
        }
        return listIterator;
    }
    
    "Define how this Range will get next or previous element while iterating."
    shared DateTimeRange stepBy( UnitOfDate|UnitOfTime step ) {
        return step == this.step then this else DateTimeRange(from, to, step);
    }
    
}