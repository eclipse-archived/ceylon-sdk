import ceylon.time.timezone {...}


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
