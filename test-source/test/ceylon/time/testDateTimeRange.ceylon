import ceylon.time { Date, Period, Duration, date, DateRange, DateTimeRange, dateTime }
import ceylon.test { assertEquals, assertTrue, assertFalse }
import ceylon.time.base { january, march, february, milliseconds, months, years, saturday, days, december }

DateTimeRange jan_date_time_range = dateTime(2013, january, 1).rangeTo(dateTime(2013, january, 31));
DateTimeRange jan_date_time_range_reverse = dateTime(2013, january, 31).rangeTo(dateTime(2013, january, 1));

shared void testEqualsDateTimeRange() {
    assertTrue(jan_date_range.equals(date(2013, january, 1).rangeTo(date(2013, january, 31))));
}

shared void testNotEqualsDateTimeRangeInverted() {
    assertFalse(jan_date_range.equals(date(2013, january, 31).rangeTo(date(2013, january, 1))));
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
         period = Period{ days = -27; };
         duration = Duration( -27 * milliseconds.perDay );
    };
}

shared void testGapDateTimeEmpty() {
    DateTimeRange feb = dateTime(2013, january, 1).rangeTo(dateTime(2013, january,28));
    
    assertEquals(empty, jan_date_time_range.gap(feb));    
}

shared void testOverlapDateTimeEmpty() {
    DateTimeRange decemberRange = dateTime(2013, december, 1).rangeTo(dateTime(2013, december, 31));

    assertEquals(empty, jan_date_time_range.overlap(decemberRange));
}

shared void testGapDateTime() {
    DateRange mar = date(2013, march, 1).rangeTo(date(2013, march, 31));
    DateRange gap = date(2013, february, 1).rangeTo(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range.gap(mar));
}

shared void testGapDateTimeReverse() {
    DateRange mar = date(2013, march, 1).rangeTo(date(2013, march,31));
    DateRange gap = date(2013, february, 1).rangeTo(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range_reverse.gap(mar));
}

shared void testOverlapDateTime() {
    DateRange halfJan = date(2013, january, 5).rangeTo(date(2013, january, 15));
    DateRange overlap = date(2013, january, 5).rangeTo(date(2013, january, 15));

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

shared void testGapRulesABSmallerCD_DateTime() {
    //Combinations to Test: AB < CD
    //C1: 12 gap 56 = (2,5)
    //C2: 12 gap 65 = (2,5)
    //C3: 21 gap 56 = (2,5)
    //C4: 21 gap 65 = (2,5)

    value a = dateTime(2013, january, 1, 9);
    value b = dateTime(2013, january, 2, 15);
    value c = dateTime(2013, january, 5, 9);
    value d = dateTime(2013, january, 6, 15);

    value result = dateTime(2013, january, 2, 15, 0, 0, 1).rangeTo( dateTime(2013, january, 5, 8, 59, 59, 999) );

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

shared void testGapRulesABHigherCD_DateTime() {
    //Combinations to Test: AB > CD
    //56 gap 12 = (5,2)
    //56 gap 21 = (5,2)
    //65 gap 12 = (5,2)
    //65 gap 21 = (5,2)

    value a = dateTime(2013, january, 5, 9);
    value b = dateTime(2013, january, 6, 15);
    value c = dateTime(2013, january, 1, 9);
    value d = dateTime(2013, january, 2, 15);

    value result = dateTime(2013, january, 5, 8, 59, 59, 999).rangeTo( dateTime(2013, january, 2, 15, 0, 0, 1) );

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

shared void testOverlapRulesABSmallerCD_DateTime() {
    //Combinations to Test: AB < CD
    //C1: 16 overlap 39 = [3,6]
    //C2: 16 overlap 93 = [3,6]
    //C3: 61 overlap 39 = [3,6]
    //C4: 61 overlap 93 = [3,6]

    value a = dateTime(2013, january, 1, 9);
    value b = dateTime(2013, january, 6, 15);
    value c = dateTime(2013, january, 3, 9);
    value d = dateTime(2013, january, 9, 15);

    value result = dateTime(2013, january, 3, 9).rangeTo( dateTime(2013, january, 6, 15) );

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

shared void testOverlapRulesABHigherCD_DateTime() {
    //Combinations to Test: AB > CD
    //39 gap 16 = [6,3]
    //39 gap 61 = [6,3]
    //93 gap 16 = [6,3]
    //93 gap 61 = [6,3]

    value a = dateTime(2013, january, 3, 9);
    value b = dateTime(2013, january, 9, 15);
    value c = dateTime(2013, january, 1, 9);
    value d = dateTime(2013, january, 6, 15);

    value result = dateTime(2013, january, 6, 15).rangeTo( dateTime(2013, january, 3, 9) );

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

void assertIntervalDateTime( Date start, Date end, Period period, Duration? duration = null )  {
    value interval = start.rangeTo(end);
    assertEquals(period, interval.period);

    assertEquals( end, start.plus(period) );
    assertEquals( start, end.minus(period) );

    if( exists duration ) {
        assertEquals(duration, interval.duration);
    }
}