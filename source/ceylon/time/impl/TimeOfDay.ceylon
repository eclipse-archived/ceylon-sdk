import ceylon.time { Time, time }
import ceylon.time.base { ms=milliseconds, sec=seconds, ReadableTimePeriod }
import ceylon.time.math { floorMod }

"Basic implementation of [[Time]] interface, representing an abstract 
 _time of day_ such as _10am_ or _3.20pm_."
shared class TimeOfDay(millisOfDay) 
       satisfies Time {

    "Number of milliseconds since last midnight"
    shared actual Integer millisOfDay;

    "Number of full hours elapsed since last midnight."
    shared actual Integer hours => millisOfDay / ms.perHour;

    "Number of minutes since last full hour."
    shared actual Integer minutes => floorMod(millisOfDay, ms.perHour) / ms.perMinute;

    "Number of seconds since last minute."
    shared actual Integer seconds => floorMod(millisOfDay, ms.perMinute) / ms.perSecond;

    "Number of milliseconds since last full second"
    shared actual Integer millis => floorMod(millisOfDay, ms.perSecond);

    "Number of seconds since last midnight"
    shared actual Integer secondsOfDay => millisOfDay / ms.perSecond;

    "Number of minutes since last midnight"
    shared actual Integer minutesOfDay => secondsOfDay / sec.perMinute;

    "Compare two instances of _time of day_"
    shared actual Comparison compare(Time other) {
        return millisOfDay <=> other.millisOfDay;
    }

    "Previous second"
    shared actual Time predecessor
        //TODO: Is this really right?
        => minusSeconds(1);

    "Next second"
    shared actual Time successor
        //TODO: Is this really right?
        => plusSeconds(1);

    "Returns ISO 8601 formatted String representation of this _time of day_."
    shared actual String string {
        return "``leftPad(hours)``:``leftPad(minutes)``:``leftPad(seconds)``.``leftPad(millis, "000")``";
    }

    "Adds specified number of hours to this time of day 
     and returns the result as new time of day."
    shared actual Time plusHours(Integer hours) => plusMilliseconds( hours * ms.perHour );

    "Subtracts specified number of hours from this time of day 
     and returns the resul as new time of day."
    shared actual Time minusHours(Integer hours) => minusMilliseconds( hours * ms.perHour );

    "Adds specified number of minutes to this time of day 
     and returns the result as new  time of day."
    shared actual Time plusMinutes(Integer minutes) => plusMilliseconds( minutes * ms.perMinute );

    "Subtracts specified number of minutes from this time of day 
     and returns the result as new  time of day."
    shared actual Time minusMinutes(Integer minutes) => minusMilliseconds( minutes * ms.perMinute );

    "Adds specified number of seconds to this time of day
     and returns the result as new time of day."
    shared actual Time plusSeconds(Integer seconds) => plusMilliseconds( seconds * ms.perSecond );

    "Subtracts specified number of seconds from this time of day
     and returns the result as new time of day."
    shared actual Time minusSeconds(Integer seconds) => minusMilliseconds( seconds * ms.perSecond );

    "Adds specified number of milliseconds to this time of day
     and returns the result as new time of day."
    shared actual Time plusMilliseconds(Integer milliseconds) {
        if (milliseconds == 0) {
            return this;
        }

        value newMillisOfDay = floorMod(millisOfDay + milliseconds, ms.perDay);
        return newMillisOfDay == this.millisOfDay
               then this else TimeOfDay(newMillisOfDay);
    }

    "Subtracts specified number of milliseconds from this time of day
     and returns the result as new time of day."
    shared actual Time minusMilliseconds(Integer milliseconds) => plusMilliseconds( -milliseconds );

    "Adds specified time period to this time of day 
     and returns the result as new time of day."
    shared actual Time plus(ReadableTimePeriod period){
        value totalMillis = millisOfDay
                          + period.milliseconds
                          + period.seconds * ms.perSecond
                          + period.minutes * ms.perMinute
                          + period.hours * ms.perHour;

        value time = floorMod(totalMillis, ms.perDay);
        return (time == this.millisOfDay) 
               then this else TimeOfDay(time);
    }

    "Subtracts specified time period from this time of day 
     and returns the result as new time of day."
    shared actual Time minus(ReadableTimePeriod period) {
        value totalMillis = millisOfDay
                          - period.milliseconds
                          - period.seconds * ms.perSecond
                          - period.minutes * ms.perMinute
                          - period.hours * ms.perHour;

        value time = floorMod(totalMillis, ms.perDay);
        return (time == this.millisOfDay) 
               then this else TimeOfDay(time);
    }

    shared actual Time withHours(Integer hours) {
        if (this.hours == hours) {
            return this;
        }
        return time(hours, minutes, seconds, millis);
    }

    shared actual Time withMinutes(Integer minutes) {
        if (this.minutes == minutes) {
            return this;
        }

        return time(hours, minutes, seconds, millis);
    }
    shared actual Time withSeconds(Integer seconds) {
        if (this.seconds == seconds) {
            return this;
        }

        return time(hours, minutes, seconds, millis );
    }
    shared actual Time withMilliseconds(Integer milliseconds) {
        if (this.millis == milliseconds) {
            return this;
        }

        return time(hours, minutes, seconds, milliseconds);
    }

    shared actual Boolean equals( Object other ) {
        if ( is TimeOfDay other ) {
            return millisOfDay == other.millisOfDay;
        }
        return false;
    }

}
