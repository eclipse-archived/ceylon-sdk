import ceylon.test {
	assertEquals,
	test,
	testSuite
}
import ceylon.time {
	Instant,
	fixedTime,
	date,
	Period,
	time,
	now
}
import ceylon.time.base {
	february,
	march,
	january,
	milliseconds
}
import ceylon.time.timezone {
	timeZone
}


shared testSuite({
	//`function testDate`,
	//`function testTime`,
	
	`class InstantTest`
})
void allInstantTests() {}


shared class InstantTest() {
	
	//Wed Feb 13 14:00:42.0057 BOT 2013
	Instant feb_13_2013_18_00_42_0057 = now( fixedTime(1360778442057) );
	
	shared test void dateReturnsCorrectDateValue() =>
			assertEquals(feb_13_2013_18_00_42_0057.date(timeZone.utc), date(2013, february, 13));
	
	shared test void timeReturnsCorrectTimeValue() => 
			assertEquals(feb_13_2013_18_00_42_0057.time(timeZone.utc), time(18, 0, 42, 57));
	
	shared test void equalsToSameInstant() {
		assert(Instant(1360778442057) == feb_13_2013_18_00_42_0057);
	}
	
	shared test void sameHashForSameInstant() {
		assert(Instant(1360778442057).hash == feb_13_2013_18_00_42_0057.hash);
	}
	
	shared test void stringPrintsISODateInUTC() {
		assertEquals( "2013-02-13T18:00:42.057Z", Instant(1360778442057).string );
		assertEquals( "2013-10-30T15:16:55.000Z", Instant(1383146215000).string );
	}
	
	shared test void plusPeriod_UTC() {
		value period = Period { years = 2; months = 1;};
		value actual = feb_13_2013_18_00_42_0057.plus(period);
		assertEquals(date(2015,march, 13), actual.date(timeZone.utc) );
		assertEquals(time(18, 0, 42, 57), actual.time(timeZone.utc) );
	}
	
	shared test void minusPeriod_UTC() {
		value period = Period { years = 2; months = 1; days = 3;};
		value actual = feb_13_2013_18_00_42_0057.minus(period);
		assertEquals(date(2011,january, 10), actual.date(timeZone.utc));
		assertEquals(time(18, 0, 42, 57), actual.time(timeZone.utc));
	}
	
	shared test void durationTo() {
		value twoDaysduration = ( 2 * milliseconds.perDay );
		value twoDaysAfter = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEpoch + twoDaysduration );
		value duration = feb_13_2013_18_00_42_0057.durationTo( twoDaysAfter );
		
		assertEquals( twoDaysduration, duration.milliseconds );
	}
	
	shared test void durationFrom() {
		value twoDaysduration = ( 2 * milliseconds.perDay );
		value twoDaysBefore = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEpoch - twoDaysduration );
		value duration =  feb_13_2013_18_00_42_0057.durationFrom(twoDaysBefore);
		
		assertEquals( twoDaysduration, duration.milliseconds );
	}
	
	shared test void enumerableIsBasedOnMillisecondsFromEpoch() {
		assert(feb_13_2013_18_00_42_0057.offset(feb_13_2013_18_00_42_0057) == 0);
	}

	
	shared test void enumerablePredecessor() {
		assertEquals(feb_13_2013_18_00_42_0057.predecessor, feb_13_2013_18_00_42_0057.minus(oneMillisecond));
	}
	shared test void enumerableSuccessor() {
		assertEquals(feb_13_2013_18_00_42_0057.successor, feb_13_2013_18_00_42_0057.plus(oneMillisecond));
	}
}
