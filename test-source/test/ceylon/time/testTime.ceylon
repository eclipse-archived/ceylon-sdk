import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    assertThatException,
    test,
    parameters
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

shared test void testHours() {
    for ( Integer h in 1..23 ) {
        assertTime {
            hour = h;
            secondsOfDay = h * seconds.perHour;
            minutesOfDay = h * minutes.perHour;
        };
    }
}

shared test void testMinutes() {
    for ( Integer m in 1..59 ) {
        assertTime {
            minute = m;
            secondsOfDay = m * seconds.perMinute;
            minutesOfDay = m;
        };
    }
}

shared test void testSeconds() {
    for ( Integer s in 1..59 ) {
        assertTime {
            second = s;
            secondsOfDay = s;
            minutesOfDay = 0;
        };
    }
}

shared test void testMilliseconds() {
    for ( Integer ms in 1..999 ) {
        assertTime {
            milli = ms;
        };
    }
}

shared test void test_09_08_59_0100() => assertTime(9,8,59,100, 32939, 548);
shared test void test_00_00_0_0000() => assertTime(0,0,0,0, 0, 0);
shared test void test_23_59_59_999() => assertTime(23,59,59,999, 86399, 1439);

shared test void testPlusHours() {
    assertEquals { expected = midnight.plusHours(15); actual = time( 15, 0, 0, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.plusHours(20); actual = time( 10, 20, 7, 59 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.plusHours(13); actual = time( 3, 20, 7, 59 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.plusHours(7); actual = time( 21, 20, 7, 59 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.plusHours(2); actual = time( 16, 20, 7, 59 ); };

    value toTime_13 = time(09, 08, 07, 50).plusHours(28); 
    assertEquals { expected = 13; actual = toTime_13.hours; };
}

shared test void testMinusHours() {
    assertEquals { expected = midnight.minusHours(15); actual = time( 9, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.minusHours(20); actual = time( 18, 20, 7, 59 ); };

    assertEquals { expected = time( 9, 0, 0, 0 ).minusHours(28); actual = time( 5, 0, 0, 0 ); };

    value time_5 = time(09, 08, 07, 0050).minusHours(28); 
    assertEquals { expected = 5; actual = time_5.hours; };
}

shared test void testPlusMinutes() {
    assertEquals { expected = time( 0, 15, 0, 0 ); actual = midnight.plusMinutes(15); };
    assertEquals { expected = time( 15, 0, 7, 59 ); actual = time_14h_20m_07s_59ms.plusMinutes(40); };
}

shared test void testMinusMinutes() {
    assertEquals { expected = time( 23, 45, 0, 0 ); actual = midnight.minusMinutes(15); };
    assertEquals { expected = time( 13, 59, 7, 59 ); actual = time_14h_20m_07s_59ms.minusMinutes(21); };
}

shared test void testPlusSeconds() {
    assertEquals { expected = midnight.plusSeconds(15); actual = time( 0, 0, 15, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.plusSeconds(54); actual = time( 14, 21, 1, 59 ); };
}

shared test void testMinusSeconds() {
    assertEquals { expected = midnight.minusSeconds(15); actual = time( 23, 59, 45, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.minusSeconds(21); actual = time( 14, 19, 46, 59 ); };
}

shared test void testPlusMilliseconds() {
    assertEquals { expected = time( 0, 0, 0, 20 ); actual = midnight.plusMilliseconds( 20 ); };
    assertEquals { expected = time { hours = 14; minutes = 20; seconds = 8; milliseconds = 0; }; actual = time_14h_20m_07s_59ms.plusMilliseconds( 941 ); };
}

shared test void testMinusMilliseconds() {
    assertEquals { expected = midnight.minusMilliseconds( 20 ); actual = time( 23, 59, 59, 980 ); };
    //assertEquals( time_14h_20m_07s_59ms.minusMilliseconds( 941 ), time( 14, 20, 6, 118 ) );
}

shared test void testWithHours30()
        => assertThatException(() => midnight.withHours( 30 ))
            .hasMessage((String message) => message.contains("Hours value should be between 0 and 23"));

shared test void testWithHoursNegative()
        => assertThatException(() => midnight.withHours( -1 ))
            .hasMessage((String message) => message.contains("Hours value should be between 0 and 23"));

shared test void testWithHours() {
    assertEquals { expected = midnight.withHours( 20 ); actual = time( 20, 0, 0, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.withHours( 2 ); actual = time( 2, 20, 7, 59 ); };
}

shared test void testWithMinutesNegative()
        => assertThatException(() => midnight.withMinutes( -1 ))
            .hasMessage((String message) => message.contains("Minutes value should be between 0 and 59"));

shared test void testWithMinutes60()
        => assertThatException(() => midnight.withMinutes( 60 ))
            .hasMessage((String message) => message.contains("Minutes value should be between 0 and 59"));

shared test void testWithMinutes() {
    assertEquals { expected = midnight.withMinutes( 20 ); actual = time( 0, 20, 0, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.withMinutes( 2 ); actual = time( 14, 2, 7, 59 ); };
}

shared test void testWithSecondsNegative()
        => assertThatException(() => midnight.withSeconds( -1 ))
            .hasMessage((String message) => message.contains("Seconds value should be between 0 and 59"));

shared test void testWithSeconds60()
        => assertThatException(() => midnight.withSeconds( 60 ))
            .hasMessage((String message) => message.contains("Seconds value should be between 0 and 59"));

shared test void testWithSeconds() {
    assertEquals { expected = midnight.withSeconds( 20 ); actual = time( 0, 0, 20, 0 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.withSeconds( 2 ); actual = time( 14, 20, 2, 59 ); };
}

shared test void testWithMillisecondsNegative()
        => assertThatException(() => midnight.withMilliseconds( -1 ))
            .hasMessage((String message) => message.contains("Milliseconds value should be between 0 and 999"));

shared test void testWithMilliseconds1000()
        => assertThatException(() => midnight.withMilliseconds( 1000 ))
            .hasMessage((String message) => message.contains("Milliseconds value should be between 0 and 999"));

shared test void testWithMilliseconds() {
    assertEquals { expected = midnight.withMilliseconds( 20 ); actual = time( 0, 0, 0, 20 ); };
    assertEquals { expected = time_14h_20m_07s_59ms.withMilliseconds( 2 ); actual = time( 14, 20, 7, 2 ); };
}

shared test void testPredecessor_Time() {
    assertEquals { expected = midnight.predecessor; actual = time(23,59,59,999); }; 
}

shared test void testSuccessor_Time() {
    assertEquals { expected = midnight.successor; actual = time(0,0,0,001); }; 
}

shared test void testString_Time() {
    assertEquals { expected = midnight.string; actual = "00:00:00.000"; };
    assertEquals { expected = time_14h_20m_07s_59ms.string; actual = "14:20:07.059"; };
}

[[Period, Time, Time]*] periodTests = [
    [Period{ hours = 9; minutes = 59; seconds = 50; milliseconds = 100;}, time(10, 30, 20, 500), time(20,30, 10, 600)],
    [Period{ hours = -9; minutes = -59; seconds = -50; milliseconds = -100;}, time(20,30, 10, 600), time(10, 30, 20, 500)],
    [Period{ hours = 2;}, time(18, 0), time(20,0)],
    [Period{ hours = -2;}, time(20,0), time(18, 0)],
    [Period{ hours = 9; minutes = 59; seconds = 59; milliseconds = 900;}, time(10, 0, 0, 600), time(20, 0, 0, 500)],
    [Period{ hours = -9; minutes = -59; seconds = -59; milliseconds = -900;}, time(20, 0, 0, 500), time(10, 0, 0, 600)],
    [Period{ hours = 9; minutes = 50; }, time(10, 20),  time(20, 10)],
    [Period{ hours = -9; minutes = -50; }, time(20, 10), time(10, 20)],
    [Period{ minutes = 9; seconds = 50; }, time(20, 10, 50), time(20, 20, 40)],
    [Period{ minutes = -9; seconds = -50; }, time(20, 20, 40), time(20, 10, 50)],
    [Period{ seconds = 9; milliseconds = 900; }, time(20, 20, 40, 500), time(20, 20, 50, 400)],
    [Period{ seconds = -9; milliseconds = -900; }, time(20, 20, 50, 400), time(20, 20, 40, 500)]
];
parameters (`value periodTests`)
shared test void testPeriod(Period period, Time from, Time to) {
    assertEquals{
        expected = period;
        actual = to.periodFrom( from );
    };
    assertEquals{
        expected = period;
        actual = from.periodTo( to );
    };
    
    assertEquals {
        expected = to;
        actual = from.plus(period);
    };
    assertEquals {
        expected = from;
        actual = to.minus(period);
    };
}

shared test void testEnumerableTime() {
    assertEquals { expected = 0; actual = time_14h_20m_07s_59ms.offset(time_14h_20m_07s_59ms); };
    assertEquals { expected = 1; actual = time_14h_20m_07s_59ms.successor.offset(time_14h_20m_07s_59ms); };
    assertEquals { expected = - 1; actual = time_14h_20m_07s_59ms.predecessor.offset(time_14h_20m_07s_59ms); };
}

shared test void testEqualsAndHashTime() {
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

shared void assertTime( Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0, Integer secondsOfDay = 0, Integer minutesOfDay = 0) {
    Time actual = time( hour, minute, second, milli );
    assertEquals { expected = hour; actual = actual.hours; };
    assertEquals { expected = minute; actual = actual.minutes; };
    assertEquals { expected = second; actual = actual.seconds; };
    assertEquals { expected = milli; actual = actual.milliseconds; };
    assertEquals { expected = secondsOfDay; actual = actual.secondsOfDay; };
    assertEquals { expected = minutesOfDay; actual = actual.minutesOfDay; };
}
