import ceylon.time.timezone.model {
    standardZoneFormat,
    PairAbbreviationZoneFormat,
    ReplacedZoneFormat,
    ZoneFormat,
    AbbreviationZoneFormat
}

shared ZoneFormat parseZoneFormat(String token) {
    if(token == "zzz") {
        return standardZoneFormat;    
    } else if(exists index = token.firstOccurrence('/')) {
        value abbreviation = token.spanTo(index-1);
        value daylightAbbreviation = token.spanFrom(index+1);
        return PairAbbreviationZoneFormat(abbreviation, daylightAbbreviation);
    } else if( exists index = token.firstInclusion("%s")) {
        return ReplacedZoneFormat(token);
    } else if( !token.empty ) {
        return AbbreviationZoneFormat(token);
    }
    
    return standardZoneFormat;
}