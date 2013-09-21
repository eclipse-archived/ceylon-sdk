import ceylon.time { Date, Period, Duration, date, DateRange }
import ceylon.test { assertEquals, assertTrue, assertFalse, suite }
import ceylon.time.base { january, march, february, milliseconds, months, years, saturday, days, december }

DateRange jan_date_range = date(2013, january, 1).rangeTo(date(2013, january, 31));
DateRange jan_date_range_reverse = date(2013, january, 31).rangeTo(date(2013, january, 1));

shared void runDateRangeTests(String suiteName="DateRange tests") {
    suite(suiteName,
    "Testing date range equals" -> testEqualsDateRange,
    "Testing date range not equals inverted" -> testNotEqualsDateRangeInverted,
    "Testing date range step days" -> testStepDays,
    "Testing date range step months" -> testStepMonths,
    "Testing date range step years" -> testStepYears,
    "Testing date range any exist" -> testAnyExist,
    "Testing date range any not exist" -> testAnyNotExist,
    "Testing date range range" -> testRangeDate,
    "Testing date range range for years" -> testRangeDateFourYears,
    "Testing date range interval reverse" -> testIntervalDateReverse,
    "Testing date range gap date" -> testGapDate,
    "Testing date range gap date reverse" -> testGapDateReverse,
    "Testing date range gap date year" -> testGapDateOneYear,
    "Testing date range gap date empty" -> testGapDateEmpty,
    "Testing date range overlap date empty" -> testOverlapDateEmpty,
    "Testing date range overlap date" -> testOverlapDate,
    "Testing date range step day reverse" -> testStepDayReverse,
    "Testing date range step month reverse" -> testStepMonthReverse,
    "Testing date range step year reverse" -> testStepYearReverse,
    "Testing date range contains date" -> testContainsDate,
    "Testing date range not contains date" -> testNotContainsDate,
    "Testing date range gap rules AB < CD" -> testGapRulesABSmallerCD,
    "Testing date range gap rules AB > CD" -> testGapRulesABHigherCD,
    "Testing date range overlap rules AB < CD" -> testOverlapRulesABSmallerCD,
    "Testing date range overlap rules AB > CD" -> testOverlapRulesABHigherCD
);
}

shared void testEqualsDateRange() {
    assertTrue(jan_date_range.equals(date(2013, january, 1).rangeTo(date(2013, january, 31))));
}

shared void testNotEqualsDateRangeInverted() {
    assertFalse(jan_date_range.equals(date(2013, january, 31).rangeTo(date(2013, january, 1))));
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
    DateRange mar = date(2013, march, 1).rangeTo(date(2013, march, 31));
    DateRange gap = date(2013, february, 1).rangeTo(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range.gap(mar));
}

shared void testGapDateReverse() {
    DateRange mar = date(2013, march, 1).rangeTo(date(2013, march,31));
    DateRange gap = date(2013, february, 1).rangeTo(date(2013, february, 28));
    
    assertEquals(gap, jan_date_range_reverse.gap(mar));
}

shared void testGapDateOneYear() {
    DateRange _2013 = date(2013, january, 1).rangeTo(date(2013, december, 31));
    DateRange _2015 = date(2015, january, 1).rangeTo(date(2015, december, 31));

    DateRange _2014 = date(2014, january, 1).rangeTo(date(2014, december, 31));
    assertEquals(_2014, _2015.gap(_2013));
}

shared void testGapDateEmpty() {
    DateRange feb = date(2013, february, 1).rangeTo(date(2013, february,28));
    
    assertEquals(empty, jan_date_range_reverse.gap(feb));
}

shared void testOverlapDateEmpty() {
    DateRange decemberRange = date(2013, december, 1).rangeTo(date(2013, december, 31));

    assertEquals(empty, jan_date_range.overlap(decemberRange));
}

shared void testOverlapDate() {
    DateRange halfJan = date(2013, january, 5).rangeTo(date(2013, january, 15));
    DateRange overlap = date(2013, january, 5).rangeTo(date(2013, january, 15));

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

shared void testNotContainsDate() {
    assertEquals(false, date(2013, january, 15) in jan_date_range.stepBy(years));   
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

    value result = date(2013, january, 3).rangeTo( date(2013, january, 4) );

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

shared void testGapRulesABHigherCD() {
    //Combinations to Test: AB > CD
    //56 gap 12 = (2,5)
    //56 gap 21 = (2,5)
    //65 gap 12 = (2,5)
    //65 gap 21 = (2,5)

    value a = date(2013, january, 5);
    value b = date(2013, january, 6);
    value c = date(2013, january, 1);
    value d = date(2013, january, 2);

    value result = date(2013, january, 3).rangeTo( date(2013, january, 4) );

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

    value result = date(2013, january, 3).rangeTo( date(2013, january, 6) );

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

shared void testOverlapRulesABHigherCD() {
    //Combinations to Test: AB > CD
    //39 overlap 16 = [3,6]
    //39 overlap 61 = [3,6]
    //93 overlap 16 = [3,6]
    //93 overlap 61 = [3,6]

    value a = date(2013, january, 3);
    value b = date(2013, january, 9);
    value c = date(2013, january, 1);
    value d = date(2013, january, 6);

    value result = date(2013, january, 3).rangeTo( date(2013, january, 6) );

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

void assertIntervalDate( Date start, Date end, Period period, Duration? duration = null )  {
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
