import ceylon.test { assertEquals }
import ceylon.time { date, time, dateTime, Instant, Period }
import ceylon.time.base { september }
import ceylon.time.timezone { timeZone }

shared void testDateTimeToInstantUsesOffset() {
	value localDate = date(2013, september, 02);
	
	assertEquals( localDate.at(time(12, 00)).instant( timeZone.utc ), 
	              localDate.at(time(15, 00)).instant( timeZone.offset( +3 ) ),
	              "Should apply positive timezone offset" );
	
	assertEquals( localDate.at(time(12, 00)).instant( timeZone.utc ), 
	              localDate.at(time( 9, 00)).instant( timeZone.offset( -3 ) ),
	              "Should apply negative timezone offset" );
}

shared void testInstantToTimeUsesOffset() {
	value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
	
	assertEquals( time(12, 00), instant.time( timeZone.utc ) );
	assertEquals( time(15, 00), instant.time( timeZone.offset( 3) ) );
	assertEquals( time( 9, 00), instant.time( timeZone.offset(-3) ) );
}


shared void testInstantToDateUsesOffset() {
	value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
	
	assertEquals( date(2013, september, 02), instant.date( timeZone.utc ) );
	assertEquals( date(2013, september, 03), instant.plus( Period{ hours = 2; }).date( timeZone.offset( 12) ) );
	assertEquals( date(2013, september, 01), instant.minus(Period{ hours = 2; }).date( timeZone.offset(-12) ) );
}

shared void testInstantToDateTimeUsesOffset() {
	value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
	
	assertEquals( dateTime(2013, september, 02, 12, 00), instant.dateTime( timeZone.utc ) );
	assertEquals( dateTime(2013, september, 03,  2, 00), instant.plus( Period{ hours = 2; }).dateTime( timeZone.offset( 12) ) );
	assertEquals( dateTime(2013, september, 01, 22, 00), instant.minus(Period{ hours = 2; }).dateTime( timeZone.offset(-12) ) );
}
