import ceylon.time.base {
    ReadableDate,
    ReadableTime
}

"Common interface that can represent particular time of day on a specific date in a specific time zone."
shared interface ReadableZoneDateTime
       satisfies ReadableDate & ReadableTime & ReadableTimeZone {}