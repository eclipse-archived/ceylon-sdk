import ceylon.test { assertEquals, fail, assertTrue, suite }
import ceylon.time { time, Time, Period }
import ceylon.time.base { seconds, minutes }

Time midnight = time(0, 0);

Time time_14h_20m_07s_59ms = time {
    hours = 14;
    minutes = 20;
    seconds = 07;
    milliseconds = 59;
};
//              msOfDay, hours,   minutes, seconds, millis,  minOfDay, secOfDay
alias Table => [Integer, Integer, Integer, Integer, Integer, Integer,  Integer];
{Table+} data = {
//       msOfDay, hh, mm, ss, ms,  mod, sod
        [0,       00, 00, 00, 000, 000, 0000],
        [1000,    00, 00, 01, 000, 000, 0001],
        [60000,   00, 01, 01, 000, 001, 0000],
        [60000,   00, 01, 01, 000, 001, 0000]
};

shared void runTimeTests(String suiteName="Time tests") {
    suite(suiteName,
    "Testing time hours" -> testHours,
    "Testing time minutes" -> testMinutes,
    "Testing time seconds" -> testSeconds,
    "Testing time milliseconds" -> testMilliseconds,
    "Testing time 09_08_59_0100" -> test_09_08_59_0100,
    "Testing time 00_00_0_0000" -> test_00_00_0_0000,
    "Testing time 23_59_59_999" -> test_23_59_59_999,
    "Testing time plus hours" -> testPlusHours,
    "Testing time minus hours" -> testMinusHours,
    "Testing time plus minutes" -> testPlusMinutes,
    "Testing time minus minutes" -> testMinusMinutes,
    "Testing time plus seconds" -> testPlusSeconds,
    "Testing time minus seconds" -> testMinusSeconds,
    "Testing time plus milliseconds" -> testPlusMilliseconds,
    "Testing time minus milliseconds" -> testMinusMilliseconds,
    "Testing time with hours 30" -> testWithHours30,
    "Testing time with hours negative" -> testWithHoursNegative,
    "Testing time with hours" -> testWithHours,
    "Testing time with minutes negative" -> testWithMinutesNegative,
    "Testing time with minutes 60" -> testWithMinutes60,
    "Testing time with minutes" -> testWithMinutes,
    "Testing time with seconds negative" -> testWithSecondsNegative,
    "Testing time with seconds 60" -> testWithSeconds60,
    "Testing time with seconds" -> testWithSeconds,
    "Testing time with milliseconds negative" -> testWithMillisecondsNegative,
    "Testing time with milliseconds 1000" -> testWithMilliseconds1000,
    "Testing time with milliseconds" -> testWithMilliseconds,
    "Testing time predecessor" -> testPredecessor_Time,
    "Testing time successor" -> testSuccessor_Time,
    "Testing time string" -> testString_Time,
    "Testing time period from" -> testPeriodFrom_Time,
    "Testing time period from negative" -> testPeriodFrom_TimeNegative,
    "Testing time period from hour" -> testPeriodFromHour_Time,
    "Testing time period from hour negative" -> testPeriodFromHour_TimeNegative,
    "Testing time period from minute second" -> testPeriodFromMinSec_Time,
    "Testing time period from minute second negative" -> testPeriodFromMinSec_TimeNegative,
    "Testing time period from minute before" -> testPeriodFromMinuteBefore,
    "Testing time period from minute before negative" -> testPeriodFromMinuteBeforeNegative,
    "Testing time period from second before" -> testPeriodFromSecondBefore,
    "Testing time period from second before negative" -> testPeriodFromSecondBeforeNegative,
    "Testing time period from millisecond before" -> testPeriodFromMillisecondBefore,
    "Testing time period from millisecond before negative" -> testPeriodFromMillisecondBeforeNegative,
    "Testing time Enumerable" -> testEnumerableTime
);
}

shared void testHours() {
    for ( Integer h in 1..23 ) {
        assertTime {
            hour = h;
            secondsOfDay = h * seconds.perHour;
            minutesOfDay = h * minutes.perHour;
        };
    }
}

shared void testMinutes() {
    for ( Integer m in 1..59 ) {
        assertTime {
            minute = m;
            secondsOfDay = m * seconds.perMinute;
            minutesOfDay = m;
        };
    }
}

shared void testSeconds() {
    for ( Integer s in 1..59 ) {
        assertTime {
            second = s;
            secondsOfDay = s;
            minutesOfDay = 0;
        };
    }
}

shared void testMilliseconds() {
    for ( Integer ms in 1..999 ) {
        assertTime {
            milli = ms;
        };
    }
}

shared void test_09_08_59_0100() => assertTime(9,8,59,100, 32939, 548);
shared void test_00_00_0_0000() => assertTime(0,0,0,0, 0, 0);
shared void test_23_59_59_999() => assertTime(23,59,59,999, 86399, 1439);

shared void testPlusHours() {
    assertEquals( midnight.plusHours(15), time( 15, 0, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(20), time( 10, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(13), time( 3, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(7), time( 21, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(2), time( 16, 20, 7, 59 ) );

    value toTime_13 = time(09, 08, 07, 50).plusHours(28); 
    assertEquals( 13, toTime_13.hours);
}

shared void testMinusHours() {
    assertEquals( midnight.minusHours(15), time( 9, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.minusHours(20), time( 18, 20, 7, 59 ) );

    assertEquals( time( 9, 0, 0, 0 ).minusHours(28), time( 5, 0, 0, 0 ) );

    value time_5 = time(09, 08, 07, 0050).minusHours(28); 
    assertEquals( 5, time_5.hours);
}

shared void testPlusMinutes() {
    assertEquals( time( 0, 15, 0, 0 ), midnight.plusMinutes(15) );
    assertEquals( time( 15, 0, 7, 59 ), time_14h_20m_07s_59ms.plusMinutes(40) );
}

shared void testMinusMinutes() {
    assertEquals( time( 23, 45, 0, 0 ), midnight.minusMinutes(15) );
    assertEquals( time( 13, 59, 7, 59 ), time_14h_20m_07s_59ms.minusMinutes(21) );
}

shared void testPlusSeconds() {
    assertEquals( midnight.plusSeconds(15), time( 0, 0, 15, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.plusSeconds(54), time( 14, 21, 1, 59 ) );
}

shared void testMinusSeconds() {
    assertEquals( midnight.minusSeconds(15), time( 23, 59, 45, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.minusSeconds(21), time( 14, 19, 46, 59 ) );
}

shared void testPlusMilliseconds() {
    assertEquals( time( 0, 0, 0, 20 ), midnight.plusMilliseconds( 20 ) );
    assertEquals( time( 14, 20, 8, 0 ), time_14h_20m_07s_59ms.plusMilliseconds( 941 ) );
}

shared void testMinusMilliseconds() {
    assertEquals( midnight.minusMilliseconds( 20 ), time( 23, 59, 59, 980 ) );
    //assertEquals( time_14h_20m_07s_59ms.minusMilliseconds( 941 ), time( 14, 20, 6, 118 ) );
}

shared void testWithHours30() {
    try {
        midnight.withHours( 30 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

shared void testWithHoursNegative() {
    try {
        midnight.withHours( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

shared void testWithHours() {
    assertEquals( midnight.withHours( 20 ), time( 20, 0, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withHours( 2 ), time( 2, 20, 7, 59 ) );
}

shared void testWithMinutesNegative() {
    try {
        midnight.withMinutes( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

shared void testWithMinutes60() {
    try {
        midnight.withMinutes( 60 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

shared void testWithMinutes() {
    assertEquals( midnight.withMinutes( 20 ), time( 0, 20, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withMinutes( 2 ), time( 14, 2, 7, 59 ) );
}

shared void testWithSecondsNegative() {
    try {
        midnight.withSeconds( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

shared void testWithSeconds60() {
    try {
        midnight.withSeconds( 60 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

shared void testWithSeconds() {
    assertEquals( midnight.withSeconds( 20 ), time( 0, 0, 20, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withSeconds( 2 ), time( 14, 20, 2, 59 ) );
}

shared void testWithMillisecondsNegative() {
    try {
        midnight.withMilliseconds( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

shared void testWithMilliseconds1000() {
    try {
        midnight.withMilliseconds( 1000 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

shared void testWithMilliseconds() {
    assertEquals( midnight.withMilliseconds( 20 ), time( 0, 0, 0, 20 ) );
    assertEquals( time_14h_20m_07s_59ms.withMilliseconds( 2 ), time( 14, 20, 7, 2 ) );
}

shared void testPredecessor_Time() {
    assertEquals( midnight.predecessor, time(23,59,59,999) ); 
}

shared void testSuccessor_Time() {
    assertEquals( midnight.successor, time(0,0,0,001) ); 
}

shared void testString_Time() {
    assertEquals( midnight.string, "00:00:00.000");
    assertEquals( time_14h_20m_07s_59ms.string, "14:20:07.059");
}

shared void testPeriodFrom_Time() {
    Period period = Period{ hours = 9; minutes = 59; seconds = 50; milliseconds = 100;};
    Time from = time(10, 30, 20, 500);
    Time to = time(20,30, 10, 600);
    assertFromToTime(period, from, to);
}

shared void testPeriodFrom_TimeNegative() {
    Period period = Period{ hours = -9; minutes = -59; seconds = -50; milliseconds = -100;};
    Time from = time(20,30, 10, 600);
    Time to = time(10, 30, 20, 500);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromHour_Time() {
    Period period = Period{ hours = 2;};
    Time from = time(18, 0);
    Time to = time(20,0);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromHour_TimeNegative() {
    Period period = Period{ hours = -2;};
    Time from = time(20,0);
    Time to = time(18, 0);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMinSec_Time() {
    Period period = Period{ hours = 9; minutes = 59; seconds = 59; milliseconds = 900;};
    Time from = time(10, 0, 0, 600);
    Time to = time(20, 0, 0, 500);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMinSec_TimeNegative() {
    Period period = Period{ hours = -9; minutes = -59; seconds = -59; milliseconds = -900;};
    Time from = time(20, 0, 0, 500);
    Time to = time(10, 0, 0, 600);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMinuteBefore() {
    Period period = Period{ hours = 9; minutes = 50; };
    Time from = time(10, 20);
    Time to = time(20, 10);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMinuteBeforeNegative() {
    Period period = Period{ hours = -9; minutes = -50; };
    Time from = time(20, 10);
    Time to = time(10, 20);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromSecondBefore() {
    Period period = Period{ minutes = 9; seconds = 50; };
    Time from = time(20, 10, 50);
    Time to = time(20, 20, 40);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromSecondBeforeNegative() {
    Period period = Period{ minutes = -9; seconds = -50; };
    Time from = time(20, 20, 40);
    Time to = time(20, 10, 50);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMillisecondBefore() {
    Period period = Period{ seconds = 9; milliseconds = 900; };
    Time from = time(20, 20, 40, 500);
    Time to = time(20, 20, 50, 400);
    assertFromToTime(period, from, to);
}

shared void testPeriodFromMillisecondBeforeNegative() {
    Period period = Period{ seconds = -9; milliseconds = -900; };
    Time from = time(20, 20, 50, 400);
    Time to = time(20, 20, 40, 500);
    assertFromToTime(period, from, to);
}

shared void testEnumerableTime() {
    assertEquals(time_14h_20m_07s_59ms.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue);
    assertEquals(time_14h_20m_07s_59ms.successor.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue + 1);
    assertEquals(time_14h_20m_07s_59ms.predecessor.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue - 1);
}

void assertFromToTime( Period period, Time from, Time to ) {
    assertEquals{
      expected = period;
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = period;
      actual = from.periodTo( to );
    };

    assertEquals(to, from.plus(period));
    assertEquals(from, to.minus(period));
}

shared void assertTime( Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0, Integer secondsOfDay = 0, Integer minutesOfDay = 0) {
    Time actual = time( hour, minute, second, milli );
    assertEquals { expected = hour; actual = actual.hours; };
    assertEquals { expected = minute; actual = actual.minutes; };
    assertEquals { expected = second; actual = actual.seconds; };
    assertEquals { expected = milli; actual = actual.milliseconds; };
    assertEquals { expected = secondsOfDay; actual = actual.secondsOfDay; };
    assertEquals { expected = minutesOfDay; actual = actual.minutesOfDay; };
}
