import ceylon.test {
    assertEquals,
    fail,
    assertTrue,
    assertFalse,
    test
}
import ceylon.time {
    DateTime,
    dateTime,
    Period
}
import ceylon.time.base {
    december,
    january,
    november,
    september,
    Month,
    DayOfWeek,
    sunday,
    july,
    wednesday,
    monday,
    october,
    tuesday,
    friday,
    saturday,
    february,
    april
}
import ceylon.time.timezone {
    timeZone
}

DateTime data_1982_12_13_09_08_07_0050 = dateTime {
    year = 1982; month = december; day = 13;
    hours = 9; minutes = 8; seconds = 7; milliseconds = 50;
};

// Table of test data from the book Calendrical Calculations + time
shared test void test_sun_jul_24_minus586_09_00_00_0000() => assertGregorianDateTime(-586, july, 24, sunday, !leapYear, 9 );
shared test void test_wed_dec_05_minus168_11_08_07_800() => assertGregorianDateTime(-168, december, 5, wednesday, leapYear, 11,8,7,800);
shared test void test_wed_sep_24_70_23_59_59_999() => assertGregorianDateTime(70, september, 24, wednesday, !leapYear, 23, 59, 59, 999);

shared test void test_mon_jan_01_1900_14_00_00_0000() => assertGregorianDateTime(1900, january, 1, monday, !leapYear, 14);
shared test void test_tue_oct_29_1974_02_01_03_0987() => assertGregorianDateTime(1974, october, 29, tuesday, !leapYear, 2,1,3,987);
shared test void test_mon_dec_13_1982_00_00_00_0001() => assertGregorianDateTime(1982, december, 13, monday, !leapYear, 0,0,0,1);
shared test void test_mon_dec_31_1999_00_00_01_0000() => assertGregorianDateTime(1999, december, 31, friday, !leapYear, 0,0,1,0);
shared test void test_mon_jan_01_2000_00_01_00_0000() => assertGregorianDateTime(2000, january, 1, saturday, leapYear, 0,1,0,0);
shared test void test_mon_jan_31_2000_01_00_00_0000() => assertGregorianDateTime(2000, january, 31, monday, leapYear, 1,0,0,0);
shared test void test_tue_feb_29_2000_10_10_10_0010() => assertGregorianDateTime(2000, february, 29, tuesday, leapYear, 10,10,10,10);
shared test void test_sun_dec_31_2000_23_59_59_9999() => assertGregorianDateTime(2000, december, 31, sunday, leapYear, 23,59,59,999);
shared test void test_wed_feb_29_2012_20_20_20_0020() => assertGregorianDateTime(2012, february, 29, wednesday, leapYear, 20,20,20,20);

shared test void testEqualsAndHashDateTime() {
    DateTime instanceA_1 = dateTime(1900, january, 1, 9, 8, 7, 6);
    DateTime instanceA_2 = dateTime(1900, january, 1, 9, 8, 7, 6);
    DateTime instanceB_1 = dateTime(2000, january, 1, 9, 8, 7, 6);
    DateTime instanceB_2 = dateTime(2000, january, 1, 9, 8, 7, 6);

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
}

shared test void testPlusYears() {
    assertEquals( 2000, data_1982_12_13_09_08_07_0050.plusYears(18).year);
}

shared test void testMinusYears() {
    assertEquals( 1964, data_1982_12_13_09_08_07_0050.minusYears(18).year);
}

shared test void testPlusMonths() {
    assertEquals( january, data_1982_12_13_09_08_07_0050.plusMonths(1).month);
}

shared test void testMinusMonths() {
    assertEquals( november, data_1982_12_13_09_08_07_0050.minusMonths(1).month);
}

shared test void testPlusDays() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusDays(2).day);
}

shared test void testMinusDays() {
    assertEquals( 9, data_1982_12_13_09_08_07_0050.minusDays(4).day);
}

shared test void testPlusHours_DateTime() {
    assertEquals( 18, data_1982_12_13_09_08_07_0050.plusHours(9).hours);

    value data_1982_12_14_13 = data_1982_12_13_09_08_07_0050.plusHours(28); 
    assertEquals( 13, data_1982_12_14_13.hours);
    assertEquals( 14, data_1982_12_14_13.day);
}

shared test void testMinusHours_DateTime() {
    assertEquals( 2, data_1982_12_13_09_08_07_0050.minusHours(7).hours);

    value data_1982_12_12_5 = data_1982_12_13_09_08_07_0050.minusHours(28);
    assertEquals( 5, data_1982_12_12_5.hours);
    assertEquals( 12, data_1982_12_12_5.day);
}

shared test void testPlusMinutes_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_10_3 = data_1982_12_13_09_08_07_0050.plusMinutes(55);
    assertEquals( 3, data_1982_12_13_10_3.minutes);
    assertEquals( 10, data_1982_12_13_10_3.hours);
}

shared test void testMinusMinutes_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_8_15 = data_1982_12_13_09_08_07_0050.minusMinutes(53);
    assertEquals( 15, data_1982_12_13_8_15.minutes);
    assertEquals( 8, data_1982_12_13_8_15.hours);    
}

shared test void testPlusSeconds_DateTime() {
    assertEquals( 16, data_1982_12_13_09_08_07_0050.plusSeconds(9).seconds);

    value data_1982_12_13_9_9_15 = data_1982_12_13_09_08_07_0050.plusSeconds(53+15);
    assertEquals( 15, data_1982_12_13_9_9_15.seconds);
    assertEquals( 9, data_1982_12_13_9_9_15.minutes);
}

shared test void testMinusSeconds_DateTime() {
    assertEquals( 15, data_1982_12_13_09_08_07_0050.plusMinutes(7).minutes);

    value data_1982_12_13_9_7_4 = data_1982_12_13_09_08_07_0050.minusSeconds(7+56);
    assertEquals( 4, data_1982_12_13_9_7_4.seconds);
    assertEquals( 7, data_1982_12_13_9_7_4.minutes);
}

shared test void testPlusMillis_DateTime() {
    assertEquals( 150, data_1982_12_13_09_08_07_0050.plusMilliseconds(100).milliseconds);

    value data_1982_12_13_9_8_15_300 = data_1982_12_13_09_08_07_0050.plusMilliseconds(950+7300);
    assertEquals( 300, data_1982_12_13_9_8_15_300.milliseconds);
    assertEquals( 15, data_1982_12_13_9_8_15_300.seconds);
}

shared test void testMinusMilliseconds_DateTime() {
    assertEquals( 950, data_1982_12_13_09_08_07_0050.minusMilliseconds(100).milliseconds);

    value data_1982_12_13_9_8_4_100 = data_1982_12_13_09_08_07_0050.minusMilliseconds(50+2900);
    assertEquals( 100, data_1982_12_13_9_8_4_100.milliseconds);
    assertEquals( 4, data_1982_12_13_9_8_4_100.seconds);
}

shared test void testWithDay40_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(40);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay0_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(0);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDayNegative_DateTime() {
    try {
        data_1982_12_13_09_08_07_0050.withDay(-10);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay29FebNotLeap_DateTime() {
    try {
        dateTime(2011, february,1).withDay(29);
        fail("Should throw exception...");
    } catch( AssertionException e ) {
        assertTrue(e.message.contains("Invalid date"));
    }
}

shared test void testWithDay29FebLeap_DateTime() {
    assertEquals( dateTime(2012, february,1).withDay(29), dateTime(2012, february, 29) );
}

shared test void testPredecessor_DateTime() {
    assertEquals{ 
        actual = data_1982_12_13_09_08_07_0050.predecessor; 
        expected = dateTime { 
            year = 1982; month = december; day = 13; 
            hours = 9; minutes = 8; seconds = 7; milliseconds = 49;
        };
    };
}

shared test void testSuccessor_DateTime() {
    assertEquals{ 
        actual = data_1982_12_13_09_08_07_0050.successor; 
        expected = dateTime {
            year = 1982; month = december; day = 13; 
            hours = 9; minutes = 8; seconds = 7; milliseconds = 51;
         };
     };
}

shared test void testPeriodFrom_DateTime() {
    Period period = Period{ days = 2; hours = 14;};
    DateTime from = dateTime(2013, december, 28, 10, 0);
    DateTime to = dateTime(2013,december,31);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFrom_DateTimeNegative() {
    Period period = Period{ days = -2; hours = -14;};
    DateTime from = dateTime(2013,december,31);
    DateTime to = dateTime(2013, december, 28, 10, 0);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromSameYearNoTime_DateTime() {
    Period period = Period{ months = 8; days = 3;};
    DateTime from = dateTime(2013, february,28);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromSameYearNoTime_DateTimeNegative() {
    Period period = Period{ months = -8; days = -3;};
    DateTime from = dateTime(2013,october,31);
    DateTime to = dateTime(2013, february,28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromSameYear_DateTime() {
    Period period = Period{ months = 8; days = 2; hours = 23; minutes = 59; seconds = 59; milliseconds = 900;};
    DateTime from = dateTime(2013, february,28, 0, 0, 0, 100);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromSameYear_DateTimeNegative() {
    Period period = Period{ months = -8; days = -2; hours = -23; minutes = -59; seconds = -59; milliseconds = -900;};
    DateTime from = dateTime(2013,october,31);
    DateTime to = dateTime(2013, february,28, 0, 0, 0, 100);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromMonthBeforeNoTime_DateTime() {
    Period period = Period{ years = 1; months = 10; days = 3;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,october,31);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromMonthBeforeNoTime_DateTimeNegative() {
    Period period = Period{ years = -1; months = -10; days = -3;}; 
    DateTime from = dateTime(2013,october,31);
    DateTime to = dateTime(2011, december, 28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromMonthBefore_DateTime() {
    Period period = Period{ years = 1; months = 10; days = 3; hours = 10; minutes = 30;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,october,31, 10, 30);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromMonthBefore_DateTimeNegative() {
    Period period = Period{ years = -1; months = -10; days = -3; hours = -10; minutes = -30;}; 
    DateTime from = dateTime(2013,october,31, 10, 30);
    DateTime to = dateTime(2011, december, 28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayAfterNoTime_DateTime() {
    Period period = Period{ years = 2; days = 3;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,december,31);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayAfterNoTime_DateTimeNegative() {
    Period period = Period{ years = -2; days = -3;}; 
    DateTime from = dateTime(2013,december,31);
    DateTime to = dateTime(2011, december, 28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayAfter_DateTime() {
    Period period = Period{ years = 2; days = 3; milliseconds = 999;}; 
    DateTime from = dateTime(2011, december, 28);
    DateTime to = dateTime(2013,december,31, 0, 0, 0, 999);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayAfter_DateTimeNegative() {
    Period period = Period{ years = -2; days = -3; milliseconds = -999;}; 
    DateTime from = dateTime(2013,december,31, 0, 0, 0, 999);
    DateTime to = dateTime(2011, december, 28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayBeforeNoTime_DateTime() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    DateTime from = dateTime(2011, october, 30);
    DateTime to = dateTime(2013,october,20);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayBeforeNoTime_DateTimeNegative() {
    Period period = Period{ years = -1; months = -11; days = -20;};
    DateTime from = dateTime(2013,october,20);
    DateTime to = dateTime(2011, october, 30);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayBefore_DateTime() {
    Period period = Period{ years = 1; months = 11; days = 20;};
    DateTime from = dateTime(2011, october, 30, 20, 20, 20, 20);
    DateTime to = dateTime(2013,october,20, 20, 20, 20, 20);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromDayBefore_DateTimeNegative() {
    Period period = Period{ years = -1; months = -11; days = -20;};
    DateTime from = dateTime(2013,october,20, 20, 20, 20, 20);
    DateTime to = dateTime(2011, october, 30, 20, 20, 20, 20);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromEqualDate_DateTime() {
    Period period = Period();
    DateTime from = dateTime(2011, october, 30, 10, 10, 10, 10);
    DateTime to = dateTime(2011, october, 30, 10, 10, 10, 10);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromNewYearNoTime_DateTime() {
    Period period = Period{ days = 4; };
    DateTime from = dateTime(2013, december, 28);
    DateTime to = dateTime(2014,january,1);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromNewYearNoTime_DateTimeNegative() {
    Period period = Period{ days = -4; };
    DateTime from = dateTime(2014,january,1);
    DateTime to = dateTime(2013, december, 28);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodFromNewYear_DateTime() {
    Period period = Period{ days = 3; hours = 23; minutes = 59; seconds = 59; milliseconds = 100; };
    DateTime from = dateTime(2013, december, 28, 0, 0, 0, 900);
    DateTime to = dateTime(2014,january,1);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodNextStepByMs_DateTime() {
    value from = dateTime(2013, april, 19, 17, 59,59);
    value to = dateTime(2013, april, 19, 18, 0);

    assertEquals( 1001, from.rangeTo(to).size );
}

shared test void testPeriodPreviousStepByMs_DateTime() {
    value from = dateTime(2013, april, 19, 18, 0);
    value to = dateTime(2013, april, 19, 17, 59,59);

    assertEquals( 1001, from.rangeTo(to).size );
}

shared test void testEnumerableDateTime() {
    assertEquals(data_1982_12_13_09_08_07_0050.instant(timeZone.utc).millisecondsOfEpoch, data_1982_12_13_09_08_07_0050.integerValue);
    assertEquals(data_1982_12_13_09_08_07_0050.successor.instant(timeZone.utc).millisecondsOfEpoch, data_1982_12_13_09_08_07_0050.integerValue + 1);
    assertEquals(data_1982_12_13_09_08_07_0050.predecessor.instant(timeZone.utc).millisecondsOfEpoch, data_1982_12_13_09_08_07_0050.integerValue - 1);
}

shared test void testPeriodFromNewYear_DateTimeNegative() {
    Period period = Period{ 
        days = -3; 
        hours = -23; 
        minutes = -59; 
        seconds = -59; 
        milliseconds = -100; 
    };
    DateTime from = dateTime(2014,january,1);
    DateTime to = dateTime(2013, december, 28, 0, 0, 0, 900);
    assertFromToDateTime(period, from, to);
}

shared test void testPeriodTimeStep() {
    value agora = dateTime(2013, april, 19, 6, 10);
    value  fimDoEvento = dateTime(2013, april, 19, 18, 0);
    
    assertFromToDateTime(Period{ hours = 11; minutes = 50; }, agora, fimDoEvento);
}

shared test void testStringDateTime() {
    assertEquals("1982-12-13T09:08:07.050", data_1982_12_13_09_08_07_0050.string);
    assertEquals("0000-12-13T09:08:07.050", data_1982_12_13_09_08_07_0050.withYear(0).string);
    assertEquals("0010-12-13T09:08:07.050", data_1982_12_13_09_08_07_0050.withYear(10).string);
    assertEquals("0100-12-13T09:08:07.050", data_1982_12_13_09_08_07_0050.withYear(100).string);
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
