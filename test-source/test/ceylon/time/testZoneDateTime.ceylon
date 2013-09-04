import ceylon.time.timezone { timeZone, zoneDateTime, ZoneDateTime, RuleBasedTimezone, OffsetTimeZone }
import ceylon.time.base { january, december, february, june, july, milliseconds, august, may }
import ceylon.test { assertEquals }
import ceylon.time { date, Date, Time, time, Instant }

Date _2013_01_01 = date(2013, january, 1);
Time _00_00 = time(0,0);
ZoneDateTime systemZoned = zoneDateTime(simpleTimeZone, 2013, january, 1);
ZoneDateTime utcZoned = zoneDateTime(timeZone.utc, 2013, january, 1);
ZoneDateTime _dst_2013_01_01 = zoneDateTime(simpleDstTimeZone, 2013, january, 1);

object simpleTimeZone extends OffsetTimeZone(-4 * milliseconds.perHour) {
}

object simpleDstTimeZone satisfies RuleBasedTimezone {

    // 2013-06-01T00:00:00Z
    Instant start = Instant(1370044800000);
   
    // 2013-07-01T10:00:00
    Instant end   = Instant(1372672800000);

    Integer dstOffset = 1 * milliseconds.perHour;

    shared actual Integer offset(Instant instant)  {
        return ( start <= instant <= end ) 
                    then dstOffset + process.timezoneOffset 
                    else process.timezoneOffset;   
    }
    
}

void testRuleBasedTimeZone() {

    assertDateAndTime(date(2013, june, 1), time(0,0), zoneDateTime(simpleDstTimeZone, 2013, june, 1));

    assertDateAndTime( date(2013, june, 1), time(1,0), _dst_2013_01_01.plusMonths(5) );
    assertDateAndTime( date(2013, july, 1), time(1,0), _dst_2013_01_01.plusMonths(6) );

    assertDateAndTime( _2013_01_01, _00_00, _dst_2013_01_01 );
    assertDateAndTime( date(2013, february, 1), time(0,0), _dst_2013_01_01.plusMonths(1) );
    assertDateAndTime( date(2013, august, 1), time(0,0), _dst_2013_01_01.plusMonths(7) );

    value _dst_2013_06_02 = zoneDateTime(simpleDstTimeZone, 2013, june, 2);
    assertDateAndTime( date(2013, may, 30), time(23,0), _dst_2013_06_02.minusDays(2) );
    assertDateAndTime( date(2013, july, 1), time(0,0), _dst_2013_06_02.plusDays(29) );
    assertDateAndTime( date(2013, july, 1), time(11,0), _dst_2013_06_02.plusDays(29).plusHours(12) );
}

void testDateZoned() {
    assertEquals(_2013_01_01, systemZoned.date);
    assertEquals(_2013_01_01, utcZoned.date);
}

void testInstantZoned() {
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(simpleTimeZone, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch + (process.timezoneOffset));
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(timeZone.utc, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch);
}

void testMinusDaysZoned() {
    assertEquals(date(2012, december, 31), systemZoned.minusDays(1).date);
    assertEquals(date(2012, december, 31), utcZoned.minusDays(1).date);
}

void testPlusDaysZoned() {
    assertDateAndTime( date(2013, january, 2), _00_00, systemZoned.plusDays(1));
    assertDateAndTime( date(2013, january, 2), _00_00, utcZoned.plusDays(1)); 
}

void testMinusMonthsZoned() {
    assertEquals(date(2012, december, 1), systemZoned.minusMonths(1).date);
    assertEquals(date(2012, december, 1), utcZoned.minusMonths(1).date);
}

void testPlusMonthsZoned() {
    assertDateAndTime( date(2013, february, 1), _00_00, systemZoned.plusMonths(1));
    assertDateAndTime( date(2013, february, 1), _00_00, utcZoned.plusMonths(1)); 

    assertDateAndTime( date(2013, june, 1), _00_00, systemZoned.plusMonths(5));
    assertDateAndTime( date(2013, june, 1), _00_00, utcZoned.plusMonths(5)); 
}

void testPlusYearsZoned() {
    assertDateAndTime( date(2014, january, 1), _00_00, systemZoned.plusYears(1));
    assertDateAndTime( date(2014, january, 1), _00_00, utcZoned.plusYears(1)); 
}

void testMinusYearsZoned() {
    assertEquals(date(2012, january, 1), systemZoned.minusYears(1).date);
    assertEquals(date(2012, january, 1), utcZoned.minusYears(1).date);
}

void testPlusMillisecondsZoned() {
    assertDateAndTime( _2013_01_01, time(0, 0, 0, 300), systemZoned.plusMilliseconds(300) );
    assertDateAndTime( _2013_01_01, time(0, 0, 0, 300), utcZoned.plusMilliseconds(300) );
    
    assertDateAndTime( _2013_01_01, time(0, 0, 1, 200), systemZoned.plusMilliseconds(1200) );
    assertDateAndTime( _2013_01_01, time(0, 0, 1, 200), utcZoned.plusMilliseconds(1200) );
}

void testMinusMillisecondsZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), systemZoned.minusMilliseconds(300) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), utcZoned.minusMilliseconds(300) );
    
    assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), systemZoned.minusMilliseconds(1200) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), utcZoned.minusMilliseconds(1200) );
}

void testPlusSecondsZoned() {
    assertDateAndTime( _2013_01_01, time(0, 0, 30), systemZoned.plusSeconds(30) );
    assertDateAndTime( _2013_01_01, time(0, 0, 30), utcZoned.plusSeconds(30) );
    
    assertDateAndTime( _2013_01_01, time(0, 1, 10), systemZoned.plusSeconds(70) );
    assertDateAndTime( _2013_01_01, time(0, 1, 10), utcZoned.plusSeconds(70) );
}

void testMinusSecondsZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 59, 30), systemZoned.minusSeconds(30) );
    assertDateAndTime( date(2012, december, 31), time(23, 59, 30), utcZoned.minusSeconds(30) );
    
    assertDateAndTime( date(2012, december, 31), time(23, 58, 50), systemZoned.minusSeconds(70) );
    assertDateAndTime( date(2012, december, 31), time(23, 58, 50), utcZoned.minusSeconds(70) );
}

void testPlusMinutesZoned() {
    assertDateAndTime( _2013_01_01, time(0, 30), systemZoned.plusMinutes(30) );
    assertDateAndTime( _2013_01_01, time(0, 30), utcZoned.plusMinutes(30) );
    
    assertDateAndTime( _2013_01_01, time(1, 10), systemZoned.plusMinutes(70) );
    assertDateAndTime( _2013_01_01, time(1, 10), utcZoned.plusMinutes(70) );
}

void testMinusMinutesZoned() {
    assertDateAndTime( date(2012, december, 31), time(23, 30), systemZoned.minusMinutes(30) );
    assertDateAndTime( date(2012, december, 31), time(23, 30), utcZoned.minusMinutes(30) );
    
    assertDateAndTime( date(2012, december, 31), time(22, 50), systemZoned.minusMinutes(70) );
    assertDateAndTime( date(2012, december, 31), time(22, 50), utcZoned.minusMinutes(70) );
}

void testPlusHoursZoned() {
    assertDateAndTime( date(2013, january, 2), _00_00, systemZoned.plusHours(24) );
    assertDateAndTime( date(2013, january, 2), _00_00, utcZoned.plusHours(24) );
    
    assertDateAndTime( date(2013, january, 2), time(2, 0), systemZoned.plusHours(26) );
    assertDateAndTime( date(2013, january, 2), time(2, 0), utcZoned.plusHours(26) );
}

void testMinusHoursZoned() {
    assertDateAndTime( date(2012, december, 31), _00_00, systemZoned.minusHours(24) );
    assertDateAndTime( date(2012, december, 31), _00_00, utcZoned.minusHours(24) );
    
    assertDateAndTime( date(2012, december, 30), time(22, 0), systemZoned.minusHours(26) );
    assertDateAndTime( date(2012, december, 30), time(22, 0), utcZoned.minusHours(26) );
}

void testStringZoneDateTime() {
    assertEquals("2013-01-01T00:00:00.000-04:00", _dst_2013_01_01.string);
    assertEquals("2013-06-01T00:00:00.000-03:00", zoneDateTime(simpleDstTimeZone, 2013, june, 1).string);
    assertEquals("2013-01-01T00:00:00.000+00:00", utcZoned.string);
} 

shared void testEnumerableZoneDateTime() {
    assertEquals(systemZoned.instant.millisecondsOfEpoch, systemZoned.integerValue);
    assertEquals(systemZoned.successor.instant.millisecondsOfEpoch, systemZoned.integerValue + 1);
    assertEquals(systemZoned.predecessor.instant.millisecondsOfEpoch, systemZoned.integerValue - 1);

    assertEquals(utcZoned.instant.millisecondsOfEpoch, utcZoned.integerValue);
    assertEquals(utcZoned.successor.instant.millisecondsOfEpoch, utcZoned.integerValue + 1);
    assertEquals(utcZoned.predecessor.instant.millisecondsOfEpoch, utcZoned.integerValue - 1);
}

void assertDateAndTime( Date date, Time time, ZoneDateTime zoneDateTime) {
    assertEquals(date, zoneDateTime.date);
    assertEquals(time, zoneDateTime.time);
}