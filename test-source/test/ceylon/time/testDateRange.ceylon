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
         period = Period{ days = -27; };
         duration = Duration( -27 * milliseconds.perDay );
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

    DateRange _2014 = date(2014, december, 31).to(date(2014, january, 1));
    assertEquals(_2014, _2015.gap(_2013));
}

shared void testGapDateEmpty() {
    DateRange feb = date(2013, february, 1).to(date(2013, february,28));
    
    assertEquals(empty, jan_date_range_reverse.gap(feb));
}

shared void testOverlapDateEmpty() {
    DateRange decemberRange = date(2013, december, 1).to(date(2013, december, 31));

    assertEquals(empty, jan_date_range.overlap(decemberRange));
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

shared void testGapRulesABSmallerCD() {
    //Combinations to Test: AB < CD
    //C1: 12 gap 56 = (2,5)
    //C2: 12 gap 65 = (2,5)
    //C3: 21 gap 56 = (2,5)
    //C4: 21 gap 65 = (2,5)

    value a = date(2013, january, 1);
    value b = date(2013, january, 2);
    value c = date(2013, january, 5);
    value d = date(2013, january, 6);

    value result = date(2013, january, 3).to( date(2013, january, 4) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.to( b ).gap( c.to( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.to( b ).gap( d.to( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.to( a ).gap( c.to( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.to( a ).gap( d.to( c ) );
    };
}

shared void testGapRulesABHigherCD() {
    //Combinations to Test: AB > CD
    //56 gap 12 = (5,2)
    //56 gap 21 = (5,2)
    //65 gap 12 = (5,2)
    //65 gap 21 = (5,2)

    value a = date(2013, january, 5);
    value b = date(2013, january, 6);
    value c = date(2013, january, 1);
    value d = date(2013, january, 2);

    value result = date(2013, january, 4).to( date(2013, january, 3) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.to( b ).gap( c.to( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.to( b ).gap( d.to( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.to( a ).gap( c.to( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.to( a ).gap( d.to( c ) );
    };
}

shared void testOverlapRulesABSmallerCD() {
    //Combinations to Test: AB < CD
    //C1: 16 overlap 39 = [3,6]
    //C2: 16 overlap 93 = [3,6]
    //C3: 61 overlap 39 = [3,6]
    //C4: 61 overlap 93 = [3,6]

    value a = date(2013, january, 1);
    value b = date(2013, january, 6);
    value c = date(2013, january, 3);
    value d = date(2013, january, 9);

    value result = date(2013, january, 3).to( date(2013, january, 6) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.to( b ).overlap( c.to( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.to( b ).overlap( d.to( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.to( a ).overlap( c.to( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.to( a ).overlap( d.to( c ) );
    };
}

shared void testOverlapRulesABHigherCD() {
    //Combinations to Test: AB > CD
    //39 gap 16 = [6,3]
    //39 gap 61 = [6,3]
    //93 gap 16 = [6,3]
    //93 gap 61 = [6,3]

    value a = date(2013, january, 3);
    value b = date(2013, january, 9);
    value c = date(2013, january, 1);
    value d = date(2013, january, 6);

    value result = date(2013, january, 6).to( date(2013, january, 3) );

    //C1
    assertEquals{ 
        expected = result;
        actual = a.to( b ).overlap( c.to( d ) );
    };

    //C2
    assertEquals{ 
        expected = result;
        actual = a.to( b ).overlap( d.to( c ) );
    };

    //C3
    assertEquals{ 
        expected = result;
        actual = b.to( a ).overlap( c.to( d ) );
    };

    //C4
    assertEquals{ 
        expected = result;
        actual = b.to( a ).overlap( d.to( c ) );
    };
}

void assertIntervalDate( Date start, Date end, Period period, Duration? duration = null )  {
    value interval = start.to(end);
    assertEquals(period, interval.period);

    assertEquals( end, start.plus(period) );
    assertEquals( start, end.minus(period) );

    if( exists duration ) {
        assertEquals(duration, interval.duration);
    }
}