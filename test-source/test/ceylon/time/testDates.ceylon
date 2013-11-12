import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    fail,
    test
}
import ceylon.time {
    date,
    Date,
    Period,
    dateTime,
    time
}
import ceylon.time.base {
    december,
    monday,
    january,
    november,
    february,
    april,
    tuesday,
    october,
    sunday,
    wednesday,
    september,
    july,
    march,
    friday,
    saturday,
    DayOfWeek,
    Month,
    years
}

// Constants
Boolean leapYear = true;
Date data_1982_12_13 = date( 1982, december, 13);

// Table of test data from the book Calendrical Calculations
shared test void test_sun_jul_24_minus586() => assertGregorianDate(-586, july, 24, sunday, !leapYear, 205);
shared test void test_wed_dec_05_minus168() => assertGregorianDate(-168, december, 5, wednesday, leapYear, 340);
shared test void test_wed_sep_24_70() => assertGregorianDate(70, september, 24, wednesday, !leapYear, 267);

shared test void test_mon_jan_01_1900() => assertGregorianDate(1900, january, 1, monday, !leapYear, 1);
shared test void test_tue_oct_29_1974() => assertGregorianDate(1974, october, 29, tuesday, !leapYear, 302);
shared test void test_mon_dec_13_1982() => assertGregorianDate(1982, december, 13, monday, !leapYear, 347);
shared test void test_mon_dec_31_1999() => assertGregorianDate(1999, december, 31, friday, !leapYear, 365);
shared test void test_mon_jan_01_2000() => assertGregorianDate(2000, january, 1, saturday, leapYear, 1);
shared test void test_mon_jan_31_2000() => assertGregorianDate(2000, january, 31, monday, leapYear, 31);
shared test void test_tue_feb_29_2000() => assertGregorianDate(2000, february, 29, tuesday, leapYear, 60);
shared test void test_sun_dec_31_2000() => assertGregorianDate(2000, december, 31, sunday, leapYear, 366);
shared test void test_wed_feb_29_2012() => assertGregorianDate(2012, february, 29, wednesday, leapYear, 60);

shared test void test_invalid_date_jan_0() {
    try {
        date(2013,january,0);
        fail("It should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void test_invalid_date_feb_29() {
    try {
        date(2013,february,29);
        fail("It should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void test_invalid_date_maximum_year() {
    try {
        date(years.maximum+1,february,29);
        fail("It should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Invalid year"));
    }
}

shared test void test_invalid_date_minimum_year() {
    try {
        date(years.minimum-1,february,29);
        fail("It should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Invalid year"));
    }
}

shared test void test_2400_is_leapYear() => assertTrue( date(2400, january, 1 ).leapYear, "2400 is leap year" );
shared test void test_2200_is_not_leapYear() => assertFalse( date(2200, january, 1 ).leapYear, "2200 is not leap year" );
shared test void test_2100_is_not_leapYear() => assertFalse( date(2100, january, 1 ).leapYear, "2010 is not leap year" );
shared test void test_2012_is_leapYear() => assertTrue( date(2012, january, 1 ).leapYear, "2012 is leap year" );
shared test void test_2011_is_not_leapYear() => assertFalse( date(2011, january, 1 ).leapYear, "2011 is not leap year" );
shared test void test_2008_is_leapYear() => assertTrue( date(2008, january, 1 ).leapYear, "2008 is leap year" );
shared test void test_2000_is_leapYear() => assertTrue( date(2000, january, 1 ).leapYear, "2000 is leap year" );
shared test void test_1900_is_not_leapYear() => assertFalse( date(1900, january, 1 ).leapYear, "1900 is not leap year" );
shared test void test_1600_is_leapYear() => assertTrue( date(1600, january, 1 ).leapYear, "1600 is leap year" );

shared test void testWeekOfYear() {
    //Random dates
    assertEquals( date(2009, april, 28).weekOfYear, 18);
    assertEquals( date(2012, december, 16).weekOfYear, 50);

    //http://en.wikipedia.org/wiki/ISO_week_date
    //http://www.personal.ecu.edu/mccartyr/isowdcal.html
    assertEquals( date(2005, january, 1).weekOfYear, 53);
    assertEquals( date(2005, january, 2).weekOfYear, 53);
    assertEquals( date(2005, december, 31).weekOfYear, 52);
    assertEquals( date(2007, january, 1).weekOfYear, 1);
    assertEquals( date(2007, december, 30).weekOfYear, 52);
    assertEquals( date(2007, december, 31).weekOfYear, 1);
    assertEquals( date(2008, january, 1).weekOfYear, 1);
    assertEquals( date(2008, december, 28).weekOfYear, 52);
    assertEquals( date(2008, december, 29).weekOfYear, 1);
    assertEquals( date(2008, december, 30).weekOfYear, 1);
    assertEquals( date(2008, december, 31).weekOfYear, 1);
    assertEquals( date(2009, january, 1).weekOfYear, 1);
    assertEquals( date(2009, december, 31).weekOfYear, 53);
    assertEquals( date(2010, january, 1).weekOfYear, 53);
    assertEquals( date(2010, january, 2).weekOfYear, 53);
    assertEquals( date(2010, january, 3).weekOfYear, 53);
}

shared test void testDatePlusDays() {
    assertEquals( data_1982_12_13.plusDays( 0 ), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusDays( 5 ), date( 1982, december, 18 ) );
    assertEquals( data_1982_12_13.plusDays( 45 ), date( 1983, january, 27 ) );
    assertEquals( data_1982_12_13.plusDays( 10954 ), date( 2012, december, 9 ) );
}

shared test void testDateMinusDays() {
    assertEquals( data_1982_12_13.minusDays( 5 ), date( 1982, december, 8 ) );
    assertEquals( data_1982_12_13.minusDays( 0 ), data_1982_12_13 );
    assertEquals( date( 2012, december, 9 ).minusDays( 10954 ), data_1982_12_13 );
}

shared test void testDatePlusMonthsLessDays() {
    assertEquals( date(1983, february, 28), date(1982,december,31).plusMonths(2));
}

shared test void testDatePlusMonths() {
    assertEquals( data_1982_12_13.plusMonths(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusMonths(1), date( 1983, january, 13) );
    assertEquals( data_1982_12_13.plusMonths(12), date( 1983, december, 13) );
    assertEquals( data_1982_12_13.plusMonths(36), date( 1985, december, 13) );

    value data_2000_01_31 = date( 2000, january, 31 );
    assertEquals( data_2000_01_31.plusMonths(14), date( 2001, march, 31) );
}

shared test void testDateMinusMonths() {
    assertEquals( data_1982_12_13.minusMonths(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.minusMonths(1), date( 1982, november, 13) );
    assertEquals( data_1982_12_13.minusMonths(12), date( 1981, december, 13) );
}

shared test void testDateMinusLessDays() {
    assertEquals( date(1982,november,30), date(1982,december,31).minusMonths(1));
}

shared test void testDatePlusYears() {
    assertEquals( data_1982_12_13.plusYears(0), data_1982_12_13 );
    assertEquals( data_1982_12_13.plusYears(18), date( 2000, december, 13) );
    assertEquals( data_1982_12_13.plusYears(30), date( 2012, december, 13) );
}

shared test void testPlusYearsLessDays() {
    assertEquals( date(2013, february, 28), date(2012, february, 29).plusYears(1));
}

shared test void testDateMinusYears() {
    value data_2000_01_31 = date( 2000, january, 31);
    assertEquals( data_2000_01_31.minusYears(1), date( 1999, january, 31) );
    assertEquals( data_1982_12_13.minusYears(10), date( 1972, december, 13) );
}

shared test void testMinusYearsLessDays() {
    assertEquals( date(2011, february, 28), date(2012, february, 29).minusYears(1));
}

shared test void testDatePlusWeeks() {
    assertEquals( data_1982_12_13.plusWeeks(1).dayOfWeek, data_1982_12_13.dayOfWeek );
    assertEquals( data_1982_12_13.plusWeeks(1), date( 1982, december, 20) );
    assertEquals( data_1982_12_13.plusWeeks(3), date( 1983, january, 3) );
}

shared test void testDateMinusWeeks(){
    assertEquals( data_1982_12_13.minusWeeks(1), date( 1982, december, 6) );
    assertEquals( data_1982_12_13.minusWeeks(3), date( 1982, november, 22) );
    assertEquals( data_1982_12_13.minusWeeks(3).dayOfWeek, date( 1982, november, 22).dayOfWeek );
}

shared test void testWithDay() {
    assertEquals( data_1982_12_13.withDay(13), data_1982_12_13 );
    assertEquals( data_1982_12_13.withDay(17), date( 1982, december, 17) );
    assertTrue( data_1982_12_13.withDay(17) <=> date( 1982, december, 17) == equal);
}

shared test void testWithDay40() {
    try {
        data_1982_12_13.withDay(40);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay0() {
    try {
        data_1982_12_13.withDay(0);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDayNegative() {
    try {
        data_1982_12_13.withDay(-10);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay29FebNotLeap() {
    try {
        date(2011, february,1).withDay(29);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay29FebLeap() {
    assertEquals( date(2012, february,1).withDay(29), date(2012, february, 29) );
}    


shared test void testWithMonthLessDaysException() {
    try {
        date(2012, december, 31).withMonth(february);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithMonth() {
    assertEquals( data_1982_12_13, data_1982_12_13.withMonth(december) );
    assertEquals( date( 1982, january, 13), data_1982_12_13.withMonth(january) );
    assertTrue( data_1982_12_13.withMonth(january) <=> date( 1982, january, 13) == equal);
}

shared test void testWithYear() {
    assertEquals( data_1982_12_13.withYear(1982), data_1982_12_13 );
    assertEquals( data_1982_12_13.withYear(2000), date( 2000, december, 13) );
    assertEquals( data_1982_12_13.withYear(1800), date( 1800, december, 13) );
}

shared test void testWithYearLeap() {
    try {
        date( 2012, february, 29).withYear(2011);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date value"));
    }
}

shared test void testOrdinal() {
    Date data_1983_01_01 = date( 1983, january, 1 );
    variable value cont = 0;
    for ( Date date in data_1982_12_13..data_1983_01_01 ) {
        assertEquals( date, data_1982_12_13.plusDays(cont++) );
    }
}

shared test void testPlusPeriod_Date() {
    value period_0001_02_03 = Period {
        years = 1;
        months = 2;
        days = 3;
    };
    value newDataAmount = data_1982_12_13.plus( period_0001_02_03 );
    assertEquals( newDataAmount.year, 1984 );
    assertEquals( newDataAmount.month, february );
    assertEquals( newDataAmount.day, 16 );
}

shared test void testMinusPeriod_Date() {
    value period_0001_02_03 = Period {
        years = 1;
        months = 2;
        days = 3;
    };
    value newDataAmount = data_1982_12_13.minus( period_0001_02_03 );
    assertEquals( newDataAmount.year, 1981 );
    assertEquals( newDataAmount.month, october );
    assertEquals( newDataAmount.day, 10 );
}

shared test void testPredecessor() {
    assertEquals(data_1982_12_13.predecessor, date(1982, december, 12));
}

shared test void testSuccessor() {
    assertEquals(data_1982_12_13.successor, date(1982, december, 14));
}

shared test void testString() {
    assertEquals( data_1982_12_13.string, "1982-12-13" );
    assertEquals( date(2012, january, 1 ).string, "2012-01-01" );
    assertEquals( date(0, january, 1 ).string, "0000-01-01" );
    assertEquals( date(10, january, 1 ).string, "0010-01-01" );
    assertEquals( date(100, january, 1 ).string, "0100-01-01" );
}

shared test void testAt() {
    assertAt(2013, january, 1, 10, 20, 15, 999);
    assertAt(2012, february, 29, 9, 10, 30, 0);
}

shared test void testAtInvalidHour() {
    try {
        data_1982_12_13.at( time(-10, 0) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Hours value should be between 0 and 23"));
    }
}

shared test void testAtInvalidMinute() {
    try {
        data_1982_12_13.at( time(10, 60) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Minutes value should be between 0 and 59"));
    }
}

shared test void testAtInvalidSecond() {
    try {
        data_1982_12_13.at( time(10, 59, -1) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Seconds value should be between 0 and 59"));
    }
}

shared test void testAtInvalidMillis() {
    try {
        data_1982_12_13.at( time(10, 59, 59, 1000) );
        fail("Should throw exception...");
    } catch ( AssertionException e ) {
        assertTrue(e.message.contains("Milliseconds value should be between 0 and 999"));
    }
}

shared test void testPeriodFrom() {
    Period period = Period{ years = 2; months = 2; days = 3;};
    Date from = date(2011, october, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromNegative() {
    Period period = Period{ years = -2; months = -2; days = -3;};
    Date to = date(2011, october, 28);
    Date from = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyDayChange() {
    Period period = Period{ days = 3;};
    Date from = date(2013, december, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyDayChangeNegative() {
    Date to = date(2013, december, 28);
    Date from = date(2013,december,31);
    assertFromAndTo(Period{ days = -3;}, from, to);
}

shared test void testPeriodFromNewYear() {
    Period period = Period{ days = 4; };
    Date from = date(2013, december, 28);
    Date to = date(2014,january,1);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromNewYearNegative() {
    Period period = Period{ days = -4; };
    Date from = date(2014,january,1);
    Date to = date(2013, december, 28);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromSameYear() {
    Period period = Period{ months = 8; days = 3;};
    Date from = date(2013, february,28);
    Date to = date(2013,october,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromSameYearNegative() {
    Period period = Period{ months = -8; days = -3;};
    Date from = date(2013,october,31);
    Date to = date(2013, february,28);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromMonthBefore() {
    Period period = Period{ years = 1; months = 10; days = 3;}; 
    Date from = date(2011, december, 28);
    Date to = date(2013,october,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromMonthBeforeNegative() {
    Period period = Period{ years = -1; months = -10; days = -3;};
    Date from = date(2013,october,31);
    Date to = date(2011, december, 28);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyMonthChange() {
    Period period = Period{ months = 2;};
    Date from = date(2013, january, 31);
    Date to = date(2013,march,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyMonthChangeNegative() {
    Period period = Period{ months = -2;};
    Date from = date(2013,march,31);
    Date to = date(2013, january, 31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyYearChange() {
    Period period = Period{ years = 3;};
    Date from = date(2010, january, 31);
    Date to = date(2013,january,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromOnlyYearChangeNegative() {
    Period period = Period{ years = -3;};
    Date from = date(2013,january,31);
    Date to = date(2010, january, 31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromYearMonthChange() {
    Period period = Period{ years = 1; months = 1;};
    Date from = date(2011, december, 31);
    Date to = date(2013,january,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromYearMonthChangeNegative() {
    Period period = Period{ years = -1; months = -1;};
    Date from = date(2013,january,31);
    Date to = date(2011, december, 31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromLeapYear() {
    Period period = Period{ years = 1;};
    Date from = date(2012, february, 29);
    Date to = date(2013,february,28);
    assertEquals{
      expected = period;
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = period;
      actual = from.periodTo( to );
    };

    assertEquals(to, from.plus(period));
    assertEquals(from.minusDays(1), to.minus(period));
}

shared test void testPeriodFromLeapYearNegative() {
    Period period = Period{ years = -1;};
    Date from = date(2013,february,28);
    Date to = date(2012, february, 28);
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

shared test void testPeriodFromDayAfter() {
    Period period = Period{ years = 2; days = 3;}; 
    Date from = date(2011, december, 28);
    Date to = date(2013,december,31);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromDayAfterNegative() {
    Period period = Period{ years = -2; days = -3;}; 
    Date from = date(2013,december,31);
    Date to = date(2011, december, 28);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromDayBefore() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    Date from = date(2011, october, 30);
    Date to = date(2013,october,20);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromDayBeforeNegative() {
    Period period = Period{ years = -1; months = -11; days = -20;};
    Date from = date(2013,october,20);
    Date to = date(2011, october, 30);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromNegativeDay() {
    Period period = Period{ days = -1;};
    Date from = date(2011, october, 28);
    Date to = date(2011,october,27);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromEqualDate() {
    Period period = Period();
    Date from = date(2011, october, 30);
    Date to = date(2011, october, 30);
    assertFromAndTo(period, from, to);
}

shared test void testPeriodFromAfterDate() {
    Date from = date(2011, december, 30);
    Date to = date(2011, october, 30);
    assertEquals{
      expected = Period { months = -2; };
      actual = to.periodFrom( from );
    };
    assertEquals{
      expected = Period { months = -2; };
      actual = from.periodTo( to );
    };
}

shared test void testEnumerableDate() {
    assertEquals(data_1982_12_13.dayOfEra, data_1982_12_13.integerValue);
    assertEquals(data_1982_12_13.successor.dayOfEra, data_1982_12_13.integerValue + 1);
    assertEquals(data_1982_12_13.predecessor.dayOfEra, data_1982_12_13.integerValue - 1);
}

shared test void testEqualsAndHashDate() {
    Date instanceA_1 = date(2013, december, 13);
    Date instanceA_2 = date(2013, december, 13);
    Date instanceB_1 = date(1974, january, 1);
    Date instanceB_2 = date(1974, january, 1);

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
}

void assertFromAndTo( Period period, Date from, Date to ) {
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

void assertAt(Integer year, Month month, Integer day, Integer h, Integer min, Integer sec, Integer ms ) {
    assertEquals( dateTime(year, month, day, h, min, sec, ms) , date(year, month, day).at( time(h, min, sec, ms) ));
}

// Asserts that what we put in, we get back from the Date object
void assertGregorianDate(Integer year, Month month, Integer day, DayOfWeek dayOfWeek, Boolean leapYear = false, Integer? dayOfYear = null ) {
    value actual = date(year, month, day);
    assertEquals(year, actual.year);
    assertEquals(month, actual.month);
    assertEquals(day, actual.day);
    assertEquals(dayOfWeek, actual.dayOfWeek);
    assertEquals(leapYear, actual.leapYear);

    if ( exists dayOfYear ) {
        assertEquals(dayOfYear, actual.dayOfYear);
    }
}
