import ceylon.time { Date, Time, DateTime, Instant, Period, zero, DateTimeRange }
import ceylon.time.base { ReadablePeriod, Month, ms=milliseconds, daysOf=days, DayOfWeek, months }
import ceylon.time.chronology { unixTime }
import ceylon.time.internal.math { floorDiv, floorMod }
import ceylon.time.timezone { TimeZone }

"Default implementation of a gregorian calendar"
shared class GregorianDateTime( date, time ) 
    satisfies  DateTime {

    shared actual Date date;
    shared actual Time time;

    shared actual Comparison compare(DateTime other) {
        return date != other.date then date <=> other.date
                                  else time <=> other.time;
    }

    shared actual Integer day => date.day;

    shared actual DayOfWeek dayOfWeek => date.dayOfWeek;

    shared actual Integer dayOfYear => date.dayOfYear;

    shared actual Integer dayOfEra => date.dayOfEra;

    shared actual Integer year => date.year;

    shared actual Boolean leapYear => date.leapYear;

    shared actual Integer weekOfYear => date.weekOfYear;

    shared actual Month month => date.month;

    shared actual Integer hours => time.hours;

    shared actual Integer milliseconds => time.milliseconds;

    shared actual Integer millisecondsOfDay => time.millisecondsOfDay;

    shared actual Integer minutes => time.minutes;

    shared actual Integer minutesOfDay => time.minutesOfDay;

    shared actual Integer seconds => time.seconds;

    shared actual Integer secondsOfDay => time.secondsOfDay;

    shared actual DateTime plusYears(Integer years) {
        return GregorianDateTime { date = date.plusYears(years); time = time; };
    }

    shared actual DateTime minusYears(Integer years) {
        return GregorianDateTime { date = date.minusYears(years); time = time; };
    }

    shared actual DateTime plusMonths(Integer months) {
        return GregorianDateTime { date = date.plusMonths(months); time = time; };
    }

    shared actual DateTime minusMonths(Integer months) {
        return plusMonths(-months);
    }

    shared actual DateTime plusWeeks(Integer weeks) {
        return GregorianDateTime { date = date.plusWeeks(weeks); time = time; };
    }

    shared actual DateTime minusWeeks(Integer weeks) {
        return plusWeeks(-weeks);
    }

    shared actual DateTime plusDays(Integer days) {
        return GregorianDateTime { date = date.plusDays(days); time = time; };
    }

    shared actual DateTime minusDays(Integer days) {
        return plusDays(-days);
    }

    shared actual DateTime plusHours(Integer hours) {
        if ( hours == 0 ) {
            return this;
        }
        value signal = hours >= 0 then 1 else -1; 
        return fromTime{ hours = hours * signal; signal = signal; };
    }

    shared actual DateTime minusHours(Integer hours) {
        return plusHours(-hours);
    }

    shared actual DateTime plusMinutes(Integer minutes) {
        if ( minutes == 0 ) {
            return this;
        }

        value signal = minutes >= 0 then 1 else -1; 
        return fromTime{ minutes = minutes * signal; signal = signal; };
    }

    shared actual DateTime minusMinutes(Integer minutes) {
        return plusMinutes(-minutes);
    }

    shared actual DateTime plusSeconds(Integer seconds) {
        if ( seconds == 0 ) {
            return this;
        }
        value signal = seconds >= 0 then 1 else -1; 
        return fromTime{ seconds = seconds * signal; signal = signal; };
    }

    shared actual DateTime minusSeconds(Integer seconds) {
        return plusSeconds(-seconds);
    }

    shared actual DateTime plusMilliseconds(Integer milliseconds) {
        if ( milliseconds == 0 ) {
            return this;
        }
        value signal = milliseconds >= 0 then 1 else -1; 
        return fromTime{ millis = milliseconds * signal; signal = signal; };
    }

    shared actual DateTime minusMilliseconds(Integer milliseconds) {
        return plusMilliseconds(-milliseconds);
    }

    shared actual DateTime withDay(Integer dayOfMonth) {
        return GregorianDateTime { date = date.withDay(dayOfMonth); time = time; };
    }

    shared actual DateTime withHours(Integer hours) {
        return GregorianDateTime { date = date; time = time.withHours(hours); };
    }

    shared actual DateTime withYear(Integer year) {
        return GregorianDateTime { date = date.withYear(year); time = time; };
    }

    shared actual DateTime withMonth(Month month) {
        return GregorianDateTime( date.withMonth(month), time );
    }

    shared actual DateTime withMinutes(Integer minutes) {
        return GregorianDateTime { date = date; time = time.withMinutes(minutes); };
    }

    shared actual DateTime withSeconds(Integer seconds) {
        return GregorianDateTime { date = date; time = time.withSeconds(seconds); };
    }

    shared actual DateTime withMilliseconds(Integer milliseconds) {
        return GregorianDateTime { date = date; time = time.withMilliseconds(milliseconds); };
    }

    shared actual DateTime predecessor => minusMilliseconds(1);

    shared actual DateTime successor => plusMilliseconds(1);
    shared actual DateTime plus( ReadablePeriod amount ) {
        return addPeriod { 
            months = amount.years * months.perYear + amount.months; 
            days = amount.days; 
            hours = amount.hours; 
            minutes = amount.minutes; 
            seconds = amount.seconds; 
            milliseconds = amount.milliseconds; 
        };
    }

    shared actual DateTime minus( ReadablePeriod amount ) {
        return addPeriod { 
            months = amount.years.negativeValue * months.perYear + amount.months.negativeValue; 
            days = amount.days.negativeValue; 
            hours = amount.hours.negativeValue; 
            minutes = amount.minutes.negativeValue; 
            seconds = amount.seconds.negativeValue; 
            milliseconds = amount.milliseconds.negativeValue; 
        };
    }

    "This method add the specified fields doing first the subtraction and last the additions.
     The mix between positive and negative fields does not guarantee any expected behavior"
    DateTime addPeriod( Integer months, Integer days, Integer hours, Integer minutes, Integer seconds, Integer milliseconds ) {
        variable DateTime _this = this;

        value totalTime = hours * ms.perHour
                        + minutes * ms.perMinute
                        + seconds * ms.perSecond
                        + milliseconds;
        //do all subtractions first
        if ( totalTime < 0 ) {
            _this = _this.minusMilliseconds(totalTime.negativeValue);
        }
        if ( days < 0 ) {
            _this = _this.minusDays(days.negativeValue);
        } 
        if ( months < 0 ) {
            _this = _this.minusMonths(months.negativeValue);
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


    shared actual Instant instant( TimeZone? timeZone ) {
        if (exists timeZone) {
            return nothing;
        }
        return Instant(unixTime.timeFromFixed(dayOfEra) + millisecondsOfDay);
    }

    shared actual Boolean equals( Object other ) {
        if (is GregorianDateTime other) {
            if (this === other){
                return true;
            }

            return day == other.day 
                && time == other.time;
        }
        return false;
    }

    shared actual String string {
        return "``date.string`` ``time.string``";
    }

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

    shared actual Period periodTo(DateTime end) {
        return end.periodFrom(this); 
    }

    "Returns the [[DateTimeRange]] between this and given DateTime"
    shared actual DateTimeRange to( DateTime other ) {
        return DateTimeRange(this, other); 
    }

    DateTime fromTime( Integer hours = 0, Integer minutes = 0, Integer seconds = 0, Integer millis = 0, Integer signal = 1 ) {

        value inputMillis = hours * ms.perHour 
                          + minutes * ms.perMinute 
                          + seconds * ms.perSecond
                          + millis;

        value days = daysOf.fromMillis(inputMillis) * signal;
        value restOfMillis = floorMod(inputMillis, ms.perDay) * signal
                           + time.millisecondsOfDay;

        value totalDays = days + floorDiv(restOfMillis, ms.perDay);
        value newMillis = floorMod(restOfMillis, ms.perDay);

        Time newTime = (newMillis == time.millisecondsOfDay) 
                       then time else TimeOfDay(newMillis);

        return GregorianDateTime( date.plusDays(totalDays), newTime);
    }

}
