/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
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