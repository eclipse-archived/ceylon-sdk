import ceylon.time { Date, Time, Instant, DateTime }
import ceylon.time.timezone { ZoneDateTime, TimeZone, tz = timeZone }
import ceylon.time.base { Month, DayOfWeek, ms = milliseconds }
import ceylon.time.chronology { unixTime }

"Default implementation of gregorian calendar thats makes use of a [[TimeZone]] for it´s operations.

 This means that making some operations like _plusDays_ takes into 
 account the result Instant generated to reapply all the rules of the current TimeZone."
shared class GregorianZonedDateTime(instant, timeZone = tz.system) satisfies ZoneDateTime {

    "TimeZone to be applied in this implementation."
    shared actual TimeZone timeZone;

    "All operations of this implementations is based in this Instant."
    shared actual Instant instant;

    "Comparing [[ZoneDateTime]] is based on [[Instant]] and should not be
     compared as it´s human representation as they are adjusted based on geographic and regional (DST)
     locations and do not represent a comparison correct."
    shared actual Comparison compare(ZoneDateTime other) {
        return instant <=> other.instant;
    }

    "Returns _day of month_ value of this gregorian date."
    shared actual Integer day => instant.dateTime(timeZone).day;

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfEra => instant.dateTime(timeZone).dayOfEra;

    "Returns current day of the week."
    shared actual DayOfWeek dayOfWeek => instant.dateTime(timeZone).dayOfWeek;

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfYear => instant.dateTime(timeZone).dayOfYear;

    "Number of full hours elapsed since last midnight."
    shared actual Integer hours => instant.dateTime(timeZone).hours;

    "Returns `true`, if this is a leap year according to gregorian calendar leap year rules."
    shared actual Boolean leapYear => instant.dateTime(timeZone).leapYear;

    "Number of milliseconds since last full second."
    shared actual Integer milliseconds => instant.dateTime(timeZone).milliseconds;

    "Number of milliseconds since last midnight."
    shared actual Integer millisecondsOfDay => instant.dateTime(timeZone).millisecondsOfDay;

    "Number of minutes since last full hour."
    shared actual Integer minutes => instant.dateTime(timeZone).minutes;

    "Number of minutes since last midnight."
    shared actual Integer minutesOfDay => instant.dateTime(timeZone).minutesOfDay;

    "Returns month of this gregorian date."
    shared actual Month month => instant.dateTime(timeZone).month;

    "Number of seconds since last minute."
    shared actual Integer seconds => instant.dateTime(timeZone).seconds;

    "Number of seconds since last midnight."
    shared actual Integer secondsOfDay => instant.dateTime(timeZone).secondsOfDay;

    "Returns week of year according to ISO-8601 week number calculation rules."
    shared actual Integer weekOfYear => instant.dateTime(timeZone).weekOfYear;

    "Returns year of this gregorian date."
    shared actual Integer year => instant.dateTime(timeZone).year;

    "Returns [[Date]] representation of current zoned _date and time_."
    shared actual Date date => instant.dateTime(timeZone).date;

    "Returns [[Time]] representation of current zoned _date and time_."
    shared actual Time time => instant.dateTime(timeZone).time;

    "Subtracts number of days from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusDays(Integer days) => adjust( instant.dateTime(timeZone).minusDays(days) );

    "Subtracts number of hours from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusHours(Integer hours) => adjust( instant.dateTime(timeZone).minusHours(hours) );

    "Subtracts number of milliseconds from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).minusMilliseconds(milliseconds) );

    "Subtracts number of minutes from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).minusMinutes(minutes) );

    "Subtracts number of months from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].
     
     **Note 01:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 3, 30).minusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime minusMonths(Integer months) => adjust( instant.dateTime(timeZone).minusMonths(months) );

    "Subtracts number of seconds from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).minusSeconds(seconds) );

    "Subtracts number of weeks from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime minusWeeks(Integer weeks) => adjust( instant.dateTime(timeZone).minusWeeks(weeks) );

    "Subtracts number of years from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].
     
     **Note 01:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).minusYears(1)` will return
     `2011-02-28`, since _February 2011_ has only 28 days.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime minusYears(Integer years) => adjust( instant.dateTime(timeZone).minusYears(years) );

    "Adds number of days from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusDays(Integer days) => adjust( instant.dateTime(timeZone).plusDays(days) );

    "Adds number of hours from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusHours(Integer hours) => adjust( instant.dateTime(timeZone).plusHours(hours) );

    "Adds number of milliseconds from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).plusMilliseconds(milliseconds) );

    "Adds number of minutes from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).plusMinutes(minutes) );

    "Adds number of months to this _zoned date and time_ and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 1, 31).plusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual ZoneDateTime plusMonths(Integer months) => adjust( instant.dateTime(timeZone).plusMonths(months) );

    "Adds number of seconds from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).plusSeconds(seconds) );

    "Adds number of weeks from this _zoned date and time_ and returns the resulting [[ZoneDateTime]].

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime plusWeeks(Integer weeks) => adjust( instant.dateTime(timeZone).plusWeeks(weeks) );

    "Adds number of years to this _zoned date and time_ and returns the resulting [[ZoneDateTime]].
     
     **Note 01:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).plusYears(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime plusYears(Integer years) => adjust( instant.dateTime(timeZone).plusYears(years) );

    "Returns new [[ZoneDateTime]] with the _day of month_ value set to the specified value.

     **Note 01:** It should result in a valid gregorian date.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withDay(Integer dayOfMonth) => adjust( instant.dateTime(timeZone).withDay(dayOfMonth) );

    "Returns new [[ZoneDateTime]] with the _hour_ value set to the specified value.

     **Note 01:** It should be a valid _hour_.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withHours(Integer hours) => adjust( instant.dateTime(timeZone).withHours(hours) );

    "Returns new [[ZoneDateTime]] with the _milliseconds_ value set to the specified value.

     **Note 01:** It should be a valid _millisecond_.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).withMilliseconds(milliseconds) );

    "Returns new [[ZoneDateTime]] with the _minute_ value set to the specified value.

     **Note 01:** It should be a valid _minute_.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).withMinutes(minutes) );

    "Returns new [[ZoneDateTime]] with the _month_ value set to the specified value.

     **Note 01:** It should result in a valid gregorian date.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withMonth(Month month) => adjust( instant.dateTime(timeZone).withMonth(month) );

    "Returns new [[ZoneDateTime]] with the _second_ value set to the specified value.

     **Note 01:** It should be a valid _second_.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).withSeconds(seconds) );

    "Returns new [[ZoneDateTime]] with the _year_ value set to the specified value.

     **Note 01:** It should result in a valid gregorian date.

     **Note 02:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time.
     "
    shared actual ZoneDateTime withYear(Integer year) => adjust( instant.dateTime(timeZone).withYear(year) );

    "For predecessor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the predecessor is the current value minus 1 millisecond.

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime predecessor => adjust( instant.dateTime(timeZone).predecessor );

    "For sucessor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the successor is the current value plus 1 millisecond.

     **Note:** The resulting  [[ZoneDateTime]] can be affected by Daylight Saving Time."
    shared actual ZoneDateTime successor => adjust( instant.dateTime(timeZone).successor );

    "Returns ISO-8601 formatted String representation of this _time of day_.\n
     Reference: https://en.wikipedia.org/wiki/ISO_8601#Time_offsets_from_UTC"
    shared actual String string {
        value offset = timeZone.offset(instant);
        value builder = StringBuilder();
        builder.append(instant.dateTime(timeZone).string);
        builder.append( offset >= 0 then "+" else "-" );
        builder.append( "``leftPad((offset / ms.perHour).magnitude)``:``leftPad(offset % ms.perHour)``" );
        return builder.string;
    }

    "Returns _true_ if given value is same type, date and time."
    shared actual Boolean equals( Object other ) {
        if (is GregorianZonedDateTime other) {
            if (this === other){
                return true;
            }
        
            return instant == other.instant 
                && timeZone == other.timeZone;
        }
        return false;
    }

    "This implementation respect the constraint that if `x==y` then `x.hash==y.hash`."
    shared default actual Integer hash {
        value prime = 31;
        variable Integer result = 21;
        result = prime * result + instant.hash;
        result = prime * result + timeZone.hash;
        return result;
    }

    "Fix [[DateTime]] zone absence."
    GregorianZonedDateTime adjust( DateTime resolved ) {
        value zoneMillisecondsOfEpoch = unixTime.timeFromFixed(resolved.dayOfEra) + resolved.millisecondsOfDay;
        value utcMillisecondsOfEpoch = zoneMillisecondsOfEpoch - timeZone.offset(instant);
        return GregorianZonedDateTime( Instant( utcMillisecondsOfEpoch ), timeZone );
    }

    "Returns _milliseconds of epoch_ as it enumerable value."
    shared actual Integer integerValue => instant.millisecondsOfEpoch;

}