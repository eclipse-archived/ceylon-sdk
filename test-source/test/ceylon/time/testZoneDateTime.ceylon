import ceylon.test {
    assertEquals
}
import ceylon.time {
    date,
    time,
    Instant, Period
}
import ceylon.time.base {
    milliseconds,
    september, hours, may, july
}
import ceylon.time.timezone {
    timeZone,
    RuleBasedTimezone
}


Instant instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
object dst satisfies RuleBasedTimezone {

    shared Instant start = Instant(1370044800000); // June 1. 2013 00:00 UTC
    shared Instant end   = Instant(1372672800000); // July 1. 2013 00:00 UTC

	Integer tzOffset = 2 * milliseconds.perHour;
    Integer dstOffset = tzOffset + milliseconds.perHour;

    shared actual Integer offset(Instant instant)  {
        return ( start <= instant <= end )
        	   then dstOffset else tzOffset;   
    }
}

void testZoneDateTimeToDateAndTime() {
	// UTC timezone
	assertEquals(time(12, 00), instant.zoneDateTime( timeZone.utc ).time );
	assertEquals(date(2013, september, 2), instant.zoneDateTime( timeZone.utc ).date );

	// Positive offset
	assertEquals(time(15, 00), instant.zoneDateTime( timeZone.offset(+3) ).time );
	assertEquals(date(2013, september, 2), instant.zoneDateTime( timeZone.offset(+3) ).date );

	// Negative offset
	assertEquals(time( 8, 00), instant.zoneDateTime( timeZone.offset( -4 ) ).time );
	assertEquals(date(2013, september, 2), instant.zoneDateTime( timeZone.offset( -4 ) ).date );
}

void testZoneDateTimeBeforeDst() {
	value instant = dst.start.minus( Period{ hours=12; } );
	
	// Assume we've got the correct date
	assertEquals(time(12, 00), instant.zoneDateTime( timeZone.utc ).time );
	assertEquals(date(2013, may, 31), instant.zoneDateTime( timeZone.utc ).date );
	
	// now check the time before DST
	assertEquals(time(14, 00), instant.zoneDateTime( dst ).time);
	assertEquals(date(2013, may, 31), instant.zoneDateTime( dst ).date );
}

void testZoneDateTimeAfterDst() {
	value instant = dst.end.plus( Period{ hours=12; } );
	print( dst.end.zoneDateTime(timeZone.utc));
	
	// Assume we've got the correct date
	assertEquals(time(12, 00), instant.zoneDateTime( timeZone.utc ).time );
	assertEquals(date(2013, july, 1), instant.zoneDateTime( timeZone.utc ).date );
	
	// now check the time before DST
	assertEquals(time(14, 00), instant.zoneDateTime( dst ).time);
	assertEquals(date(2013, july, 1), instant.zoneDateTime( dst ).date );
}


/*
void testRuleBasedTimeZone() {

    assertDateAndTime( date(2013, june, 1), time(0,0), zoneDateTime(testDstTimeZone, 2013, june, 1));

    //assertDateAndTime( _2013_01_01, _00_00, _dst_2013_01_01 );
    //assertDateAndTime( date(2013, february, 1), time(0,0), _dst_2013_01_01.plusMonths(1) );
    //assertDateAndTime( date(2013, august, 1), time(0,0), _dst_2013_01_01.plusMonths(7) );

    //value _dst_2013_06_02 = zoneDateTime(simpleDstTimeZone, 2013, june, 2);
    //assertDateAndTime( date(2013, may, 30), time(23,0), _dst_2013_06_02.minusDays(2) );
    //assertDateAndTime( date(2013, july, 1), time(0,0), _dst_2013_06_02.plusDays(29) );
    //assertDateAndTime( date(2013, july, 1), time(11,0), _dst_2013_06_02.plusDays(29).plusHours(12) );
//}

shared test void testDateZoned() {
    assertEquals(_2013_01_01, systemZoned.date);
    assertEquals(_2013_01_01, utcZoned.date);
}

shared test void testInstantZoned() {
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(simpleTimeZone, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch + simpleTimeZone.offset(zoneDateTime(simpleTimeZone, 2013, february, 13, 18, 0, 42, 57).instant));
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(timeZone.utc, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch);
}

shared test void testMinusDaysZoned() {
    assertEquals(date(2012, december, 31), systemZoned.minusDays(1).date);
    assertEquals(date(2012, december, 31), utcZoned.minusDays(1).date);
}

shared test void testPlusDaysZoned() {
    assertDateAndTime( date(2013, january, 2), _00_00, systemZoned.plusDays(1));
    assertDateAndTime( date(2013, january, 2), _00_00, utcZoned.plusDays(1)); 
}

shared test void testMinusMonthsZoned() {
    assertEquals(date(2012, december, 1), systemZoned.minusMonths(1).date);
    assertEquals(date(2012, december, 1), utcZoned.minusMonths(1).date);
}

shared test void testPlusMonthsZoned() {
    assertDateAndTime( date(2013, february, 1), _00_00, systemZoned.plusMonths(1));
    assertDateAndTime( date(2013, february, 1), _00_00, utcZoned.plusMonths(1)); 

    assertDateAndTime( date(2013, june, 1), _00_00, systemZoned.plusMonths(5));
    assertDateAndTime( date(2013, june, 1), _00_00, utcZoned.plusMonths(5)); 
}

shared test void testPlusYearsZoned() {
    assertDateAndTime( date(2014, january, 1), _00_00, systemZoned.plusYears(1));
    assertDateAndTime( date(2014, january, 1), _00_00, utcZoned.plusYears(1)); 
}

shared test void testMinusYearsZoned() {
    assertEquals(date(2012, january, 1), systemZoned.minusYears(1).date);
    assertEquals(date(2012, january, 1), utcZoned.minusYears(1).date);
}

shared test void testPlusMillisecondsZoned() {
    assertDateAndTime( _2013_01_01, time(0, 0, 0, 300), systemZoned.plusMilliseconds(300) );
    assertDateAndTime( _2013_01_01, time(0, 0, 0, 300), utcZoned.plusMilliseconds(300) );
    
    assertDateAndTime( _2013_01_01, time(0, 0, 1, 200), systemZoned.plusMilliseconds(1200) );
    assertDateAndTime( _2013_01_01, time(0, 0, 1, 200), utcZoned.plusMilliseconds(1200) );
}

shared test void testMinusMillisecondsZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), systemZoned.minusMilliseconds(300) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), utcZoned.minusMilliseconds(300) );
    
    assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), systemZoned.minusMilliseconds(1200) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), utcZoned.minusMilliseconds(1200) );
}

shared test void testPlusSecondsZoned() {
    assertDateAndTime( _2013_01_01, time(0, 0, 30), systemZoned.plusSeconds(30) );
    assertDateAndTime( _2013_01_01, time(0, 0, 30), utcZoned.plusSeconds(30) );
    
    assertDateAndTime( _2013_01_01, time(0, 1, 10), systemZoned.plusSeconds(70) );
    assertDateAndTime( _2013_01_01, time(0, 1, 10), utcZoned.plusSeconds(70) );
}

shared test void testMinusSecondsZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 59, 30), systemZoned.minusSeconds(30) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 30), utcZoned.minusSeconds(30) );
    
    assertDateAndTime( date(2012, december, 31), time(23, 58, 50), systemZoned.minusSeconds(70) );
    assertDateAndTime( date(2012, december, 31), time(23, 58, 50), utcZoned.minusSeconds(70) );
}

shared test void testPlusMinutesZoned() {
    assertDateAndTime( _2013_01_01, time(0, 30), systemZoned.plusMinutes(30) );
    assertDateAndTime( _2013_01_01, time(0, 30), utcZoned.plusMinutes(30) );
    
    assertDateAndTime( _2013_01_01, time(1, 10), systemZoned.plusMinutes(70) );
    assertDateAndTime( _2013_01_01, time(1, 10), utcZoned.plusMinutes(70) );
}

shared test void testMinusMinutesZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 30), systemZoned.minusMinutes(30) );
    assertDateAndTime( date(2012, december, 31), time(23, 30), utcZoned.minusMinutes(30) );
    
    assertDateAndTime( date(2012, december, 31), time(22, 50), systemZoned.minusMinutes(70) );
    assertDateAndTime( date(2012, december, 31), time(22, 50), utcZoned.minusMinutes(70) );
}

shared test void testPlusHoursZoned() {
    assertDateAndTime( date(2013, january, 2), _00_00, systemZoned.plusHours(24) );
    assertDateAndTime( date(2013, january, 2), _00_00, utcZoned.plusHours(24) );
    
    assertDateAndTime( date(2013, january, 2), time(2, 0), systemZoned.plusHours(26) );
    assertDateAndTime( date(2013, january, 2), time(2, 0), utcZoned.plusHours(26) );
}

shared test void testMinusHoursZoned() {
    assertDateAndTime( date(2012, december, 31), _00_00, systemZoned.minusHours(24) );
    assertDateAndTime( date(2012, december, 31), _00_00, utcZoned.minusHours(24) );
    
    assertDateAndTime( date(2012, december, 30), time(22, 0), systemZoned.minusHours(26) );
    assertDateAndTime( date(2012, december, 30), time(22, 0), utcZoned.minusHours(26) );
}

shared test void testStringZoneDateTime() {
//TODO: need refactor to get current  system.timezoneOffset and formatt it to confirm string method is correct.
    //assertEquals("2013-01-01T00:00:00.000-04:00", _dst_2013_01_01.string);
    //assertEquals("2013-06-01T00:00:00.000-03:00", zoneDateTime(simpleDstTimeZone, 2013, june, 1).string);
    assertEquals("2013-06-01T00:00:00.000-04:00", zoneDateTime(simpleTimeZone, 2013, june, 1).string);
    assertEquals("2013-01-01T00:00:00.000Z", utcZoned.string);
    assertEquals("0000-01-01T00:00:00.000Z", utcZoned.withYear(0).string);
    assertEquals("0010-01-01T00:00:00.000Z", utcZoned.withYear(10).string);
    assertEquals("0100-01-01T00:00:00.000Z", utcZoned.withYear(100).string);
} 

shared test void testEnumerableZoneDateTime() {
    assertEquals(systemZoned.instant.millisecondsOfEpoch, systemZoned.integerValue);
    assertEquals(systemZoned.successor.instant.millisecondsOfEpoch, systemZoned.integerValue + 1);
    assertEquals(systemZoned.predecessor.instant.millisecondsOfEpoch, systemZoned.integerValue - 1);

    assertEquals(utcZoned.instant.millisecondsOfEpoch, utcZoned.integerValue);
    assertEquals(utcZoned.successor.instant.millisecondsOfEpoch, utcZoned.integerValue + 1);
    assertEquals(utcZoned.predecessor.instant.millisecondsOfEpoch, utcZoned.integerValue - 1);
}

shared test void testEqualsAndHashZoneDateTime() {
    ZoneDateTime instanceA_1 = zoneDateTime(simpleTimeZone, 2013, january, 1);
    ZoneDateTime instanceA_2 = zoneDateTime(simpleTimeZone, 2013, january, 1);
    ZoneDateTime instanceB_1 = zoneDateTime(simpleTimeZone, 2013, february, 1);
    ZoneDateTime instanceB_2 = zoneDateTime(simpleTimeZone, 2013, february, 1);
    
    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);
    
    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);
    
    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
}


void assertDateAndTime( Date date, Time time, ZoneDateTime zoneDateTime) {
    assertEquals(date, zoneDateTime.date);
    assertEquals(time, zoneDateTime.time);
}
*/
