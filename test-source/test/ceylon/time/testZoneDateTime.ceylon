import ceylon.test {
	test,
	assertEquals,
	testSuite
}
import ceylon.time {
	date,
	time,
	Instant,
	Period,
	dateTime
}
import ceylon.time.base {
	milliseconds,
	september,
	june,
	may
}
import ceylon.time.timezone {
	timeZone,
	RuleBasedTimezone,
	OffsetTimeZone
}

testSuite({
	`class OffsetZoneDateTimeTest`,
	`class DstZoneDateTimeTest`,	
	`class ZoneDateTimeEnumerableTest`	
})
shared void allZoneDateTimeTests() {}

shared class OffsetZoneDateTimeTest() {
	
	/*
	 Simple time offset time zone tests
	 */
	Instant september2_12am = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
	Instant september2_22am = september2_12am.plus(Period { hours = 10; });
	Instant september2_02am = september2_12am.minus(Period { hours = 10; });
	
	
	shared test void utcTimeHasNoOffset() =>
			assertEquals(september2_12am.zoneDateTime( timeZone.utc ).time, time(12, 00));
	shared test void utcDateIsNotAffected() =>
			assertEquals(september2_12am.zoneDateTime( timeZone.utc ).date, date(2013, september, 2));

	
	shared test void positiveOffsetAffectsTime() =>
			assertEquals(september2_12am.zoneDateTime( timeZone.offset(+3) ).time, time(15, 00));
	shared test void positiveOffsetCanAffectDate() =>
			assertEquals(september2_22am.zoneDateTime( timeZone.offset(+3) ).date, date(2013, september, 3));

	
	shared test void negativeOffsetAffectsTime() =>
			assertEquals(september2_12am.zoneDateTime( timeZone.offset(-4) ).time, time(8, 00));
	shared test void negativeOffsetCanAffectDate() =>
			assertEquals(september2_02am.zoneDateTime( timeZone.offset(-4) ).date, date(2013, september, 1));
	
}

shared class DstZoneDateTimeTest() {
	
	Instant may_31_12am  = Instant(1370001600000);
	Instant june_1       = Instant(1370044800000);
	Instant june_1_12am  = Instant(1370088000000);
	Instant june_2       = Instant(1370131200000);
	Instant june_2_12am  = Instant(1370174400000);
	
	"Test timezone where daylight savings time period 
	 lasts for one day on _June 1. 2013_ starting at 
	 00:00 and ending with 23:59:59.999 UTC (inclusive)"
	SimpleDstTimeZone dst = SimpleDstTimeZone(june_1, june_2.predecessor, timeZone.offset(2));
	
	shared test void timezoneOffsetIsUsedAfterDst() =>
			assertEquals(june_2_12am.zoneDateTime(dst).time, time(14, 00));
	
	shared test void currentOffsetUsesDaylightOffset() =>
			assertEquals(june_1_12am.zoneDateTime(dst).currentOffsetMilliseconds, 3 * milliseconds.perHour);
	
	shared test void daylightOffsetIsUsedFromTheStartOfDst() =>
			assertEquals(june_1.zoneDateTime(dst).time, time(3,00));
	
	shared test void daylightOffsetIsUsedUntilTheEndOfDst() =>
			assertEquals(dst.end.zoneDateTime(dst).time, time(2, 59, 59, 999));
	
	shared test void daylightOffsetCanAffectDate() =>
			assertEquals(dst.end.zoneDateTime(dst).date, date(2013, june, 2));

	shared test void addingDayWillShiftIntoDst() =>
		assertEquals(may_31_12am.zoneDateTime(dst).plusDays(1).time, time(15, 00));

	shared test void addingDayWillShiftOutOfDst() =>
		assertEquals(june_1_12am.zoneDateTime(dst).plusDays(1).time, time(14, 00));
}

shared class ZoneDateTimeEnumerableTest() {
	Instant may_31_12am  = Instant(1370001600000);
	Instant june_1       = Instant(1370044800000);
	Instant june_2       = Instant(1370131200000);
	
	SimpleDstTimeZone dst = SimpleDstTimeZone(june_1, june_2.predecessor, timeZone.offset(2));
	
	shared test void enumerateUsesOffset() =>
			assertEquals(may_31_12am.zoneDateTime(dst).offset(may_31_12am.zoneDateTime(dst)), 0);
	
	shared test void predecessor() =>
			assertEquals(june_1.zoneDateTime(dst).predecessor,
	                     june_1.predecessor.zoneDateTime(dst));
}

"Simple DST time zone that starts and ends at specified instants (inclusive)
 and has a specified offset from UTC"
class SimpleDstTimeZone(start, end, timezoneOffset) satisfies RuleBasedTimezone {
	shared Instant start;
	shared Instant end;
	
	OffsetTimeZone timezoneOffset;
	OffsetTimeZone dstOffset = OffsetTimeZone(timezoneOffset.offsetMilliseconds + 1 * milliseconds.perHour);

	OffsetTimeZone offsetTimeZone(Instant instant) => 
			( start <= instant <= end ) then dstOffset else timezoneOffset;
	
	shared actual Integer offset(Instant instant) =>
			offsetTimeZone(instant).offset(instant);
}

/*
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
*/
