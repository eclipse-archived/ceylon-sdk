import ceylon.test {
    assertEquals,
    fail,
    assertTrue,
    assertFalse,
    test
}
import ceylon.time {
    time,
    Time,
    Period
}
import ceylon.time.base {
    seconds,
    minutes
}

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

test void testHours() {
    for ( Integer h in 1..23 ) {
        assertTime {
            hour = h;
            secondsOfDay = h * seconds.perHour;
            minutesOfDay = h * minutes.perHour;
        };
    }
}

test void testMinutes() {
    for ( Integer m in 1..59 ) {
        assertTime {
            minute = m;
            secondsOfDay = m * seconds.perMinute;
            minutesOfDay = m;
        };
    }
}

test void testSeconds() {
    for ( Integer s in 1..59 ) {
        assertTime {
            second = s;
            secondsOfDay = s;
            minutesOfDay = 0;
        };
    }
}

test void testMilliseconds() {
    for ( Integer ms in 1..999 ) {
        assertTime {
            milli = ms;
        };
    }
}

test void test_09_08_59_0100() => assertTime(9,8,59,100, 32939, 548);
test void test_00_00_0_0000() => assertTime(0,0,0,0, 0, 0);
test void test_23_59_59_999() => assertTime(23,59,59,999, 86399, 1439);

test void testPlusHours() {
    assertEquals( midnight.plusHours(15), time( 15, 0, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(20), time( 10, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(13), time( 3, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(7), time( 21, 20, 7, 59 ) );
    assertEquals( time_14h_20m_07s_59ms.plusHours(2), time( 16, 20, 7, 59 ) );

    value toTime_13 = time(09, 08, 07, 50).plusHours(28); 
    assertEquals( 13, toTime_13.hours);
}

test void testMinusHours() {
    assertEquals( midnight.minusHours(15), time( 9, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.minusHours(20), time( 18, 20, 7, 59 ) );

    assertEquals( time( 9, 0, 0, 0 ).minusHours(28), time( 5, 0, 0, 0 ) );

    value time_5 = time(09, 08, 07, 0050).minusHours(28); 
    assertEquals( 5, time_5.hours);
}

test void testPlusMinutes() {
    assertEquals( time( 0, 15, 0, 0 ), midnight.plusMinutes(15) );
    assertEquals( time( 15, 0, 7, 59 ), time_14h_20m_07s_59ms.plusMinutes(40) );
}

test void testMinusMinutes() {
    assertEquals( time( 23, 45, 0, 0 ), midnight.minusMinutes(15) );
    assertEquals( time( 13, 59, 7, 59 ), time_14h_20m_07s_59ms.minusMinutes(21) );
}

test void testPlusSeconds() {
    assertEquals( midnight.plusSeconds(15), time( 0, 0, 15, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.plusSeconds(54), time( 14, 21, 1, 59 ) );
}

test void testMinusSeconds() {
    assertEquals( midnight.minusSeconds(15), time( 23, 59, 45, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.minusSeconds(21), time( 14, 19, 46, 59 ) );
}

test void testPlusMilliseconds() {
    assertEquals( time( 0, 0, 0, 20 ), midnight.plusMilliseconds( 20 ) );
    assertEquals( time( 14, 20, 8, 0 ), time_14h_20m_07s_59ms.plusMilliseconds( 941 ) );
}

test void testMinusMilliseconds() {
    assertEquals( midnight.minusMilliseconds( 20 ), time( 23, 59, 59, 980 ) );
    //assertEquals( time_14h_20m_07s_59ms.minusMilliseconds( 941 ), time( 14, 20, 6, 118 ) );
}

test void testWithHours30() {
    try {
        midnight.withHours( 30 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

test void testWithHoursNegative() {
    try {
        midnight.withHours( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

test void testWithHours() {
    assertEquals( midnight.withHours( 20 ), time( 20, 0, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withHours( 2 ), time( 2, 20, 7, 59 ) );
}

test void testWithMinutesNegative() {
    try {
        midnight.withMinutes( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

test void testWithMinutes60() {
    try {
        midnight.withMinutes( 60 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

test void testWithMinutes() {
    assertEquals( midnight.withMinutes( 20 ), time( 0, 20, 0, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withMinutes( 2 ), time( 14, 2, 7, 59 ) );
}

test void testWithSecondsNegative() {
    try {
        midnight.withSeconds( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

test void testWithSeconds60() {
    try {
        midnight.withSeconds( 60 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

test void testWithSeconds() {
    assertEquals( midnight.withSeconds( 20 ), time( 0, 0, 20, 0 ) );
    assertEquals( time_14h_20m_07s_59ms.withSeconds( 2 ), time( 14, 20, 2, 59 ) );
}

test void testWithMillisecondsNegative() {
    try {
        midnight.withMilliseconds( -1 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

test void testWithMilliseconds1000() {
    try {
        midnight.withMilliseconds( 1000 );
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

test void testWithMilliseconds() {
    assertEquals( midnight.withMilliseconds( 20 ), time( 0, 0, 0, 20 ) );
    assertEquals( time_14h_20m_07s_59ms.withMilliseconds( 2 ), time( 14, 20, 7, 2 ) );
}

test void testPredecessor_Time() {
    assertEquals( midnight.predecessor, time(23,59,59,999) ); 
}

test void testSuccessor_Time() {
    assertEquals( midnight.successor, time(0,0,0,001) ); 
}

test void testString_Time() {
    assertEquals( midnight.string, "00:00:00.000");
    assertEquals( time_14h_20m_07s_59ms.string, "14:20:07.059");
}

test void testPeriodFrom_Time() {
    Period period = Period{ hours = 9; minutes = 59; seconds = 50; milliseconds = 100;};
    Time from = time(10, 30, 20, 500);
    Time to = time(20,30, 10, 600);
    assertFromToTime(period, from, to);
}

test void testPeriodFrom_TimeNegative() {
    Period period = Period{ hours = -9; minutes = -59; seconds = -50; milliseconds = -100;};
    Time from = time(20,30, 10, 600);
    Time to = time(10, 30, 20, 500);
    assertFromToTime(period, from, to);
}

test void testPeriodFromHour_Time() {
    Period period = Period{ hours = 2;};
    Time from = time(18, 0);
    Time to = time(20,0);
    assertFromToTime(period, from, to);
}

test void testPeriodFromHour_TimeNegative() {
    Period period = Period{ hours = -2;};
    Time from = time(20,0);
    Time to = time(18, 0);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMinSec_Time() {
    Period period = Period{ hours = 9; minutes = 59; seconds = 59; milliseconds = 900;};
    Time from = time(10, 0, 0, 600);
    Time to = time(20, 0, 0, 500);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMinSec_TimeNegative() {
    Period period = Period{ hours = -9; minutes = -59; seconds = -59; milliseconds = -900;};
    Time from = time(20, 0, 0, 500);
    Time to = time(10, 0, 0, 600);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMinuteBefore() {
    Period period = Period{ hours = 9; minutes = 50; };
    Time from = time(10, 20);
    Time to = time(20, 10);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMinuteBeforeNegative() {
    Period period = Period{ hours = -9; minutes = -50; };
    Time from = time(20, 10);
    Time to = time(10, 20);
    assertFromToTime(period, from, to);
}

test void testPeriodFromSecondBefore() {
    Period period = Period{ minutes = 9; seconds = 50; };
    Time from = time(20, 10, 50);
    Time to = time(20, 20, 40);
    assertFromToTime(period, from, to);
}

test void testPeriodFromSecondBeforeNegative() {
    Period period = Period{ minutes = -9; seconds = -50; };
    Time from = time(20, 20, 40);
    Time to = time(20, 10, 50);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMillisecondBefore() {
    Period period = Period{ seconds = 9; milliseconds = 900; };
    Time from = time(20, 20, 40, 500);
    Time to = time(20, 20, 50, 400);
    assertFromToTime(period, from, to);
}

test void testPeriodFromMillisecondBeforeNegative() {
    Period period = Period{ seconds = -9; milliseconds = -900; };
    Time from = time(20, 20, 50, 400);
    Time to = time(20, 20, 40, 500);
    assertFromToTime(period, from, to);
}

test void testEnumerableTime() {
    assertEquals(time_14h_20m_07s_59ms.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue);
    assertEquals(time_14h_20m_07s_59ms.successor.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue + 1);
    assertEquals(time_14h_20m_07s_59ms.predecessor.millisecondsOfDay, time_14h_20m_07s_59ms.integerValue - 1);
}

test void testEqualsAndHashTime() {
    Time instanceA_1 = time(10,9,8,7);
    Time instanceA_2 = time(10,9,8,7);
    Time instanceB_1 = time(20,0);
    Time instanceB_2 = time(20,0);

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
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
