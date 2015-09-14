import ceylon.time.timezone {
    ZoneDateTime,
    TimeZone,
    timeZone
}


"""The [[ZoneDateTime]] value of the given [[string representation|String]] 
   of a [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) zoned datetime 
   format or `null` if the string does not contain valid ISO 8601 formatted 
   zoned datetime value or the datetime is not formatted according to ISO 
   standard."""
see (`function parseDate`, `function parseTime`, `function parseTimeZone`)
shared ZoneDateTime? parseZoneDateTime(String input) {
    if (exists c = input.last, c == 'Z') {
        if (exists dateTime = parseDateTime(input.initial(input.size-1))) {
            return dateTime.instant(timeZone.utc).zoneDateTime(timeZone.utc);
        }
    }
    else if (exists index = input.lastIndexWhere((c) => c in ['+', '-'])) {
        if (is TimeZone zone = timeZone.parse(input[index...]),
            exists dateTime = parseDateTime(input[...index-1])) {
            return dateTime.instant(zone).zoneDateTime(zone);
        }
    }
    return null;
}
