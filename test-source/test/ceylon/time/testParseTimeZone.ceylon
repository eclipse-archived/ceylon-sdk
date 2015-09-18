import ceylon.test { assertEquals, test }
import ceylon.time.base { ms=milliseconds }
import ceylon.time.iso8601 { ParserError, parseTimeZone }
import ceylon.time.timezone { OffsetTimeZone }


shared class ISO8601TimeZoneParserTest() {
    
    shared test void parsesZulu() 
            => assertEquals( parseTimeZone( "Z" ), OffsetTimeZone( 0 ) );
    
    shared test void parsesZero() {
        assertEquals( parseTimeZone( "+00:00" ), OffsetTimeZone( 0 ) );
        assertEquals( parseTimeZone( "+0000" ),  OffsetTimeZone( 0 ) );
        assertEquals( parseTimeZone( "+00" ),    OffsetTimeZone( 0 ) );
    }
    
    shared test void parsesFullHours() {
        assertEquals( parseTimeZone( "+01" ),    OffsetTimeZone( ms.perHour ));
        assertEquals( parseTimeZone( "+01:00" ), OffsetTimeZone( ms.perHour ));
        assertEquals( parseTimeZone( "+0100" ),  OffsetTimeZone( ms.perHour ));
    }

    shared test void parsesFullNegativeHours() {
        assertEquals( parseTimeZone( "-01:00" ), OffsetTimeZone( -ms.perHour ) );
        assertEquals( parseTimeZone( "-01" ),    OffsetTimeZone( -ms.perHour ) );
        assertEquals( parseTimeZone( "-0100" ),  OffsetTimeZone( -ms.perHour ) );
    }

    shared test void parsesHoursAndMinutes() {
        assertEquals( OffsetTimeZone( ms.perHour + ms.perMinute ), parseTimeZone( "+01:01" ) );
        assertEquals( OffsetTimeZone( ms.perHour + ms.perMinute ), parseTimeZone( "+0101" ) );
        assertEquals( OffsetTimeZone( -ms.perHour - ms.perMinute ), parseTimeZone( "-01:01" ) );
        assertEquals( OffsetTimeZone( -ms.perHour - ms.perMinute), parseTimeZone( "-0101" ) );
        assertEquals( OffsetTimeZone( ms.perHour + 11 * ms.perMinute ), parseTimeZone( "+01:11" ) );
        assertEquals( OffsetTimeZone( ms.perHour + 11 * ms.perMinute), parseTimeZone( "+0111" ) );
        assertEquals( OffsetTimeZone( -ms.perHour - 11 * ms.perMinute), parseTimeZone( "-01:11" ) );
        assertEquals( OffsetTimeZone( -ms.perHour - 11 * ms.perMinute), parseTimeZone( "-0111" ) );
    }
}

shared class ISO8601ParserErrorMessagesTest() {
    
    //Negative 0
    shared test void negativeZeroIsNotAllowed() {
        assertEquals( ParserError("Pattern not allowed by ISO-8601: '-00:00'!"), parseTimeZone( "-00:00" ) );
        assertEquals( ParserError("Pattern not allowed by ISO-8601: '-0000'!"), parseTimeZone( "-0000" ) );
        assertEquals( ParserError("Pattern not allowed by ISO-8601: '-00'!"), parseTimeZone( "-00" ) );
    }

    //Initial
    shared test void emptyTimeZoneIsNotAllowed() {
        assertEquals( ParserError("Unexpected end of input! Empty time zone."), parseTimeZone( "" ) );
    }
    
    shared test void unrecognixedInitialCharacter() {
        assertEquals( ParserError("Unexpected character! Got 'X' but expected: 'Z', '+' or '-'"), parseTimeZone( "X0101" ) );
    }

    shared test void unrecognizedCharacterAfterZulu() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected end of input after 'Z'"), parseTimeZone( "Za" ) );
    }

    //Signal
    shared test void unexpectedEndOfInputAfterSignal() {
        assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after '+'"), parseTimeZone( "+" ) );
        assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after '-'"), parseTimeZone( "-" ) );
    }
    
    shared test void unexpectedCharacterAfterSignal() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '+'"), parseTimeZone( "+a" ) );
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '-'"), parseTimeZone( "-a" ) );
    }

    //Hour
    shared test void unexpectedEndOfInputInHour() {
        assertEquals( ParserError("Unexpected end of input! Expected at two digits for hours but got one."), parseTimeZone( "+0" ) );
    }
    
    shared test void unexpectedCharacterInHour() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+0a" ) );
    }

    //Colon
    shared test void unexpectedEndOfInputAfterColon() {
        assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after ':'"), parseTimeZone( "+01:" ) );
    }
    
    shared test void unexpectedCharacterAfterColon() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after ':'"), parseTimeZone( "+01:a" ) );
    }

    //Minutes
    shared test void unexpectedEndOfInputInMinutes() {
        assertEquals( ParserError("Unexpected end of input! Expected two digits for minutes but got one."), parseTimeZone( "+010" ) );
        assertEquals( ParserError("Unexpected end of input! Expected two digits for minutes but got one."), parseTimeZone( "+01:0" ) );
    }
    
    shared test void unexpectedCharacterInMinutes() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+010a" ) );
        assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+01:0a" ) );
    }
    
    shared test void unexpectedCharacterAfterZone() {
        assertEquals( ParserError("Unexpected character! Got 'a' but expected end of input"), parseTimeZone( "+01:00a" ) );
        assertEquals( ParserError("Unexpected character! Got '1' but expected end of input"), parseTimeZone( "+01:001" ) );
    }
}
