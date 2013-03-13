import ceylon.time { Date, Time, DateTime, Instant, Period, zero }
import ceylon.time.base { ReadablePeriod, Month, ms=milliseconds, daysOf=days, DayOfWeek }
import ceylon.time.chronology { unixTime }
import ceylon.time.internal.math { floorDiv, floorMod }
import ceylon.time.timezone { TimeZone }

doc "Default implementation of a gregorian calendar"
shared class GregorianDateTime( date, time ) 
    satisfies  DateTime {

    shared actual Date date;
    shared actual Time time;

    shared actual Comparison compare(DateTime other) {
        return date != other.date then date <=> other.date
                                  else time <=> other.time;
    }

    shared actual Integer day {
        return date.day;
    }

    shared actual DayOfWeek dayOfWeek {
        return date.dayOfWeek;
    }

    shared actual Integer dayOfYear {
        return date.dayOfYear;
    }

    shared actual Integer dayOfEra {
        return date.dayOfEra;
    }

    shared actual Integer year {
        return date.year;
    }

    shared actual Boolean leapYear {
        return date.leapYear;
    }

    shared actual Integer weekOfYear {
        return date.weekOfYear;
    }

    shared actual Month month {
        return date.month;
    }

    shared actual Integer hours {
        return time.hours;
    }

    shared actual Integer milliseconds {
        return time.milliseconds;
    }

    shared actual Integer millisOfDay {
        return time.millisOfDay;
    }

    shared actual Integer minutes {
        return time.minutes;
    }

    shared actual Integer minutesOfDay {
        return time.minutesOfDay;
    }

    shared actual Integer seconds {
        return time.seconds;
    }

    shared actual Integer secondsOfDay {
        return time.secondsOfDay;
    }

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

    shared actual DateTime predecessor {
        return minusMilliseconds(1);
    }

    shared actual DateTime successor {
        return plusMilliseconds(1);    }

    shared actual DateTime plus( ReadablePeriod amount ) {
        return plusYears( amount.years )
              .plusMonths( amount.months )
              .plusDays( amount.days )
              .plusHours( amount.hours )
              .plusMinutes( amount.minutes )
              .plusSeconds( amount.seconds )
              .plusMilliseconds(amount.milliseconds);
    }

    shared actual DateTime minus( ReadablePeriod amount ) {
        return minusMilliseconds(amount.milliseconds) 
              .minusSeconds( amount.seconds )
              .minusMinutes( amount.minutes )
              .minusHours( amount.hours )
              .minusDays( amount.days )
              .minusMonths( amount.months )
              .minusYears( amount.years );
              
    }

    shared actual Instant instant( TimeZone? timeZone ) {
        if (exists timeZone) {
            return nothing;
        }
        return Instant(unixTime.timeFromFixed(dayOfEra) + millisOfDay);
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
        if ( this <= start ) {
            return zero;
        }

        value dayConsumed = this.time < start.time then 1 else 0; 
        
        variable value total = this.millisOfDay >= start.millisOfDay
                               then this.millisOfDay - start.millisOfDay
                               else ms.perDay + this.millisOfDay - start.millisOfDay;

        value hh = total / ms.perHour;
        total =  total % ms.perHour;

        value mm = total / ms.perMinute;
        total =  total % ms.perMinute;

        value ss = total / ms.perSecond;

        return Period {
            hours = hh;
            minutes = mm;
            seconds = ss;
            milliseconds = total % ms.perSecond;
        }.plus( this.date.minusDays(dayConsumed).periodFrom(start.date) );
    }

    shared actual Period periodTo(DateTime end) {
        return end.periodFrom(this); 
    }

    GregorianDateTime fromTime( Integer hours = 0, Integer minutes = 0, Integer seconds = 0, Integer millis = 0, Integer signal = 1 ) {

        value inputMillis = hours * ms.perHour 
                          + minutes * ms.perMinute 
                          + seconds * ms.perSecond
                          + millis;

        value days = daysOf.fromMillis(inputMillis) * signal;
        value restOfMillis = floorMod(inputMillis, ms.perDay) * signal
                           + time.millisOfDay;

        value totalDays = days + floorDiv(restOfMillis, ms.perDay);
        value newMillis = floorMod(restOfMillis, ms.perDay);

        Time newTime = (newMillis == time.millisOfDay) 
                       then time else TimeOfDay(newMillis);

        return GregorianDateTime( date.plusDays(totalDays), newTime);
    }

}
