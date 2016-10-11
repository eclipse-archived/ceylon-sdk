import ceylon.time {
    Date,
    DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}
"A common interface of all month like objects.
 
 This interface is common to all data types that
 either partially or fully represent information 
 that can be interpreted as _month_."
see(`interface Date`,
    `interface DateTime`,
    `interface ZoneDateTime`)
shared interface ReadableMonth {

    "Month of the year value of the date."
    shared formal Month month;

}