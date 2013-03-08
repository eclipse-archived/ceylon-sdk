import ceylon.time { DateTime, dateTime, Period }
import ceylon.time.base { december, january, november, september, Month, DayOfWeek, sunday, july, wednesday, monday, october, tuesday, friday, saturday, february }
import ceylon.test { assertEquals, fail, assertTrue }

DateTime data_1982_12_13_09_08_07_0050 = dateTime { year = 1982;  
                                                    month = december; 
                                                    date = 13; 
                                                    hour = 9; 
                                                    minutes = 8;
                                                    seconds = 7;
                                                    millis = 50;
                                                  };

// Table of test data from the book Calendrical Calculations + time
shared void test_sun_jul_24_minus586_09_00_00_0000() => assertGregorianDateTime(-586, july, 24, sunday, !leapYear, 9 );
shared void test_wed_dec_05_minus168_11_08_07_800() => assertGregorianDateTime(-168, december, 5, wednesday, leapYear, 11,8,7,800);
shared void test_wed_sep_24_70_23_59_59_999() => assertGregorianDateTime(70, september, 24, wednesday, !leapYear, 23, 59, 59, 999);

shared void test_mon_jan_01_1900_14_00_00_0000() => assertGregorianDateTime(1900, january, 1, monday, !leapYear, 14);
shared void test_tue_oct_29_1974_02_01_03_0987() => assertGregorianDateTime(1974, october, 29, tuesday, !leapYear, 2,1,3,987);
shared void test_mon_dec_13_1982_00_00_00_0001() => assertGregorianDateTime(1982, december, 13, monday, !leapYear, 0,0,0,1);
shared void test_mon_dec_31_1999_00_00_01_0000() => assertGregorianDateTime(1999, december, 31, friday, !leapYear, 0,0,1,0);
shared void test_mon_jan_01_2000_00_01_00_0000() => assertGregorianDateTime(2000, january, 1, saturday, leapYear, 0,1,0,0);
shared void test_mon_jan_31_2000_01_00_00_0000() => assertGregorianDateTime(2000, january, 31, monday, leapYear, 1,0,0,0);
shared void test_tue_feb_29_2000_10_10_10_0010() => assertGregorianDateTime(2000, february, 29, tuesday, leapYear, 10,10,10,10);
shared void test_sun_dec_31_2000_23_59_59_9999() => assertGregorianDateTime(2000, december, 31, sunday, leapYear, 23,59,59,999);
shared void test_wed_feb_29_2012_20_20_20_0020() => assertGregorianDateTime(2012, february, 29, wednesday, leapYear, 20,20,20,20);

shared void testEquals() {
    assertEquals(data_1982_12_13_09_08_07_0050, dateTime(1982, december, 13, 9, 8, 7, 50));
    assertEquals(data_1982_12_13_09_08_07_0050.plusYears(1), dateTime(1983, december, 13, 9, 8, 7, 50));
}

shared void testPlusYears() {
    assertEquals( 2000, data_1982_12_13_09_08_07_0050.plusYears(18).year);
}

shared void testMinusYears() {
    assertEquals( 1964, data_1982_12_13_09_08_07_0050.minusYears(18).year);	
}

shared void testPlusMonths() {
    assertEquals( january, data_1982_12_13_09_08_07_0050.plusMonths(1).month);
}

shared void testMinusMonths() {
    assertEquals( november, data_1982_12_13_09_08_07_0050.minusMonths(1).month);
}

shared void testPlusDays() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusDays(2).day);
}

shared void testMinusDays() {
    assertEquals( 9, data_1982_12_13_09_08_07_0050.minusDays(4).day);
}

shared void testPlusHours_DateTime() {
    assertEquals( 18, data_1982_12_13_09_08_07_0050.plusHours(9).hours);

    value data_1982_12_14_13 = data_1982_12_13_09_08_07_0050.plusHours(28); 
    assertEquals( 13, data_1982_12_14_13.hours);
    assertEquals( 14, data_1982_12_14_13.day);
}

shared void testMinusHours_DateTime() {
    assertEquals( 2, data_1982_12_13_09_08_07_0050.minusHours(7).hours);

    value data_1982_12_12_5 = data_1982_12_13_09_08_07_0050.minusHours(28);
    assertEquals( 5, data_1982_12_12_5.hours);
    assertEquals( 12, data_1982_12_12_5.day);
}

shared void testPlusMinutes_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_10_3 = data_1982_12_13_09_08_07_0050.plusMinutes(55);
    assertEquals( 3, data_1982_12_13_10_3.minutes);
    assertEquals( 10, data_1982_12_13_10_3.hours);
}

shared void testMinusMinutes_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_8_15 = data_1982_12_13_09_08_07_0050.minusMinutes(53);
    assertEquals( 15, data_1982_12_13_8_15.minutes);
    assertEquals( 8, data_1982_12_13_8_15.hours);    
}

shared void testPlusSeconds_DateTime() {
    assertEquals( 16, data_1982_12_13_09_08_07_0050.plusSeconds(9).seconds);

    value data_1982_12_13_9_9_15 = data_1982_12_13_09_08_07_0050.plusSeconds(53+15);
    assertEquals( 15, data_1982_12_13_9_9_15.seconds);
    assertEquals( 9, data_1982_12_13_9_9_15.minutes);
}

shared void testMinusSeconds_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_9_7_4 = data_1982_12_13_09_08_07_0050.minusSeconds(7+56);
    assertEquals( 4, data_1982_12_13_9_7_4.seconds);
    assertEquals( 7, data_1982_12_13_9_7_4.minutes);
}

shared void testPlusMillis_DateTime() {
    assertEquals( 150, data_1982_12_13_09_08_07_0050.plusMilliseconds(100).milliseconds);

    value data_1982_12_13_9_8_15_300 = data_1982_12_13_09_08_07_0050.plusMilliseconds(950+7300);
    assertEquals( 300, data_1982_12_13_9_8_15_300.milliseconds);
    assertEquals( 15, data_1982_12_13_9_8_15_300.seconds);
}

shared void testMinusMilliseconds_DateTime() {
    assertEquals( 950, data_1982_12_13_09_08_07_0050.minusMilliseconds(100).milliseconds);

    value data_1982_12_13_9_8_4_100 = data_1982_12_13_09_08_07_0050.minusMilliseconds(50+2900);
    assertEquals( 100, data_1982_12_13_9_8_4_100.milliseconds);
    assertEquals( 4, data_1982_12_13_9_8_4_100.seconds);
}

shared void testWithDay40_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(40);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay0_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(0);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDayNegative_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(-10);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay29FebNotLeap_DateTime() {
    try {
        dateTime(2011, february,1).withDay(29);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared void testWithDay29FebLeap_DateTime() {
    assertEquals( dateTime(2012, february,1).withDay(29), dateTime(2012, february, 29) );
}

shared void testPredecessor_DateTime() {
    assertEquals{ 
        actual = data_1982_12_13_09_08_07_0050.predecessor; 
        expected = dateTime { 
            year = 1982;  
            month = december; 
            date = 13; 
            hour = 9; 
            minutes = 8;
            seconds = 7;
            millis = 49;
        };
    };
}

shared void testSuccessor_DateTime() {
    assertEquals{ 
        actual = data_1982_12_13_09_08_07_0050.successor; 
        expected = dateTime {
            year = 1982;
            month = december;
            date = 13; 
            hour = 9; 
            minutes = 8;
            seconds = 7;
            millis = 51;
         };
     };
}

shared void testPeriodFrom_DateTime() {
    Period period = Period{ days = 2; hours = 14;};
    DateTime from = dateTime(2013, december, 28, 10, 0);
    DateTime to = dateTime(2013,december,31);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromSameYearNoTime_DateTime() {
    Period period = Period{ months = 8; days = 3;};
    DateTime from = dateTime(2013, february,28);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromSameYear_DateTime() {
    Period period = Period{ months = 8; days = 2; hours = 23; minutes = 59; seconds = 59; milliseconds = 900;};
    DateTime from = dateTime(2013, february,28, 0, 0, 0, 100);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromMonthBeforeNoTime_DateTime() {
    Period period = Period{ years = 1; months = 10; days = 3;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromMonthBefore_DateTime() {
    Period period = Period{ years = 1; months = 10; days = 3; hours = 10; minutes = 30;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,october,31, 10, 30);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromDayAfterNoTime_DateTime() {
    Period period = Period{ years = 2; days = 3;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,december,31);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromDayAfter_DateTime() {
    Period period = Period{ years = 2; days = 3; milliseconds = 999;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,december,31, 0, 0, 0, 999);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromDayBeforeNoTime_DateTime() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    DateTime from = dateTime(2011, october, 30);
    DateTime to = dateTime(2013,october,20);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromDayBefore_DateTime() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    DateTime from = dateTime(2011, october, 30, 20, 20, 20, 20);
    DateTime to = dateTime(2013,october,20, 20, 20, 20, 20);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromEqualDate_DateTime() {
    Period period = Period();
    DateTime from = dateTime(2011, october, 30, 10, 10, 10, 10);
    DateTime to = dateTime(2011, october, 30, 10, 10, 10, 10);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromNewYearNoTime_DateTime() {
    Period period = Period{ days = 4; };
    DateTime from = dateTime(2013, december, 28);
    DateTime to = dateTime(2014,january,1);
    assertFromToDateTime(period, from, to);
}

shared void testPeriodFromNewYear_DateTime() {
    Period period = Period{ days = 3; hours = 23; minutes = 59; seconds = 59; milliseconds = 100; };
    DateTime from = dateTime(2013, december, 28, 0, 0, 0, 900);
    DateTime to = dateTime(2014,january,1);
    assertFromToDateTime(period, from, to);
}

void assertFromToDateTime( Period period, DateTime from, DateTime to ) {
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

void assertGregorianDateTime( Integer year, Month month, Integer day, DayOfWeek dayOfWeek, Boolean leapYear = false, 
                              Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0) {
    value actual = dateTime(year, month, day, hour, minute, second, milli);
    assertEquals(year, actual.year);
    assertEquals(month, actual.month);
    assertEquals(day, actual.day);
    assertEquals(dayOfWeek, actual.dayOfWeek);
    assertEquals(leapYear, actual.leapYear);
    assertEquals(hour, actual.hours);
    assertEquals(minute, actual.minutes);
    assertEquals(second, actual.seconds);
    assertEquals(milli, actual.milliseconds);
}
