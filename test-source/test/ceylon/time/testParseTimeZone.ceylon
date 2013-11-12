import ceylon.test {
    assertEquals,
    test
}
import ceylon.time.base {
    ms=milliseconds
}
import ceylon.time.timezone {
    OffsetTimeZone,
    parseTimeZone,
    ParserError
}

shared test void testISO8601Parser() {
    assertEquals( OffsetTimeZone( 0 ), parseTimeZone( "Z" ) );
    assertEquals( OffsetTimeZone( 0 ), parseTimeZone( "+00:00" ) );
    assertEquals( OffsetTimeZone( 0 ), parseTimeZone( "+0000" ) );
    assertEquals( OffsetTimeZone( 0 ), parseTimeZone( "+00" ) );
    assertEquals( OffsetTimeZone( ms.perHour ), parseTimeZone( "+01" ) );
    assertEquals( OffsetTimeZone( ms.perHour ), parseTimeZone( "+01:00" ) );
    assertEquals( OffsetTimeZone( ms.perHour ), parseTimeZone( "+0100" ) );
    assertEquals( OffsetTimeZone( -ms.perHour ), parseTimeZone( "-01:00" ) );
    assertEquals( OffsetTimeZone( -ms.perHour ), parseTimeZone( "-01" ) );
    assertEquals( OffsetTimeZone( -ms.perHour ), parseTimeZone( "-0100" ) );

    assertEquals( OffsetTimeZone( ms.perHour + ms.perMinute ), parseTimeZone( "+01:01" ) );
    assertEquals( OffsetTimeZone( ms.perHour + ms.perMinute ), parseTimeZone( "+0101" ) );
    assertEquals( OffsetTimeZone( -ms.perHour - ms.perMinute ), parseTimeZone( "-01:01" ) );
    assertEquals( OffsetTimeZone( -ms.perHour - ms.perMinute), parseTimeZone( "-0101" ) );
    assertEquals( OffsetTimeZone( ms.perHour + 11 * ms.perMinute ), parseTimeZone( "+01:11" ) );
    assertEquals( OffsetTimeZone( ms.perHour + 11 * ms.perMinute), parseTimeZone( "+0111" ) );
    assertEquals( OffsetTimeZone( -ms.perHour - 11 * ms.perMinute), parseTimeZone( "-01:11" ) );
    assertEquals( OffsetTimeZone( -ms.perHour - 11 * ms.perMinute), parseTimeZone( "-0111" ) );
}

shared test void testISO8601ParserErrorMessages() {
    //Negative 0
    assertEquals( ParserError("Pattern not allowed by ISO-8601: '-00:00'!"), parseTimeZone( "-00:00" ) );
    assertEquals( ParserError("Pattern not allowed by ISO-8601: '-0000'!"), parseTimeZone( "-0000" ) );
    assertEquals( ParserError("Pattern not allowed by ISO-8601: '-00'!"), parseTimeZone( "-00" ) );

    //Initial
    assertEquals( ParserError("Unexpected end of input! Empty time zone."), parseTimeZone( "" ) );
    assertEquals( ParserError("Unexpected character! Got 'X' but expected: 'Z', '+' or '-'"), parseTimeZone( "X0101" ) );

    //Zulu
    assertEquals( ParserError("Unexpected character! Got 'a' but expected end of input after 'Z'"), parseTimeZone( "Za" ) );

    //Signal
    assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after '+'"), parseTimeZone( "+" ) );
    assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after '-'"), parseTimeZone( "-" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '+'"), parseTimeZone( "+a" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after '-'"), parseTimeZone( "-a" ) );

    //Hours
    assertEquals( ParserError("Unexpected end of input! Expected at two digits for hours but got one."), parseTimeZone( "+0" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+0a" ) );

    //Colon
    assertEquals( ParserError("Unexpected end of input! Expecting a digit [0..9] after ':'"), parseTimeZone( "+01:" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9] after ':'"), parseTimeZone( "+01:a" ) );

    //Minutes
    assertEquals( ParserError("Unexpected end of input! Expected two digits for minutes but got one."), parseTimeZone( "+010" ) );
    assertEquals( ParserError("Unexpected end of input! Expected two digits for minutes but got one."), parseTimeZone( "+01:0" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+010a" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected a digit [0..9]"), parseTimeZone( "+01:0a" ) );
    assertEquals( ParserError("Unexpected character! Got 'a' but expected end of input"), parseTimeZone( "+01:00a" ) );
    assertEquals( ParserError("Unexpected character! Got '1' but expected end of input"), parseTimeZone( "+01:001" ) );
}
