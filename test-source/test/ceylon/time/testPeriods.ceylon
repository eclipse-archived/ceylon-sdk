import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    test
}
import ceylon.time {
    Period
}
import ceylon.time.base {
    milliseconds,
    seconds,
    minutes,
    hours
}

Period oneMilli = Period { milliseconds = 1; };
Period oneSecond = Period { seconds = 1; };
Period oneMinute = Period { minutes = 1; };
Period oneHour = Period { hours = 1; };
Period tenDays = Period { days = 10; };
Period oneYear = Period { years = 1; };
Period oneHalfYear = Period { years = 1; months = 6; };
Period twelveMonths = Period { months = 12; };

test void testPeriodYear() => assertPeriod { year = 200; };
test void testPeriodMonth() => assertPeriod { month = 200; };
test void testPeriodDay() => assertPeriod { day = 200; };
test void testPeriodHour() => assertPeriod { hour = 200; };
test void testPeriodMinute() => assertPeriod { minute = 200; };
test void testPeriodSecond() => assertPeriod { second = 200; };
test void testPeriodMilli() => assertPeriod { milli = 200; };

test void testPeriodNormalizedYear() => assertPeriodNormalized { period = Period { years = 500; };  year = 500; };
test void testPeriodNormalizedMonthToYear() => assertPeriodNormalized { period = Period { years = 2; };  month = 24; };
test void testPeriodNormalizedDay() => assertPeriodNormalized { period = Period { days = 50; };  day = 50; };
test void testPeriodNormalizedHour() => assertPeriodNormalized { period = Period { hours = 50; };  hour = 50; };
test void testPeriodNormalizedMinuteToHour() => assertPeriodNormalized { period = Period { hours = 2; };  minute = 120; };
test void testPeriodNormalizedSecondToMinute() => assertPeriodNormalized { period = Period { minutes = 2; };  second = 120; };
test void testPeriodNormalizedMilliToSecond() => assertPeriodNormalized { period = Period { seconds = 2; };  milli = 2000; };

test void testPlus_Periods() => assertEquals( Period { years = 2; months = 6; }, oneYear.plus(oneHalfYear) );

test void testPlusYears_Periods() => assertEquals( Period { years = 2; }, oneYear.plusYears(1) );
test void testPlusYearsSameInstance_Periods() => assertTrue( oneYear.plusYears(0) === oneYear );

test void testPlusMonthsSameInstance_Periods() => assertTrue( twelveMonths.plusMonths(0) === twelveMonths );
test void testPlusMonthsNormalized_Periods() => assertEquals( oneHalfYear, twelveMonths.normalized().plusMonths(6) );

test void testPlusDaysPeriods() => assertEquals( Period { days = 50; }, tenDays.plusDays(40) );
test void testPlusDaysSameInstancePeriods() => assertTrue( tenDays.plusDays(0) === tenDays );

test void testPlusHoursPeriods() => assertEquals( Period { hours = 50; }, oneHour.plusHours(49) );
test void testPlusHoursSameInstancePeriods() => assertTrue( oneHour.plusHours(0) === oneHour );

test void testPlusMinutesPeriods() => assertEquals( Period { minutes = 60; }, oneMinute.plusMinutes(59) );
test void testPlusMinutesSameInstancePeriods() => assertTrue( oneMinute.plusMinutes(0) === oneMinute );

test void testPlusSecondsPeriods() => assertEquals( Period { seconds = 60; }, oneSecond.plusSeconds(59) );
test void testPlusSecondsSameInstancePeriods() => assertTrue( oneSecond.plusSeconds(0) === oneSecond );

test void testPlusMillisecondsPeriods() => assertEquals( Period { milliseconds = 1000; }, oneMilli.plusMilliseconds(999) );
test void testPlusMillisecondsSameInstancePeriods() => assertTrue( oneMilli.plusMilliseconds(0) === oneMilli );

test void testMinusYears_Periods() => assertEquals( Period { years = 0; months = 6; }, oneHalfYear.minusYears(1) );
test void testMinusYearsNegative_Periods() => assertEquals( Period{ years = -1; }, oneYear.minusYears(2) );
test void testMinusYearsSameInstance_Periods() => assertTrue( oneHalfYear.minusYears(0) === oneHalfYear );

test void testMinusMonths_Periods() => assertEquals( oneYear, oneHalfYear.minusMonths(6) );
test void testMinusMonthsNegative_Periods() => assertEquals( Period {years = 1; months = -18;}, oneHalfYear.minusMonths(24) );
test void testMinusMonthsSameInstance_Periods() => assertTrue( twelveMonths.minusMonths(0) === twelveMonths );

test void testMinusDays_Periods() => assertEquals( Period{ days = 5; }, tenDays.minusDays(5) );
test void testMinusDaysNegative_Periods() => assertEquals( Period{ days = -15; }, tenDays.minusDays(25) );
test void testMinusDaysSameInstance_Periods() => assertTrue( tenDays.minusDays(0) === tenDays );

test void testMinusHours_Periods() => assertEquals( Period { hours = 0; }, oneHour.minusHours(1) );
test void testMinusHoursNegative_Periods() => assertEquals( Period { hours = -1; }, oneHour.minusHours(2) );
test void testMinusHoursSameInstance_Periods() => assertTrue( oneHour.minusHours(0) === oneHour );

test void testMinusMinutes_Periods() => assertEquals( Period{ minutes = 0; }, oneMinute.minusMinutes(1) );
test void testMinusMinutesNegative_Periods() => assertEquals( Period{ minutes = -1; }, oneMinute.minusMinutes(2) );
test void testMinusMinutesSameInstance_Periods() => assertTrue( oneMinute.minusMinutes(0) === oneMinute );

test void testMinusSeconds_Periods() => assertEquals( Period{ seconds = 0; }, oneSecond.minusSeconds(1) );
test void testMinusSecondsNegative_Periods() => assertEquals( Period{ seconds = -1; }, oneSecond.minusSeconds(2) );
test void testMinusSecondsSameInstance_Periods() => assertTrue( oneSecond.minusSeconds(0) === oneSecond );

test void testMinusMillis_Periods() => assertEquals( Period{ milliseconds = 0; }, oneMilli.minusMilliseconds(1) );
test void testMinusMillisNegative_Periods() => assertEquals( Period{ milliseconds = -1; }, oneMilli.minusMilliseconds(2) );
test void testMinusMillisSameInstance_Periods() => assertTrue( oneMilli.minusMilliseconds(0) === oneMilli );

test void testComparableYearMonth_Periods() => assertEquals( oneYear <=> twelveMonths, equal );
test void testComparableYearYearHalf_Periods() => assertEquals( oneYear < oneHalfYear, true );
test void testComparableYearHalfMonths_Periods() => assertEquals( oneHalfYear > twelveMonths, true );

test void testWithYears_Periods() => assertEquals( Period{ years = 3; months = 6;}, oneHalfYear.withYears(3) );
test void testWithMonths_Periods() => assertEquals( Period{ years = 1; months = 3;}, oneYear.withMonths(3) );
test void testWithDays_Periods() => assertEquals( Period{ years = 1; days = 10; }, oneYear.withDays(10) );
test void testWithHours_Periods() => assertEquals( Period{ years = 1; hours = 10; }, oneYear.withHours(10) );
test void testWithMinutes_Periods() => assertEquals( Period{ years = 1; minutes = 10; }, oneYear.withMinutes(10) );
test void testWithSeconds_Periods() => assertEquals( Period{ years = 1; seconds = 10; }, oneYear.withSeconds(10) );
test void testWithMillis_Periods() => assertEquals( Period{ years = 1; milliseconds = 10; }, oneYear.withMilliseconds(10) );

test void testStringNormalizedMillis() => assertEquals("PT360H", Period { milliseconds = 15 * milliseconds.perDay ; }.normalized().string);
test void testStringNormalizedSeconds() => assertEquals("PT360H", Period { seconds = 15 * seconds.perDay ; }.normalized().string);
test void testStringNormalizedMinutes() => assertEquals("PT360H", Period { minutes = 15 * minutes.perDay ; }.normalized().string);
test void testStringNormalizedHours() => assertEquals("PT360H", Period { hours = 15 * hours.perDay ; }.normalized().string);
test void testStringFullTime() => assertEquals("PT59H59M59.999S", Period { 
                                      hours = 59;
                                      minutes = 59;
                                      seconds = 59;
                                      milliseconds = 999; 
                                    }.string);
test void testStringTimePaddedString() => assertEquals("PT1H1M1.001S", Period { 
                                               hours = 1;
                                               minutes = 1;
                                               seconds = 1;
                                               milliseconds = 1; 
                                            }.string);

test void testScalablePeriod() {
    //Rules suggested by scalable interface
    assertEquals(Period { years = 200; },   1 ** Period{ years = 200;});
    assertEquals(Period { years = -200; }, -1 ** Period{ years = 200;});
    assertEquals(Period { years = 0; },     0 ** Period{ years = 200;});
    assertEquals(Period { years = 400; },   2 ** Period{ years = 200;});

    Period period = Period (4, 4, 4, 4, 4, 4);
    Period result = Period (16, 16, 16, 16, 16, 16);  
    assertEquals( result, 4 ** period);
}

test void testEqualsAndHashPeriod() {
    Period instanceA_1 = Period{ years = 1;};
    Period instanceA_2 = Period{ years = 1;};
    Period instanceB_1 = Period{ days = 1;};
    Period instanceB_2 = Period{ days = 1;};

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
}

void assertPeriodNormalized( Period period, Integer year = 0, Integer month = 0, Integer day = 0, Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0 ) {
    value normalized = Period { years = year; months = month; days = day; hours = hour; minutes = minute; seconds = second; milliseconds = milli;}.normalized();
    assertEquals(period, normalized);
}

void assertPeriod( Integer year = 0, Integer month = 0, Integer day = 0, Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0) {
    value p = Period(year, month, day, hour, minute, second, milli);
    assertEquals(year, p.years);
    assertEquals(month, p.months);
    assertEquals(day, p.days);
    assertEquals(hour, p.hours);
    assertEquals(minute, p.minutes);
    assertEquals(second, p.seconds);
    assertEquals(milli, p.milliseconds);
}
