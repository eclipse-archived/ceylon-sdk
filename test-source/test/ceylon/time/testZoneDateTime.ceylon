import ceylon.time.timezone { timeZone, zoneDateTime, ZoneDateTime }
import ceylon.time.base { january, december, february, milliseconds }
import ceylon.test { assertEquals }
import ceylon.time { date, Date, Time, time }

ZoneDateTime systemZoned = zoneDateTime(timeZone.system, 2013, january, 1);
ZoneDateTime utcZoned = zoneDateTime(timeZone.utc, 2013, january, 1); 

Integer myFakeSystemZonedOffset = -4 * milliseconds.perHour;

void testDateZoned() {
    assertEquals(date(2013, january, 1), systemZoned.date);
    assertEquals(date(2013, january, 1), utcZoned.date);
}

void testInstantZoned() {
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(timeZone.system, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch + (myFakeSystemZonedOffset));
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zoneDateTime(timeZone.utc, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch);
}

void testMinusDaysZoned() {
    assertEquals(date(2012, december, 31), systemZoned.minusDays(1).date);
    assertEquals(date(2012, december, 31), utcZoned.minusDays(1).date);
}

void testPlusDaysZoned() {
	assertDateAndTime( date(2013, january, 2), time(0,0), systemZoned.plusDays(1));
	assertDateAndTime( date(2013, january, 2), time(0,0), utcZoned.plusDays(1)); 
}

void testMinusMonthsZoned() {
    assertEquals(date(2012, december, 1), systemZoned.minusMonths(1).date);
    assertEquals(date(2012, december, 1), utcZoned.minusMonths(1).date);
}

void testPlusMonthsZoned() {
	assertDateAndTime( date(2013, february, 1), time(0,0), systemZoned.plusMonths(1));
	assertDateAndTime( date(2013, february, 1), time(0,0), utcZoned.plusMonths(1)); 
}

void testPlusYearsZoned() {
	assertDateAndTime( date(2014, january, 1), time(0,0), systemZoned.plusYears(1));
	assertDateAndTime( date(2014, january, 1), time(0,0), utcZoned.plusYears(1)); 
}

void testMinusYearsZoned() {
    assertEquals(date(2012, january, 1), systemZoned.minusYears(1).date);
    assertEquals(date(2012, january, 1), utcZoned.minusYears(1).date);
}

void testPlusMillisecondsZoned() {
	assertDateAndTime( date(2013, january, 1), time(0, 0, 0, 300), systemZoned.plusMilliseconds(300) );
	assertDateAndTime( date(2013, january, 1), time(0, 0, 0, 300), utcZoned.plusMilliseconds(300) );
	
	assertDateAndTime( date(2013, january, 1), time(0, 0, 1, 200), systemZoned.plusMilliseconds(1200) );
	assertDateAndTime( date(2013, january, 1), time(0, 0, 1, 200), utcZoned.plusMilliseconds(1200) );
}

void testMinusMillisecondsZoned() {
	assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), systemZoned.minusMilliseconds(300) );
	assertDateAndTime( date(2012, december, 31), time(23, 59, 59, 700), utcZoned.minusMilliseconds(300) );
	
	assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), systemZoned.minusMilliseconds(1200) );
	assertDateAndTime( date(2012, december, 31), time(23, 59, 58, 800), utcZoned.minusMilliseconds(1200) );
}

void testPlusSecondsZoned() {
	assertDateAndTime( date(2013, january, 1), time(0, 0, 30), systemZoned.plusSeconds(30) );
	assertDateAndTime( date(2013, january, 1), time(0, 0, 30), utcZoned.plusSeconds(30) );
	
	assertDateAndTime( date(2013, january, 1), time(0, 1, 10), systemZoned.plusSeconds(70) );
	assertDateAndTime( date(2013, january, 1), time(0, 1, 10), utcZoned.plusSeconds(70) );
}

void testMinusSecondsZoned() {
	assertDateAndTime( date(2012, december, 31), time(23, 59, 30), systemZoned.minusSeconds(30) );
	assertDateAndTime( date(2012, december, 31), time(23, 59, 30), utcZoned.minusSeconds(30) );
	
	assertDateAndTime( date(2012, december, 31), time(23, 58, 50), systemZoned.minusSeconds(70) );
	assertDateAndTime( date(2012, december, 31), time(23, 58, 50), utcZoned.minusSeconds(70) );
}

void testPlusMinutesZoned() {
	assertDateAndTime( date(2013, january, 1), time(0, 30), systemZoned.plusMinutes(30) );
	assertDateAndTime( date(2013, january, 1), time(0, 30), utcZoned.plusMinutes(30) );
	
	assertDateAndTime( date(2013, january, 1), time(1, 10), systemZoned.plusMinutes(70) );
	assertDateAndTime( date(2013, january, 1), time(1, 10), utcZoned.plusMinutes(70) );
}

void testMinusMinutesZoned() {
	assertDateAndTime( date(2012, december, 31), time(23, 30), systemZoned.minusMinutes(30) );
	assertDateAndTime( date(2012, december, 31), time(23, 30), utcZoned.minusMinutes(30) );
	
	assertDateAndTime( date(2012, december, 31), time(22, 50), systemZoned.minusMinutes(70) );
	assertDateAndTime( date(2012, december, 31), time(22, 50), utcZoned.minusMinutes(70) );
}

void testPlusHoursZoned() {
	assertDateAndTime( date(2013, january, 2), time(0, 0), systemZoned.plusHours(24) );
	assertDateAndTime( date(2013, january, 2), time(0, 0), utcZoned.plusHours(24) );
	
	assertDateAndTime( date(2013, january, 2), time(2, 0), systemZoned.plusHours(26) );
	assertDateAndTime( date(2013, january, 2), time(2, 0), utcZoned.plusHours(26) );
}

void testMinusHoursZoned() {
	assertDateAndTime( date(2012, december, 31), time(0, 0), systemZoned.minusHours(24) );
	assertDateAndTime( date(2012, december, 31), time(0, 0), utcZoned.minusHours(24) );
	
	assertDateAndTime( date(2012, december, 30), time(22, 0), systemZoned.minusHours(26) );
	assertDateAndTime( date(2012, december, 30), time(22, 0), utcZoned.minusHours(26) );
}

void assertDateAndTime( Date date, Time time, ZoneDateTime zoneDateTime) {
	assertEquals(date, zoneDateTime.date);
	assertEquals(time, zoneDateTime.time);
}