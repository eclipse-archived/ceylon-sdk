import ceylon.time { Date, Period, Duration, date, DateRange }
import ceylon.test { assertEquals, assertTrue, assertFalse }
import ceylon.time.base { january, march, february, milliseconds, months, years, saturday, days, december }

DateRange jan_date_range = date(2013, january, 1).to(date(2013, january, 31));
DateRange jan_date_range_reverse = date(2013, january, 31).to(date(2013, january, 1));

shared void testEqualsDateRange() {
    assertTrue(jan_date_range.equals(date(2013, january, 1).to(date(2013, january, 31))));
}

shared void testNotEqualsDateRangeInverted() {
    assertFalse(jan_date_range.equals(date(2013, january, 31).to(date(2013, january, 1))));
}

shared void testStepDays() {
    assertEquals(days, jan_date_range.step);
}

shared void testStepMonths() {
    assertEquals(months, jan_date_range.stepBy(months).step);
}

shared void testStepYears() {
    assertEquals(years, jan_date_range.stepBy(years).step);
}

shared void testAnyExist() {
    assertTrue(jan_date_range.any(( Date date ) => date.dayOfWeek == saturday));
}

shared void testAnyNotExist() {
    assertFalse(jan_date_range.any(( Date date ) => date.year == 2014));
}

shared void testRangeDate() {
    assertIntervalDate{
         start = date(2013, february,1);
         end = date(2013, february,28);
         period = Period{ days = 27; };
         duration = Duration( 27 * milliseconds.perDay );
    };
}

shared void testRangeDateFourYears() {
    assertIntervalDate{
         start = date(2010, january, 1);
         end = date(2014, december, 31);
         period = Period{ years = 4; months = 11; days = 30; };
    };
}

shared void testIntervalDateReverse() {
    assertIntervalDate{
         start = date(2013, february,28);
         end = date(2013, february,1);
         period = Period{ days = 27; };
         duration = Duration( 27 * milliseconds.perDay );
    };
}

shared void testGapDate() {
    DateRange mar = date(2013, march, 1).to(date(2013, march, 31));
    DateRange gap = date(2013, february, 1).to(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range.gap(mar));    
}

shared void testGapDateReverse() {
    DateRange mar = date(2013, march, 1).to(date(2013, march,31));
    DateRange gap = date(2013, february, 1).to(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range_reverse.gap(mar));    
}

shared void testGapDateOneYear() {
    DateRange _2013 = date(2013, january, 1).to(date(2013, december, 31));
    DateRange _2015 = date(2015, january, 1).to(date(2015, december, 31));

    DateRange _2014 = date(2014, january, 1).to(date(2014, december, 31));
    assertEquals(_2014, _2015.gap(_2013));    
}

shared void testGapDateNotEnough() {
    DateRange feb = date(2013, february, 1).to(date(2013, february,28));
    
    assertEquals(null, jan_date_range_reverse.gap(feb));    
}

shared void testOverlapDate() {
    DateRange halfJan = date(2013, january, 5).to(date(2013, january, 15));
    DateRange overlap = date(2013, january, 5).to(date(2013, january, 15));

    assertEquals(overlap, jan_date_range.overlap(halfJan));    
}

shared void testStepDayReverse() {
    assertEquals( 31, jan_date_range_reverse.size);
    assertEquals( date(2013, january, 31), jan_date_range_reverse.first);
    assertEquals( date(2013, january, 1), jan_date_range_reverse.last);
}

shared void testStepMonthReverse() {
    DateRange interval = jan_date_range_reverse.stepBy(months);
    assertEquals( 1, interval.size);
    assertEquals( date(2013, january, 31), interval.first);
    assertEquals( date(2013, january, 31), interval.last);
}

shared void testStepYearReverse() {
    DateRange interval = jan_date_range_reverse.stepBy(years);
    assertEquals( 1, interval.size);
    assertEquals( date(2013, january, 31), interval.first);
    assertEquals( date(2013, january, 31), interval.last);
}

shared void testContainsDate() {
    assertEquals(true, date(2013, january, 15) in jan_date_range);    
}

void assertIntervalDate( Date start, Date end, Period period, Duration? duration = null )  {
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