import ceylon.time { Date, Time, Instant, DateTime }
import ceylon.time.timezone { ZoneDateTime, TimeZone, tz = timeZone }
import ceylon.time.base { Month, DayOfWeek }

shared class GregorianZonedDateTime(instant, timeZone = tz.system) satisfies ZoneDateTime {

    shared actual TimeZone timeZone;
    shared actual Instant instant;

    shared actual Comparison compare(ZoneDateTime other) {
        return instant.millisecondsOfEpoch <=> other.instant.millisecondsOfEpoch;
    }

    shared actual Integer day => instant.dateTime(timeZone).day;

    shared actual Integer dayOfEra => instant.dateTime(timeZone).dayOfEra;

    shared actual DayOfWeek dayOfWeek => instant.dateTime(timeZone).dayOfWeek;

    shared actual Integer dayOfYear => instant.dateTime(timeZone).dayOfYear;

    shared actual Integer hours => instant.dateTime(timeZone).hours;

    shared actual Boolean leapYear => instant.dateTime(timeZone).leapYear;

    shared actual Integer milliseconds => instant.dateTime(timeZone).milliseconds;

    shared actual Integer millisecondsOfDay => instant.dateTime(timeZone).millisecondsOfDay;

    shared actual Integer minutes => instant.dateTime(timeZone).minutes;

    shared actual Integer minutesOfDay => instant.dateTime(timeZone).minutesOfDay;

    shared actual Month month => instant.dateTime(timeZone).month;

    shared actual Integer seconds => instant.dateTime(timeZone).seconds;

    shared actual Integer secondsOfDay => instant.dateTime(timeZone).secondsOfDay;

    shared actual Integer weekOfYear => instant.dateTime(timeZone).weekOfYear;

    shared actual Integer year => instant.dateTime(timeZone).year;

    shared actual Date date => instant.dateTime(timeZone).date;

    shared actual Time time => instant.dateTime(timeZone).time;

    shared actual ZoneDateTime minusDays(Integer days) => adjust( instant.dateTime(timeZone).minusDays(days) );

    shared actual ZoneDateTime minusHours(Integer hours) => adjust( instant.dateTime(timeZone).minusHours(hours) );

    shared actual ZoneDateTime minusMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).minusMilliseconds(milliseconds) );

    shared actual ZoneDateTime minusMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).minusMinutes(minutes) );

    shared actual ZoneDateTime minusMonths(Integer months) => adjust( instant.dateTime(timeZone).minusMonths(months) );

    shared actual ZoneDateTime minusSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).minusSeconds(seconds) );

    shared actual ZoneDateTime minusWeeks(Integer weeks) => adjust( instant.dateTime(timeZone).minusWeeks(weeks) );

    shared actual ZoneDateTime minusYears(Integer years) => adjust( instant.dateTime(timeZone).minusYears(years) );

    shared actual ZoneDateTime plusDays(Integer days) => adjust( instant.dateTime(timeZone).plusDays(days) );

    shared actual ZoneDateTime plusHours(Integer hours) => adjust( instant.dateTime(timeZone).plusHours(hours) );

    shared actual ZoneDateTime plusMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).plusMilliseconds(milliseconds) );

    shared actual ZoneDateTime plusMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).plusMinutes(minutes) );

    shared actual ZoneDateTime plusMonths(Integer months) => adjust( instant.dateTime(timeZone).plusMonths(months) );

    shared actual ZoneDateTime plusSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).plusSeconds(seconds) );

    shared actual ZoneDateTime plusWeeks(Integer weeks) => adjust( instant.dateTime(timeZone).plusWeeks(weeks) );

    shared actual ZoneDateTime plusYears(Integer years) => adjust( instant.dateTime(timeZone).plusYears(years) );

    shared actual ZoneDateTime withDay(Integer dayOfMonth) => adjust( instant.dateTime(timeZone).withDay(dayOfMonth) );

    shared actual ZoneDateTime withHours(Integer hours) => adjust( instant.dateTime(timeZone).withHours(hours) );

    shared actual ZoneDateTime withMilliseconds(Integer milliseconds) => adjust( instant.dateTime(timeZone).withMilliseconds(milliseconds) );

    shared actual ZoneDateTime withMinutes(Integer minutes) => adjust( instant.dateTime(timeZone).withMinutes(minutes) );

    shared actual ZoneDateTime withMonth(Month month) => adjust( instant.dateTime(timeZone).withMonth(month) );

    shared actual ZoneDateTime withSeconds(Integer seconds) => adjust( instant.dateTime(timeZone).withSeconds(seconds) );

    shared actual ZoneDateTime withYear(Integer year) => adjust( instant.dateTime(timeZone).withYear(year) );

    shared actual ZoneDateTime predecessor => adjust( instant.dateTime(timeZone).predecessor );

    shared actual ZoneDateTime successor => adjust( instant.dateTime(timeZone).successor );

    GregorianZonedDateTime adjust( DateTime resolved ) {
        value newMillisecondsOfEra = millisecondsOfEraFrom( resolved, timeZone );
        return GregorianZonedDateTime( Instant( newMillisecondsOfEra ), timeZone );
    }

}