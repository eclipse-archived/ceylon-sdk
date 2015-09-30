import ceylon.test { assertEquals, test, assertNull }
import ceylon.time.base { ms=milliseconds }
import ceylon.time.iso8601 { parseTimeZone }
import ceylon.time.timezone { OffsetTimeZone }


shared class ISO8601TimeZoneParserTest() {
    
    shared test void parsesZulu() => assertEquals( parseTimeZone( "Z" ), OffsetTimeZone( 0 ) );
    shared test void parsesZuluNotAllowed() => assertNull( parseTimeZone( "z" ) );
    
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

shared class ISO8601ParserErrorTest() {
    
    //Negative 0
    shared test void negativeZeroIsNotAllowed() {
        assertNull( parseTimeZone( "-00:00" ));
        assertNull( parseTimeZone( "-0000"  ));
        assertNull( parseTimeZone( "-00"    ));
    }

    //Initial
    shared test void emptyTimeZoneIsNotAllowed() =>
            assertNull( parseTimeZone( "" ) );

    
    shared test void unrecognixedInitialCharacter() =>
            assertNull( parseTimeZone( "X0101" ) );


    shared test void unrecognizedCharacterAfterZulu() =>
            assertNull( parseTimeZone( "Za" ) );


    //Signal
    shared test void unexpectedEndOfInputAfterSignal() {
        assertNull( parseTimeZone( "+" ) );
        assertNull( parseTimeZone( "-" ) );
    }
    
    shared test void unexpectedCharacterAfterSignal() {
        assertNull( parseTimeZone( "+a" ) );
        assertNull( parseTimeZone( "-a" ) );
    }

    //Hour
    shared test void unexpectedEndOfInputInHour() => assertNull( parseTimeZone( "+0" ) );
    shared test void unexpectedCharacterInHour() => assertNull( parseTimeZone( "+0a" ) );

    //Colon
    shared test void unexpectedEndOfInputAfterColon() => assertNull( parseTimeZone( "+01:" ) );
    shared test void unexpectedCharacterAfterColon() => assertNull( parseTimeZone( "+01:a" ) );

    //Minutes
    shared test void unexpectedEndOfInputInMinutes() {
        assertNull( parseTimeZone( "+010"  ) );
        assertNull( parseTimeZone( "+01:0" ) );
    }
    
    shared test void unexpectedCharacterInMinutes() {
        assertNull( parseTimeZone( "+010a"  ) );
        assertNull( parseTimeZone( "+01:0a" ) );
    }
    
    shared test void unexpectedCharacterAfterZone() {
        assertNull( parseTimeZone( "+01:00a" ) );
        assertNull( parseTimeZone( "+01:001" ) );
    }
}
