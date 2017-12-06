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
            assertEquals { expected = date(2013, february, 13); actual = feb_13_2013_18_00_42_0057.date(timeZone.utc); };
    
    shared test void timeReturnsCorrectTimeValue() => 
            assertEquals { expected = time(18, 0, 42, 57); actual = feb_13_2013_18_00_42_0057.time(timeZone.utc); };
    
    shared test void equalsToSameInstant() =>
            assertEquals { expected = feb_13_2013_18_00_42_0057; actual = Instant(1360778442057); };
    
    shared test void sameHashForSameInstant() =>
            assertEquals { expected = feb_13_2013_18_00_42_0057.hash; actual = Instant(1360778442057).hash; };
    
    shared test void stringPrintsISODateInUTC() {
        assertEquals { expected = "2013-02-13T18:00:42.057Z"; actual = Instant(1360778442057).string; };
        assertEquals { expected = "2013-10-30T15:16:55.000Z"; actual = Instant(1383146215000).string; };
    }
    
    shared test void plusPeriod_UTC() {
        value period = Period { years = 2; months = 1;};
        value actual = feb_13_2013_18_00_42_0057.plus(period);
        assertEquals { expected = date(2015,march, 13); actual = actual.date(timeZone.utc); };
        assertEquals { expected = time(18, 0, 42, 57); actual = actual.time(timeZone.utc); };
    }
    
    shared test void minusPeriod_UTC() {
        value period = Period { years = 2; months = 1; days = 3;};
        value actual = feb_13_2013_18_00_42_0057.minus(period);
        assertEquals { expected = date(2011,january, 10); actual = actual.date(timeZone.utc); };
        assertEquals { expected = time(18, 0, 42, 57); actual = actual.time(timeZone.utc); };
    }
    
    shared test void durationTo() {
        value twoDaysduration = ( 2 * milliseconds.perDay );
        value twoDaysAfter = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEpoch + twoDaysduration );
        value duration = feb_13_2013_18_00_42_0057.durationTo( twoDaysAfter );
        
        assertEquals { expected = twoDaysduration; actual = duration.milliseconds; };
    }
    
    shared test void durationFrom() {
        value twoDaysduration = ( 2 * milliseconds.perDay );
        value twoDaysBefore = Instant(feb_13_2013_18_00_42_0057.millisecondsOfEpoch - twoDaysduration );
        value duration =  feb_13_2013_18_00_42_0057.durationFrom(twoDaysBefore);
        
        assertEquals { expected = twoDaysduration; actual = duration.milliseconds; };
    }
    
    shared test void enumerableIsBasedOnOffset() {
        assertEquals { expected = 0; actual = feb_13_2013_18_00_42_0057.offset(feb_13_2013_18_00_42_0057); };
        assertEquals { expected = 1; actual = feb_13_2013_18_00_42_0057.successor.offset(feb_13_2013_18_00_42_0057); };
        assertEquals { expected = -1; actual = feb_13_2013_18_00_42_0057.predecessor.offset(feb_13_2013_18_00_42_0057); };
    }

    
    shared test void enumerablePredecessor() {
        assertEquals { expected = feb_13_2013_18_00_42_0057.predecessor; actual = feb_13_2013_18_00_42_0057.minus(oneMillisecond); };
    }
    shared test void enumerableSuccessor() {
        assertEquals { expected = feb_13_2013_18_00_42_0057.successor; actual = feb_13_2013_18_00_42_0057.plus(oneMillisecond); };
    }
}
