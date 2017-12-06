/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.time { Date, Time, DateTime, Instant, Period, DateTimeRange }
import ceylon.time.base { ReadablePeriod, Month, ms=milliseconds, daysOf=days, DayOfWeek, months }
import ceylon.time.chronology { unixTime }
import ceylon.time.internal.math { floorDiv, floorMod }
import ceylon.time.timezone { TimeZone, timeZone }

"Default implementation of a gregorian calendar"
shared serializable class GregorianDateTime( date, time ) extends Object()
    satisfies DateTime {

    "Returns [[Date]] representation of current _date and time_."
    shared actual Date date;

    "Returns [[Time]] representation of current _date and time_."
    shared actual Time time;

    "Comparing [[DateTime]] is based on [[Date]] and [[Time]] comparison."
    shared actual Comparison compare(DateTime other) {
        return date != other.date then date <=> other.date
                                  else time <=> other.time;
    }

    "Returns _day of month_ value of this gregorian date."
    shared actual Integer day => date.day;

    "Returns current day of the week."
    shared actual DayOfWeek dayOfWeek => date.dayOfWeek;

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfYear => date.dayOfYear;

    "Returns _day of year_ value of this gregorian date."
    shared actual Integer dayOfEra => date.dayOfEra;

    "Returns year of this gregorian date."
    shared actual Integer year => date.year;

    "Returns `true` if this is a leap year according to gregorian calendar leap year rules."
    shared actual Boolean leapYear => date.leapYear;

    "Returns week of year according to ISO-8601 week number calculation rules."
    shared actual Integer weekOfYear => date.weekOfYear;

    "Returns month of this gregorian date."
    shared actual Month month => date.month;

    "Number of full hours elapsed since last midnight."
    shared actual Integer hours => time.hours;

    "Number of milliseconds since last full second."
    shared actual Integer milliseconds => time.milliseconds;

    "Number of milliseconds since last midnight."
    shared actual Integer millisecondsOfDay => time.millisecondsOfDay;

    "Number of minutes since last full hour."
    shared actual Integer minutes => time.minutes;

    "Number of minutes since last midnight."
    shared actual Integer minutesOfDay => time.minutesOfDay;

    "Number of seconds since last minute."
    shared actual Integer seconds => time.seconds;

    "Number of seconds since last midnight."
    shared actual Integer secondsOfDay => time.secondsOfDay;

    "Adds number of years to this date returning the resulting gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).plusYears(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual DateTime plusYears(Integer years) => GregorianDateTime {
         date = date.plusYears(years);
         time = time;
     };

    "Subtracts number of years from this date returning the resulting the new gregorian date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2012, 2, 29).minusYears(1)` will return
     `2011-02-28`, since _February 2011_ has only 28 days.
     "
    shared actual DateTime minusYears(Integer years) => GregorianDateTime {
        date = date.minusYears(years);
        time = time;
    };

    "Adds number of months to this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 1, 31).plusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual DateTime plusMonths(Integer months) => GregorianDateTime {
        date = date.plusMonths(months);
        time = time;
    };

    "Subtracts number of months from this date and returns the resulting date.
     
     **Note:** Day of month value of the resulting date will be truncated to the 
     valid range of the target date if necessary.
     
     This means for example, that `date(2013, 3, 30).minusMonths(1)` will return
     `2013-02-28`, since _February 2013_ has only 28 days.
     "
    shared actual DateTime minusMonths(Integer months) => plusMonths(-months);

    "Adds number of weeks to this date and returns the resulting [[DateTime]]."
    shared actual DateTime plusWeeks(Integer weeks) => GregorianDateTime {
        date = date.plusWeeks(weeks);
        time = time;
    };

    "Subtracts number of weeks from this date and returns the resulting [[DateTime]]."
    shared actual DateTime minusWeeks(Integer weeks) => plusWeeks(-weeks);

    "Adds number of days to this date and returns the resulting [[DateTime]]."
    shared actual DateTime plusDays(Integer days) => GregorianDateTime {
        date = date.plusDays(days);
        time = time;
    };

    "Subtracts number of days from this date and returns the resulting [[DateTime]]."
    shared actual DateTime minusDays(Integer days) => plusDays(-days);

    "Adds number of hours from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime plusHours(Integer hours) {
        if ( hours == 0 ) {
            return this;
        }
        value signal = hours >= 0 then 1 else -1; 
        return fromTime{ hours = hours * signal; signal = signal; };
    }

    "Subtracts number of hours from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime minusHours(Integer hours) => plusHours(-hours);

    "Adds number of minutes from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime plusMinutes(Integer minutes) {
        if ( minutes == 0 ) {
            return this;
        }

        value signal = minutes >= 0 then 1 else -1;
        return fromTime{ minutes = minutes * signal; signal = signal; };
    }

    "Subtracts number of minutes from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime minusMinutes(Integer minutes) => plusMinutes(-minutes);

    "Adds number of seconds from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime plusSeconds(Integer seconds) {
        if ( seconds == 0 ) {
            return this;
        }
        value signal = seconds >= 0 then 1 else -1; 
        return fromTime{ seconds = seconds * signal; signal = signal; };
    }

    "Subtracts number of seconds from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime minusSeconds(Integer seconds) => plusSeconds(-seconds);

    "Adds number of milliseconds from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime plusMilliseconds(Integer milliseconds) {
        if ( milliseconds == 0 ) {
            return this;
        }
        value signal = milliseconds >= 0 then 1 else -1; 
        return fromTime{ millis = milliseconds * signal; signal = signal; };
    }

    "Subtracts number of milliseconds from this _date and time_ and returns the resulting [[DateTime]]."
    shared actual DateTime minusMilliseconds(Integer milliseconds) => plusMilliseconds(-milliseconds);

    "Returns new [[DateTime]] with the _day of month_ value set to the specified value.

     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withDay(Integer dayOfMonth) => GregorianDateTime {
        date = date.withDay(dayOfMonth);
        time = time;
    };

    "Returns new [[DateTime]] with the _hours_ value set to the specified value.

     **Note:** It should be a valid _hour_.
     "
    shared actual DateTime withHours(Integer hours) => GregorianDateTime {
        date = date;
        time = time.withHours(hours);
    };

    "Returns new [[DateTime]] with the _year_ value set to the specified value.

     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withYear(Integer year) => GregorianDateTime {
        date = date.withYear(year);
        time = time;
    };

    "Returns new [[DateTime]] with the _month_ value set to the specified value.

     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withMonth(Month month) => GregorianDateTime {
        date = date.withMonth(month);
        time = time;
    };
    
    "Returns new [[DateTime]] with the _week of year_ value set to the specified value.
     
     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withWeekOfYear(Integer weekNumber) => GregorianDateTime {
        date = date.withWeekOfYear(weekNumber); 
        time = time;
    };
    
    "Returns new [[DateTime]] with the _day of week_ value set to the specified value.
     
     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withDayOfWeek(DayOfWeek dayOfWeek) => GregorianDateTime {
        date = date.withDayOfWeek(dayOfWeek);
        time = time;
    };

    "Returns new [[DateTime]] with the _day of week_ value set to the specified value.
     
     **Note:** It should result in a valid gregorian date.
     "
    shared actual DateTime withDayOfYear(Integer dayOfYear) => GregorianDateTime {
        date = date.withDayOfYear(dayOfYear);
        time = time;
    };

    "Returns new [[DateTime]] with the _minutes_ value set to the specified value.

     **Note:** It should be a valid _minute_.
     "
    shared actual DateTime withMinutes(Integer minutes) => GregorianDateTime {
        date = date;
        time = time.withMinutes(minutes);
    };

    "Returns new [[DateTime]] with the _seconds_ value set to the specified value.

     **Note:** It should be a valid _second_.
     "
    shared actual DateTime withSeconds(Integer seconds) => GregorianDateTime {
        date = date;
        time = time.withSeconds(seconds);
    };

    "Returns new [[DateTime]] with the _milliseconds_ value set to the specified value.

     **Note:** It should be a valid _millisecond_.
     "
    shared actual DateTime withMilliseconds(Integer milliseconds) => GregorianDateTime {
        date = date;
        time = time.withMilliseconds(milliseconds);
    };

    "For predecessor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the predecessor is the current value minus 1 millisecond.
     "
    shared actual DateTime predecessor => minusMilliseconds(1);

    "For successor its used the lowest unit of time, this way we can benefit
     from maximum precision. In this case the successor is the current value minus 1 millisecond.
     "
    shared actual DateTime successor => plusMilliseconds(1);

    "Adds specified date period to this date and returns the new [[DateTime]]."
    shared actual DateTime plus(ReadablePeriod amount) => addPeriod { 
        months = amount.years * months.perYear + amount.months; 
        days = amount.days; 
        hours = amount.hours; 
        minutes = amount.minutes; 
        seconds = amount.seconds; 
        milliseconds = amount.milliseconds; 
    };

    "Subtracts specified date period from this date and returns the new [[DateTime]]."
    shared actual DateTime minus( ReadablePeriod amount ) => addPeriod { 
        months = -amount.years * months.perYear + -amount.months; 
        days = -amount.days; 
        hours = -amount.hours; 
        minutes = -amount.minutes; 
        seconds = -amount.seconds; 
        milliseconds = -amount.milliseconds; 
    };

    "This method add the specified fields doing first the subtraction and last the additions.

     The mix between positive and negative fields does not guarantee any expected behavior."
    DateTime addPeriod( Integer months, Integer days, Integer hours, Integer minutes, Integer seconds, Integer milliseconds ) {
        variable DateTime _this = this;

        value totalTime = hours * ms.perHour
                        + minutes * ms.perMinute
                        + seconds * ms.perSecond
                        + milliseconds;
        //do all subtractions first
        if ( totalTime < 0 ) {
            _this = _this.minusMilliseconds(-totalTime);
        }
        if ( days < 0 ) {
            _this = _this.minusDays(-days);
        } 
        if ( months < 0 ) {
            _this = _this.minusMonths(-months);
        }
        
        //now we should do all additions
        if ( months > 0 ) {
            _this = _this.plusMonths(months);
        }
        if ( days > 0 ) {
            _this = _this.plusDays(days);
        } 
        if ( totalTime > 0 ) {
            _this = _this.plusMilliseconds(totalTime);
        }
        
        return _this;
    }

    "[[DateTime]] does not know anything about [[TimeZone]] and it should be supplied to
     create a [[Instant]]." 
    shared actual Instant instant( TimeZone timeZone ) {
        value instant = Instant(unixTime.timeFromFixed(dayOfEra) + millisecondsOfDay);
        return Instant( instant.millisecondsOfEpoch - timeZone.offset(instant) );
    }

    "Returns ISO-8601 formatted String representation of this _Date and Time of day_.\n
     https://en.wikipedia.org/wiki/ISO_8601#Combined_date_and_time_representations"
    shared actual String string => "``date.string``T``time.string``";

    "Returns the period between this and the given [[DateTime]].

     If this [[DateTime]] is before the given [[DateTime]] then return negative period."
    shared actual Period periodFrom(DateTime start) {
        value from = this < start then this else start;
        value to = this < start then start else this;

        value dayConsumed = to.time < from.time then 1 else 0; 

        variable value total = to.millisecondsOfDay >= from.millisecondsOfDay
                               then to.millisecondsOfDay - from.millisecondsOfDay
                               else ms.perDay + to.millisecondsOfDay - from.millisecondsOfDay;

        value hh = total / ms.perHour;
        total =  total % ms.perHour;

        value mm = total / ms.perMinute;
        total =  total % ms.perMinute;

        value ss = total / ms.perSecond;

        Boolean positive = start < this; 
        return Period {
            hours = positive then hh else -hh;
            minutes = positive then mm else -mm;
            seconds = positive then ss else -ss;
            milliseconds = positive then total % ms.perSecond else -(total % ms.perSecond);
        }.plus( positive then  to.date.minusDays(dayConsumed).periodFrom(from.date) 
                         else  to.date.minusDays(dayConsumed).periodTo(from.date));
    }

    "Returns the period between this and the given [[DateTime]].

     If this [[DateTime]] is after the given [[DateTime]] then return negative period."

    shared actual Period periodTo(DateTime end) => end.periodFrom(this);

    "Returns the [[DateTimeRange]] between this and given DateTime."
    shared actual DateTimeRange rangeTo( DateTime other ) => DateTimeRange(this, other);

    "Calculates the based in given time, consuming it for each day if necessary."
    DateTime fromTime( Integer hours = 0, Integer minutes = 0, Integer seconds = 0, Integer millis = 0, Integer signal = 1 ) {

        value inputMillis = hours * ms.perHour 
                          + minutes * ms.perMinute 
                          + seconds * ms.perSecond
                          + millis;

        value days = daysOf.fromMilliseconds(inputMillis) * signal;
        value restOfMillis = floorMod(inputMillis, ms.perDay) * signal
                           + time.millisecondsOfDay;

        value totalDays = days + floorDiv(restOfMillis, ms.perDay);
        value newMillis = floorMod(restOfMillis, ms.perDay);

        Time newTime = (newMillis == time.millisecondsOfDay) 
                       then time else TimeOfDay(newMillis);

        return GregorianDateTime( date.plusDays(totalDays), newTime);
    }

    shared actual DateTime neighbour(Integer offset) => plusMilliseconds(offset);

    shared actual Integer offset(DateTime other) => instant(timeZone.utc).millisecondsOfEpoch
                                                      - other.instant(timeZone.utc).millisecondsOfEpoch;

}
