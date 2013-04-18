import ceylon.time { Period, Duration, time, TimeRange, Time }
import ceylon.test { assertEquals, assertTrue, assertFalse }
import ceylon.time.base { milliseconds, seconds, minutes }

TimeRange firstQuarterDay = time(0, 0).to(time(6, 0));
TimeRange firstQuarterDayReverse = time(6,0).to(time(0,0));
TimeRange lastQuarterDay = time(18, 0).to(time(23, 59));

shared void testEqualsTimeRange() {
    assertTrue(firstQuarterDay.equals(time(0,0).to(time(6,0))));
}

shared void testNotEqualsTimeRangeInverted() {
    assertFalse(firstQuarterDay.equals(time(6,0).to(time(0,0))));
}

shared void testStepTime() {
    assertEquals(milliseconds, firstQuarterDay.step);
}

shared void testAnyExistTime() {
    assertTrue(firstQuarterDay.any( (Time time) => time.minutes == 1));
}

shared void testAnyNotExistTime() {
    assertFalse(time(0, 0).to(time(1, 0)).any(( Time time ) => time.seconds == 91));
}

shared void testRangeTime() {
    assertIntervalTime{
         start = time(8,0);
         end = time(10,0);
         period = Period{ hours = 2; };
         duration = Duration( 2 * milliseconds.perHour );
    };
}

shared void testRangeTimeFourMinutes() {
    assertIntervalTime{
         start = time(8,0);
         end = time(8,4);
         period = Period{ minutes = 4; };
         duration = Duration( 4 * milliseconds.perMinute );
    };
}

shared void testIntervalTimeReverse() {
    assertIntervalTime{
         start = time(10,0);
         end = time(8,0);
         period = Period{ hours = -2; };
         duration = Duration( -2 * milliseconds.perHour );
    };
}

shared void testGapTime() {
    TimeRange gap = time(6,0,0,1).to(time(17,59,59,999));
    assertEquals(gap, firstQuarterDay.gap(lastQuarterDay));    
}

shared void testGapTimeReverse() {
    TimeRange mar = time(4,0).to(time(2,0));
    TimeRange gap = time(4,0,0,1).to(time(5,59,59,999));
    
    assertEquals(gap, time(6,0).to(time(8,0)).gap(mar));    
}

shared void testOverlapTime() {
    TimeRange halfFirstQuarter = time(0,0).to(time(3,0));
    TimeRange overlap = time(0,0).to(time(3,0));

    assertEquals(overlap, firstQuarterDay.overlap(halfFirstQuarter));    
}

shared void testStepMillisReverseTime() {
    TimeRange seconds = time(0,0,59).to(time(0,0,50));
    assertEquals( 9 * milliseconds.perSecond + 1, seconds.size);
    assertEquals( time(0,0,59), seconds.first);
    assertEquals( time(0,0,50), seconds.last);
}

shared void testStepSecondsReverseTime() {
    TimeRange interval = time(0,3).to(time(0,0)).stepBy(seconds);
    assertEquals( 3 * seconds.perMinute +1, interval.size);
    assertEquals( time(0,3), interval.first);
    assertEquals( time(0,0), interval.last);
}

shared void testStepMinutesReverseTime() {
    TimeRange interval = firstQuarterDayReverse.stepBy(minutes);
    assertEquals( 6 * minutes.perHour +1, interval.size);
    assertEquals( time(6,0), interval.first);
    assertEquals( time(0,0), interval.last);
}

shared void testContainsTime() {
    assertEquals(true, time(4,30) in firstQuarterDay);    
}

void assertIntervalTime( Time start, Time end, Period period, Duration? duration = null )  {
    value interval = start.to(end);
    assertEquals(period, interval.period);

    assertEquals( end, start.plus(period) );
    assertEquals( start, end.minus(period) );

    if( exists duration ) {
        assertEquals(duration, interval.duration);
    }
}