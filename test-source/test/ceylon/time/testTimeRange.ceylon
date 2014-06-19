import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    test
}
import ceylon.time {
    Period,
    Duration,
    time,
    TimeRange,
    Time
}
import ceylon.time.base {
    milliseconds,
    seconds,
    minutes
}

TimeRange firstQuarterDay = time(0, 0).rangeTo(time(6, 0));
TimeRange firstQuarterDayReverse = time(6,0).rangeTo(time(0,0));
TimeRange lastQuarterDay = time(18, 0).rangeTo(time(23, 59));

shared test void testEqualsAndHashTimeRange() {

    TimeRange instanceA_1 = time(6,0).rangeTo(time(18,0));
    TimeRange instanceA_2 = time(6,0).rangeTo(time(18,0));

    TimeRange instanceB_1 = firstQuarterDay;
    TimeRange instanceB_2 = time(0, 0).rangeTo(time(6, 0));

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);

}

shared test void testStepTime() {
    assertEquals(milliseconds, firstQuarterDay.step);
}

shared test void testAnyExistTime() {
    assertTrue(firstQuarterDay.any( (Time time) => time.minutes == 1));
}

shared test void testAnyNotExistTime() {
    assertFalse(time(0, 0).rangeTo(time(0, 0, 15)).any(( Time time ) => time.seconds == 91));
}

shared test void testRangeTime() {
    assertIntervalTime{
        start = time(9,55);
        end = time(10,0);
        period = Period{ minutes = 5; };
        duration = Duration( 5 * milliseconds.perMinute );
    };
}

shared test void testRangeTimeFourMinutes() {
    assertIntervalTime{
         start = time(8,0);
         end = time(8,4);
         period = Period{ minutes = 4; };
         duration = Duration( 4 * milliseconds.perMinute );
    };
}

shared test void testIntervalTimeReverse() {
    assertIntervalTime{
        start = time(10,0);
        end = time(9,58);
        period = Period{ minutes = -2; };
        duration = Duration( -2 * milliseconds.perMinute );
    };
}

shared test void testGapTime() {
    TimeRange gap = time(6,0,0,1).rangeTo(time(17,59,59,999));
    assertEquals(gap, firstQuarterDay.gap(lastQuarterDay));    
}

shared test void testOverlapTime() {
    TimeRange halfFirstQuarter = time(0,0).rangeTo(time(3,0));
    TimeRange overlap = time(0,0).rangeTo(time(3,0));

    assertEquals(overlap, firstQuarterDay.overlap(halfFirstQuarter));
}

shared test void testStepMillisReverseTime() {
    TimeRange seconds = time(0,0,59).rangeTo(time(0,0,50));
    assertEquals( 9 * milliseconds.perSecond + 1, seconds.size);
    assertEquals( time(0,0,59), seconds.first);
    assertEquals( time(0,0,50), seconds.last);
}

shared test void testStepSecondsReverseTime() {
    TimeRange interval = time(0,3).rangeTo(time(0,0)).stepBy(seconds);
    assertEquals( 3 * seconds.perMinute +1, interval.size);
    assertEquals( time(0,3), interval.first);
    assertEquals( time(0,0), interval.last);
}

shared test void testStepMinutesReverseTime() {
    TimeRange interval = firstQuarterDayReverse.stepBy(minutes);
    assertEquals( 6 * minutes.perHour +1, interval.size);
    assertEquals( time(6,0), interval.first);
    assertEquals( time(0,0), interval.last);
}

shared test void testContainsTime() {
    assertEquals(true, time(0,1) in firstQuarterDay);
}

shared test void testGapTimeEmpty() {
    TimeRange noGap = time(2, 0).rangeTo(time(12, 0));
    
    assertEquals(empty, firstQuarterDay.gap(noGap));
}

shared test void testOverlapTimeEmpty() {
    TimeRange noOverlap = time(9, 0).rangeTo(time(12, 0));

    assertEquals(empty, firstQuarterDay.overlap(noOverlap));
}

shared test void testGapRulesABSmallerCD_Time() {
    //Combinations to Test: AB < CD
    //C1: 12 gap 56 = (2,5)
    //C2: 12 gap 65 = (2,5)
    //C3: 21 gap 56 = (2,5)
    //C4: 21 gap 65 = (2,5)

    value a = time(1, 0);
    value b = time(2, 0);
    value c = time(5, 0);
    value d = time(6, 0);

    value result = time(2, 0, 0, 1).rangeTo( time(4, 59, 59, 999) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).gap( c.rangeTo( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).gap( d.rangeTo( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).gap( c.rangeTo( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).gap( d.rangeTo( c ) );
    };
}

shared test void testGapRulesABHigherCD_Time() {
    //Combinations to Test: AB > CD
    //56 gap 12 = (2,5)
    //56 gap 21 = (2,5)
    //65 gap 12 = (2,5)
    //65 gap 21 = (2,5)

    value a = time(5, 0);
    value b = time(6, 0);
    value c = time(1, 0);
    value d = time(2, 0);

    value result = time(2, 0, 0, 1).rangeTo(time(4, 59, 59, 999));

    //C1
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).gap( c.rangeTo( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).gap( d.rangeTo( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).gap( c.rangeTo( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).gap( d.rangeTo( c ) );
    };
}

shared test void testOverlapRulesABSmallerCD_Time() {
    //Combinations to Test: AB < CD
    //C1: 16 overlap 39 = [3,6]
    //C2: 16 overlap 93 = [3,6]
    //C3: 61 overlap 39 = [3,6]
    //C4: 61 overlap 93 = [3,6]

    value a = time(1, 0);
    value b = time(6, 0);
    value c = time(3, 0);
    value d = time(9, 0);

    value result = time(3, 0).rangeTo( time(6, 0) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).overlap( c.rangeTo( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).overlap( d.rangeTo( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).overlap( c.rangeTo( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).overlap( d.rangeTo( c ) );
    };
}

shared test void testOverlapRulesABHigherCD_Time() {
    //Combinations to Test: AB > CD
    //39 gap 16 = [3,6]
    //39 gap 61 = [3,6]
    //93 gap 16 = [3,6]
    //93 gap 61 = [3,6]

    value a = time(3, 0);
    value b = time(9, 0);
    value c = time(1, 0);
    value d = time(6, 0);

    value result = time(3, 0).rangeTo( time(6, 0) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).overlap( c.rangeTo( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.rangeTo( b ).overlap( d.rangeTo( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).overlap( c.rangeTo( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.rangeTo( a ).overlap( d.rangeTo( c ) );
    };
}

void assertIntervalTime( Time start, Time end, Period period, Duration? duration = null )  {
    value range = start.rangeTo(end);
    assertEquals(period, range.period);

    assertEquals( end, start.plus(period) );
    assertEquals( start, end.minus(period) );

    assertEquals( start, range.first );
    assertEquals( end, range.last );

    if( exists duration ) {
        assertEquals(duration, range.duration);
    }
}

test void testTimeRangeString() {
    assertEquals( "09:10:11.000/11:00:00.999", TimeRange(time(9, 10, 11), time(11, 0, 0, 999)).string );
    assertEquals( "23:00:00.000/00:00:00.000", TimeRange(time(23, 0), time(0, 0)).string );
}
