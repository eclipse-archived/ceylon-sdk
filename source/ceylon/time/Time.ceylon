import ceylon.time.base { ReadableTime, TimeBehavior, h=hours, min=minutes, sec=seconds, ms=milliseconds, ReadableTimePeriod }
import ceylon.time.impl { TimeOfDay }

doc """Time of day like _6pm_ or _8.30am_.
       
       This type contains only information about an abstract _time of day_ without 
       referencing any date or timezone.
       
       You use Time to specify something that has to occur on a specific time of day
       like _"lunch hour starts at 1pm"_ or _"shop opens at 10am"_.
       """
shared interface Time
        satisfies ReadableTime 
                & TimeBehavior<Time>
                & Comparable<Time>
                & Ordinal<Time> {

    doc "Adds a period of time to this time of day value.
         
         Result of this operation is another time of day,
         wrapping around 12 a.m. (midnight) if necessary.
         "
    shared formal Time plus(ReadableTimePeriod period);

    doc "Subtracts a period of time to this time of day value.
         
         Result of this operation is another time of day,
         wrapping around 12 a.m. (midnight) if necessary.
         "
    shared formal Time minus(ReadableTimePeriod period);
}

"Creates new instance of [[Time]]."
shared Time time(hours, minutes, seconds=0, millis=0) {

    "Hours of the day (0..23)"
    Integer hours;

    "Minutes of the hour (0..59)"
    Integer minutes;

    "Seconds of the minute (0..59)"
    Integer seconds;

    "Milliseconds of the second (0..999)"
    Integer millis;

    "Hours value should be between 0 and 23"
    assert( 0 <= hours && hours < h.perDay );

    "Minutes value should be between 0 and 59"
    assert( 0 <= minutes && minutes < min.perHour );

    "Seconds value should be between 0 and 59"
    assert( 0 <= seconds && seconds < sec.perMinute );

    "Milliseconds value should be between 0 and 999"
    assert( 0 <= millis && millis < ms.perSecond );

    value hh = hours * ms.perHour;
    value mm = minutes * ms.perMinute;
    value ss = seconds * ms.perSecond;

    return TimeOfDay( hh + mm + ss + millis );
}
