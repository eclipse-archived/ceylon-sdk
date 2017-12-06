/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"It can have one of four forms:
 * [[standardZoneFormat]]: the string, “zzz,” which is a kind of null value
 * [[AbbreviationZoneFormat]]: a single alphabetic string other than “zzz,” in which case that’s the abbreviation
 * [[PairAbbreviationZoneFormat]]: a pair of strings separated by a slash (‘/’), in which case the first string is the abbreviation for the standard time name and the second string is the abbreviation for the daylight saving time name
 * [[ReplacedZoneFormat]]: a string containing “%s,” in which case the “%s” will be replaced by the text in the appropriate Rule’s LETTER column"
shared abstract class ZoneFormat() 
        of standardZoneFormat 
         | AbbreviationZoneFormat
         | PairAbbreviationZoneFormat
         | ReplacedZoneFormat {}

shared object standardZoneFormat extends ZoneFormat(){}

shared class AbbreviationZoneFormat(abbreviation) extends ZoneFormat() {
    shared String abbreviation;
    
    shared actual Boolean equals(Object other) {
        if(is AbbreviationZoneFormat other) {
            return abbreviation == other.abbreviation;
        }
        return false;
    }
    
}

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

shared class ReplacedZoneFormat(format) extends ZoneFormat() {
    shared String format; 
    
    shared actual Boolean equals(Object other) {
        if(is ReplacedZoneFormat other) {
            return format == other.format;
        }
        return false;
    }
}