import ceylon.time { Date, Period, Duration, date, DateRange, DateTimeRange, dateTime }
import ceylon.test { assertEquals, assertTrue, assertFalse }
import ceylon.time.base { january, march, february, milliseconds, months, years, saturday, days, december }

DateTimeRange jan_date_time_range = dateTime(2013, january, 1).to(dateTime(2013, january, 31));
DateTimeRange jan_date_time_range_reverse = dateTime(2013, january, 31).to(dateTime(2013, january, 1));

shared void testEqualsDateTimeRange() {
    assertTrue(jan_date_range.equals(date(2013, january, 1).to(date(2013, january, 31))));
}

shared void testNotEqualsDateTimeRangeInverted() {
    assertFalse(jan_date_range.equals(date(2013, january, 31).to(date(2013, january, 1))));
}

shared void testStepDateTime() {
    assertEquals(days, jan_date_range.step);
}

shared void testAnyExistDateTime() {
    assertTrue(jan_date_range.any(( Date date ) => date.dayOfWeek == saturday));
}

shared void testAnyNotExistDateTime() {
    assertFalse(jan_date_range.any(( Date date ) => date.year == 2014));
}

shared void testRangeDateTime() {
    assertIntervalDateTime{
         start = date(2013, february,1);
         end = date(2013, february,28);
         period = Period{ days = 27; };
         duration = Duration( 27 * milliseconds.perDay );
    };
}

shared void testRangeDateTimeFourYears() {
    assertIntervalDateTime{
         start = date(2010, january, 1);
         end = date(2014, december, 31);
         period = Period{ years = 4; months = 11; days = 30; };
    };
}

shared void testIntervalDateTimeReverse() {
    assertIntervalDateTime{
         start = date(2013, february,28);
         end = date(2013, february,1);
         period = Period{ days = 27; };
         duration = Duration( 27 * milliseconds.perDay );
    };
}

shared void testGapDateTime() {
    DateRange mar = date(2013, march, 1).to(date(2013, march, 31));
    DateRange gap = date(2013, february, 1).to(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range.gap(mar));    
}

shared void testGapDateTimeReverse() {
    DateRange mar = date(2013, march, 1).to(date(2013, march,31));
    DateRange gap = date(2013, february, 1).to(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range_reverse.gap(mar));    
}

shared void testOverlapDateTime() {
    DateRange halfJan = date(2013, january, 5).to(date(2013, january, 15));
    DateRange overlap = date(2013, january, 5).to(date(2013, january, 15));

    assertEquals(overlap, jan_date_range.overlap(halfJan));    
}

shared void testStepDayReverseDateTime() {
    assertEquals( 31, jan_date_range_reverse.size);
    assertEquals( date(2013, january, 31), jan_date_range_reverse.first);
    assertEquals( date(2013, january, 1), jan_date_range_reverse.last);
}

shared void testStepMonthReverseDateTime() {
    DateRange interval = jan_date_range_reverse.stepBy(months);
    assertEquals( 1, interval.size);
    assertEquals( date(2013, january, 31), interval.first);
    assertEquals( date(2013, january, 31), interval.last);
}

shared void testStepYearReverseDateTime() {
    DateRange interval = jan_date_range_reverse.stepBy(years);
    assertEquals( 1, interval.size);
    assertEquals( date(2013, january, 31), interval.first);
    assertEquals( date(2013, january, 31), interval.last);
}

shared void testContainsDateTime() {
    assertEquals(true, date(2013, january, 15) in jan_date_range);    
}

void assertIntervalDateTime( Date start, Date end, Period period, Duration? duration = null )  {
    value interval = start.to(end);
    assertEquals(period, interval.period);

    if ( start <= end ) {
        assertEquals( end, start.plus(period) );
        assertEquals( start, end.minus(period) );
    } else {
        assertEquals( start, end.plus(period) );
        assertEquals( end, start.minus(period) );
    }
    if( exists duration ) {
        assertEquals(duration, interval.duration);
    }
}