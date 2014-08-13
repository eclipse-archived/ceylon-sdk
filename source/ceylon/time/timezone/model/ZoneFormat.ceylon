"Model for ZoneFormat rules.
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared abstract class ZoneFormat() 
        of standardZoneFormat | AbbreviationZoneFormat 
         | PairAbbreviationZoneFormat | ReplacedZoneFormat {}

shared object standardZoneFormat extends ZoneFormat(){}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class AbbreviationZoneFormat(abbreviation) extends ZoneFormat() {
    shared String abbreviation;
    
    shared actual Boolean equals(Object other) {
        if(is AbbreviationZoneFormat other) {
            return abbreviation == other.abbreviation;
        }
        return false;
    }
    
}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class PairAbbreviationZoneFormat(standardAbbreviation, daylightAbbreviation) extends ZoneFormat() {
    shared String standardAbbreviation;
    shared String daylightAbbreviation;
    
    shared actual Boolean equals(Object other) {
        if(is PairAbbreviationZoneFormat other) {
            return standardAbbreviation == other.standardAbbreviation
                   && daylightAbbreviation == other.daylightAbbreviation;
        }
        return false;
    }
}

"
 
 All the models are intended to be unrelated of the database origin.
 
 P.S.: Its not intended to be used outside of ceylon.time and currently
 its as shared because we need to test it."
shared class ReplacedZoneFormat(format) extends ZoneFormat() {
    shared String format; 
    
    shared actual Boolean equals(Object other) {
        if(is ReplacedZoneFormat other) {
            return format == other.format;
        }
        return false;
    }
}
