import ceylon.time { Time, DateTime }
import ceylon.time.timezone { ZoneDateTime }

"Common interface capable of representing _time of day_."
see(`interface Time`,
    `interface DateTime`,
    `interface ZoneDateTime`)
shared interface ReadableTime {

    "Hour of day."
    shared formal Integer hours;

    "Number of minutes since last full hour."
    shared formal Integer minutes;

    "Number of seconds since last minute."
    shared formal Integer seconds;

    "Number of milliseconds since last second."
    shared formal Integer milliseconds;

    "Number of minutes since the beginning of the day."
    shared formal Integer minutesOfDay;

    "Number of seconds since the beginning of the day."
    shared formal Integer secondsOfDay;

    "Number of milliseconds since the beginning of the day."
    shared formal Integer millisecondsOfDay;

}
