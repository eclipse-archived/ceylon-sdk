import ceylon.time.timezone { systemTimeZone, zonedDateTime, utcZone, ZoneDateTime }
import ceylon.time.base { january, december, february, milliseconds }
import ceylon.test { assertEquals }
import ceylon.time { date, Date, Time, time }

ZoneDateTime systemZoned = zonedDateTime(systemTimeZone, 2013, january, 1);
ZoneDateTime utcZoned = zonedDateTime(utcZone, 2013, january, 1); 

Integer myFakeSystemZonedOffset = -4 * milliseconds.perHour;

void testDateZoned() {
    assertEquals(date(2013, january, 1), systemZoned.date);
    assertEquals(date(2013, january, 1), utcZoned.date);
}

void testInstantZoned() {
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zonedDateTime(systemTimeZone, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch + (myFakeSystemZonedOffset));
    assertEquals(feb_13_2013_18_00_42_0057.millisecondsOfEpoch, zonedDateTime(utcZone, 2013, february, 13, 18, 0, 42, 57).instant.millisecondsOfEpoch);
}

void testMinusDaysZoned() {
    assertEquals(date(2012, december, 31), systemZoned.minusDays(1).date);
    assertEquals(date(2012, december, 31), utcZoned.minusDays(1).date);
}

void testPlusDaysZoned() {
	assertDateAndTime( date(2013, january, 2), time(0,0), systemZoned.plusDays(1));
	assertDateAndTime( date(2013, january, 2), time(0,0), utcZoned.plusDays(1)); 
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