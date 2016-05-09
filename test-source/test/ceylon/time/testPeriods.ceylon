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

Period oneMillisecond = Period { milliseconds = 1; };
Period oneSecond = Period { seconds = 1; };
Period oneMinute = Period { minutes = 1; };
Period oneHour = Period { hours = 1; };
Period tenDays = Period { days = 10; };
Period oneYear = Period { years = 1; };
Period oneHalfYear = Period { years = 1; months = 6; };
Period twelveMonths = Period { months = 12; };

shared test void testPeriodYear() => assertPeriod { year = 200; };
shared test void testPeriodMonth() => assertPeriod { month = 200; };
shared test void testPeriodDay() => assertPeriod { day = 200; };
shared test void testPeriodHour() => assertPeriod { hour = 200; };
shared test void testPeriodMinute() => assertPeriod { minute = 200; };
shared test void testPeriodSecond() => assertPeriod { second = 200; };
shared test void testPeriodMilli() => assertPeriod { milli = 200; };

shared test void testPeriodNormalizedYear() => assertPeriodNormalized { period = Period { years = 500; };  year = 500; };
shared test void testPeriodNormalizedMonthToYear() => assertPeriodNormalized { period = Period { years = 2; };  month = 24; };
shared test void testPeriodNormalizedDay() => assertPeriodNormalized { period = Period { days = 50; };  day = 50; };
shared test void testPeriodNormalizedHour() => assertPeriodNormalized { period = Period { hours = 50; };  hour = 50; };
shared test void testPeriodNormalizedMinuteToHour() => assertPeriodNormalized { period = Period { hours = 2; };  minute = 120; };
shared test void testPeriodNormalizedSecondToMinute() => assertPeriodNormalized { period = Period { minutes = 2; };  second = 120; };
shared test void testPeriodNormalizedMilliToSecond() => assertPeriodNormalized { period = Period { seconds = 2; };  milli = 2000; };

shared test void testPlus_Periods() => assertEquals { expected = Period { years = 2; months = 6; }; actual = oneYear.plus(oneHalfYear); };

shared test void testPlusYears_Periods() => assertEquals { expected = Period { years = 2; }; actual = oneYear.plusYears(1); };
shared test void testPlusYearsSameInstance_Periods() => assertTrue( oneYear.plusYears(0) === oneYear );

shared test void testPlusMonthsSameInstance_Periods() => assertTrue( twelveMonths.plusMonths(0) === twelveMonths );
shared test void testPlusMonthsNormalized_Periods() => assertEquals { expected = oneHalfYear; actual = twelveMonths.normalized().plusMonths(6); };

shared test void testPlusDaysPeriods() => assertEquals { expected = Period { days = 50; }; actual = tenDays.plusDays(40); };
shared test void testPlusDaysSameInstancePeriods() => assertTrue( tenDays.plusDays(0) === tenDays );

shared test void testPlusHoursPeriods() => assertEquals { expected = Period { hours = 50; }; actual = oneHour.plusHours(49); };
shared test void testPlusHoursSameInstancePeriods() => assertTrue( oneHour.plusHours(0) === oneHour );

shared test void testPlusMinutesPeriods() => assertEquals { expected = Period { minutes = 60; }; actual = oneMinute.plusMinutes(59); };
shared test void testPlusMinutesSameInstancePeriods() => assertTrue( oneMinute.plusMinutes(0) === oneMinute );

shared test void testPlusSecondsPeriods() => assertEquals { expected = Period { seconds = 60; }; actual = oneSecond.plusSeconds(59); };
shared test void testPlusSecondsSameInstancePeriods() => assertTrue( oneSecond.plusSeconds(0) === oneSecond );

shared test void testPlusMillisecondsPeriods() => assertEquals { expected = Period { milliseconds = 1000; }; actual = oneMillisecond.plusMilliseconds(999); };
shared test void testPlusMillisecondsSameInstancePeriods() => assertTrue( oneMillisecond.plusMilliseconds(0) === oneMillisecond );

shared test void testMinusYears_Periods() => assertEquals { expected = Period { years = 0; months = 6; }; actual = oneHalfYear.minusYears(1); };
shared test void testMinusYearsNegative_Periods() => assertEquals { expected = Period{ years = -1; }; actual = oneYear.minusYears(2); };
shared test void testMinusYearsSameInstance_Periods() => assertTrue( oneHalfYear.minusYears(0) === oneHalfYear );

shared test void testMinusMonths_Periods() => assertEquals { expected = oneYear; actual = oneHalfYear.minusMonths(6); };
shared test void testMinusMonthsNegative_Periods() => assertEquals { expected = Period {years = 1; months = -18;}; actual = oneHalfYear.minusMonths(24); };
shared test void testMinusMonthsSameInstance_Periods() => assertTrue( twelveMonths.minusMonths(0) === twelveMonths );

shared test void testMinusDays_Periods() => assertEquals { expected = Period{ days = 5; }; actual = tenDays.minusDays(5); };
shared test void testMinusDaysNegative_Periods() => assertEquals { expected = Period{ days = -15; }; actual = tenDays.minusDays(25); };
shared test void testMinusDaysSameInstance_Periods() => assertTrue( tenDays.minusDays(0) === tenDays );

shared test void testMinusHours_Periods() => assertEquals { expected = Period { hours = 0; }; actual = oneHour.minusHours(1); };
shared test void testMinusHoursNegative_Periods() => assertEquals { expected = Period { hours = -1; }; actual = oneHour.minusHours(2); };
shared test void testMinusHoursSameInstance_Periods() => assertTrue( oneHour.minusHours(0) === oneHour );

shared test void testMinusMinutes_Periods() => assertEquals { expected = Period{ minutes = 0; }; actual = oneMinute.minusMinutes(1); };
shared test void testMinusMinutesNegative_Periods() => assertEquals { expected = Period{ minutes = -1; }; actual = oneMinute.minusMinutes(2); };
shared test void testMinusMinutesSameInstance_Periods() => assertTrue( oneMinute.minusMinutes(0) === oneMinute );

shared test void testMinusSeconds_Periods() => assertEquals { expected = Period{ seconds = 0; }; actual = oneSecond.minusSeconds(1); };
shared test void testMinusSecondsNegative_Periods() => assertEquals { expected = Period{ seconds = -1; }; actual = oneSecond.minusSeconds(2); };
shared test void testMinusSecondsSameInstance_Periods() => assertTrue( oneSecond.minusSeconds(0) === oneSecond );

shared test void testMinusMillis_Periods() => assertEquals { expected = Period{ milliseconds = 0; }; actual = oneMillisecond.minusMilliseconds(1); };
shared test void testMinusMillisNegative_Periods() => assertEquals { expected = Period{ milliseconds = -1; }; actual = oneMillisecond.minusMilliseconds(2); };
shared test void testMinusMillisSameInstance_Periods() => assertTrue( oneMillisecond.minusMilliseconds(0) === oneMillisecond );

shared test void testComparableYearMonth_Periods() => assertEquals( oneYear <=> twelveMonths, equal );
shared test void testComparableYearYearHalf_Periods() => assertEquals( oneYear < oneHalfYear, true );
shared test void testComparableYearHalfMonths_Periods() => assertEquals( oneHalfYear > twelveMonths, true );

shared test void testWithYears_Periods() => assertEquals { expected = Period{ years = 3; months = 6;}; actual = oneHalfYear.withYears(3); };
shared test void testWithMonths_Periods() => assertEquals { expected = Period{ years = 1; months = 3;}; actual = oneYear.withMonths(3); };
shared test void testWithDays_Periods() => assertEquals { expected = Period{ years = 1; days = 10; }; actual = oneYear.withDays(10); };
shared test void testWithHours_Periods() => assertEquals { expected = Period{ years = 1; hours = 10; }; actual = oneYear.withHours(10); };
shared test void testWithMinutes_Periods() => assertEquals { expected = Period{ years = 1; minutes = 10; }; actual = oneYear.withMinutes(10); };
shared test void testWithSeconds_Periods() => assertEquals { expected = Period{ years = 1; seconds = 10; }; actual = oneYear.withSeconds(10); };
shared test void testWithMillis_Periods() => assertEquals { expected = Period{ years = 1; milliseconds = 10; }; actual = oneYear.withMilliseconds(10); };

shared test void testStringNormalizedMillis() => assertEquals { expected = "PT360H"; actual = Period { milliseconds = 15 * milliseconds.perDay ; }.normalized().string; };
shared test void testStringNormalizedSeconds() => assertEquals { expected = "PT360H"; actual = Period { seconds = 15 * seconds.perDay ; }.normalized().string; };
shared test void testStringNormalizedMinutes() => assertEquals { expected = "PT360H"; actual = Period { minutes = 15 * minutes.perDay ; }.normalized().string; };
shared test void testStringNormalizedHours() => assertEquals { expected = "PT360H"; actual = Period { hours = 15 * hours.perDay ; }.normalized().string; };
shared test void testStringFullTime() => assertEquals { expected = "PT59H59M59.999S"; actual = Period { 
                                      hours = 59;
                                      minutes = 59;
                                      seconds = 59;
                                      milliseconds = 999; 
                                    }.string; };
shared test void testStringTimePaddedString() => assertEquals { expected = "PT1H1M1.001S"; actual = Period { 
                                               hours = 1;
                                               minutes = 1;
                                               seconds = 1;
                                               milliseconds = 1; 
                                            }.string; };

shared test void testScalablePeriod() {
    //Rules suggested by scalable interface
    assertEquals { expected = Period { years = 200; }; actual = 1 ** Period{ years = 200;}; };
    assertEquals { expected = Period { years = -200; }; actual = -1 ** Period{ years = 200;}; };
    assertEquals { expected = Period { years = 0; }; actual = 0 ** Period{ years = 200;}; };
    assertEquals { expected = Period { years = 400; }; actual = 2 ** Period{ years = 200;}; };

    Period period = Period (4, 4, 4, 4, 4, 4);
    Period result = Period (16, 16, 16, 16, 16, 16);  
    assertEquals { expected = result; actual = 4 ** period; };
}

shared test void testEqualsAndHashPeriod() {
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
    assertEquals { expected = period; actual = normalized; };
}

void assertPeriod( Integer year = 0, Integer month = 0, Integer day = 0, Integer hour = 0, Integer minute = 0, Integer second = 0, Integer milli = 0) {
    value p = Period(year, month, day, hour, minute, second, milli);
    assertEquals { expected = year; actual = p.years; };
    assertEquals { expected = month; actual = p.months; };
    assertEquals { expected = day; actual = p.days; };
    assertEquals { expected = hour; actual = p.hours; };
    assertEquals { expected = minute; actual = p.minutes; };
    assertEquals { expected = second; actual = p.seconds; };
    assertEquals { expected = milli; actual = p.milliseconds; };
}
