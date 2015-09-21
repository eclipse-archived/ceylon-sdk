import ceylon.test { assertEquals, test }
import ceylon.time.base { ms=milliseconds }
import ceylon.time.iso8601 { ParserError, parseTimeZone }
import ceylon.time.timezone { OffsetTimeZone }


shared class ISO8601TimeZoneParserTest() {
    
    shared test void parsesZulu() 
            => assertEquals( parseTimeZone( "Z" ), OffsetTimeZone( 0 ) );
    
    shared test void parsesZero() {
        assertEquals( parseTimeZone( "+00:00" ), OffsetTimeZone( 0 ) );
        assertEquals( parseTimeZone( "+0000"  ), OffsetTimeZone( 0 ) );
        assertEquals( parseTimeZone( "+00"    ), OffsetTimeZone( 0 ) );
    }
    
    shared test void parsesFullHours() {
        assertEquals( parseTimeZone( "+01"    ), OffsetTimeZone( ms.perHour ));
        assertEquals( parseTimeZone( "+01:00" ), OffsetTimeZone( ms.perHour ));
        assertEquals( parseTimeZone( "+0100"  ), OffsetTimeZone( ms.perHour ));
    }

    shared test void parsesFullNegativeHours() {
        assertEquals( parseTimeZone( "-01:00" ), OffsetTimeZone( -ms.perHour ) );
        assertEquals( parseTimeZone( "-01"    ), OffsetTimeZone( -ms.perHour ) );
        assertEquals( parseTimeZone( "-0100"  ), OffsetTimeZone( -ms.perHour ) );
    }

    shared test void parsesHoursAndMinutes() {
        assertEquals( parseTimeZone( "+01:01" ), OffsetTimeZone( ms.perHour  + ms.perMinute ) );
        assertEquals( parseTimeZone( "+0101"  ), OffsetTimeZone( ms.perHour  + ms.perMinute ) );
        assertEquals( parseTimeZone( "-01:01" ), OffsetTimeZone( -ms.perHour - ms.perMinute ) );
        assertEquals( parseTimeZone( "-0101"  ), OffsetTimeZone( -ms.perHour - ms.perMinute ) );
        assertEquals( parseTimeZone( "+01:11" ), OffsetTimeZone( ms.perHour  + 11 * ms.perMinute ) );
        assertEquals( parseTimeZone( "+0111"  ), OffsetTimeZone( ms.perHour  + 11 * ms.perMinute) );
        assertEquals( parseTimeZone( "-01:11" ), OffsetTimeZone( -ms.perHour - 11 * ms.perMinute) );
        assertEquals( parseTimeZone( "-0111"  ), OffsetTimeZone( -ms.perHour - 11 * ms.perMinute) );
    }
}

shared class ISO8601ParserErrorMessagesTest() {
    
    //Negative 0
    shared test void negativeZeroIsNotAllowed() {
        assertEquals( parseTimeZone( "-00:00" ), ParserError("Pattern not allowed by ISO-8601: '-00:00'!") );
        assertEquals( parseTimeZone( "-0000"  ), ParserError("Pattern not allowed by ISO-8601: '-0000'!") );
        assertEquals( parseTimeZone( "-00"    ), ParserError("Pattern not allowed by ISO-8601: '-00'!") );
    }

    //Initial
    shared test void emptyTimeZoneIsNotAllowed() =>
        assertEquals( parseTimeZone( "" ),       ParserError("Unexpected end of input! Empty time zone.") );

    
    shared test void unrecognixedInitialCharacter() =>
        assertEquals( parseTimeZone( "X0101" ),  ParserError("Unexpected character! Got 'X' but expected: 'Z', '+' or '-'") );


    shared test void unrecognizedCharacterAfterZulu() =>
        assertEquals( parseTimeZone( "Za" ),     ParserError("Unexpected character! Got 'a' but expected end of input after 'Z'") );


    //Signal
    shared test void unexpectedEndOfInputAfterSignal() {
        assertEquals( parseTimeZone( "+" ),      ParserError("Unexpected end of input! Expecting a digit [0..9] after '+'") );
        assertEquals( parseTimeZone( "-" ),      ParserError("Unexpected end of input! Expecting a digit [0..9] after '-'") );
    }
    
    shared test void unexpectedCharacterAfterSignal() {
        assertEquals( parseTimeZone( "+a" ),    ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '+'") );
        assertEquals( parseTimeZone( "-a" ),    ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '-'") );
    }

    //Hour
    shared test void unexpectedEndOfInputInHour() =>
        assertEquals( parseTimeZone( "+0" ),    ParserError("Unexpected end of input! Expected at two digits for hours but got one.") );
    
    shared test void unexpectedCharacterInHour() {
        assertEquals( parseTimeZone( "+0a" ),   ParserError("Unexpected character! Got 'a' but expected a digit [0..9]") );
    }

    //Colon
    shared test void unexpectedEndOfInputAfterColon() =>
        assertEquals( parseTimeZone( "+01:" ),  ParserError("Unexpected end of input! Expecting a digit [0..9] after ':'") );
    
    shared test void unexpectedCharacterAfterColon() =>
        assertEquals( parseTimeZone( "+01:a" ), ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after ':'") );

    //Minutes
    shared test void unexpectedEndOfInputInMinutes() {
        assertEquals( parseTimeZone( "+010"  ), ParserError("Unexpected end of input! Expected two digits for minutes but got one.") );
        assertEquals( parseTimeZone( "+01:0" ), ParserError("Unexpected end of input! Expected two digits for minutes but got one.") );
    }
    
    shared test void unexpectedCharacterInMinutes() {
        assertEquals( parseTimeZone( "+010a"  ), ParserError("Unexpected character! Got 'a' but expected a digit [0..9]") );
        assertEquals( parseTimeZone( "+01:0a" ), ParserError("Unexpected character! Got 'a' but expected a digit [0..9]") );
    }
    
    shared test void unexpectedCharacterAfterZone() {
        assertEquals( parseTimeZone( "+01:00a" ), ParserError("Unexpected character! Got 'a' but expected end of input") );
        assertEquals( parseTimeZone( "+01:001" ), ParserError("Unexpected character! Got '1' but expected end of input") );
    }
}
