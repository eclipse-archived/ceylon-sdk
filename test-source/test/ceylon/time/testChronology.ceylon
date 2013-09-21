import ceylon.test { assertEquals, suite }
import ceylon.time.chronology { unixTime, gregorian }
import ceylon.time { date, time }
import ceylon.time.base { january, tuesday }

shared void runChronologyTests(String suiteName="Chronology tests") {
    suite(suiteName,
    "Testing Unix Time" -> testUnixTime,
    "Testing Gregorian months" -> testGregorianMonths,
    "Testing Gregorian" -> testGregorian
);
}

shared void testUnixTime() {
    assertEquals(719163, unixTime.epoch);
    assertEquals(719163, unixTime.fixedFromTime(1));
    assertEquals(1356998400000, unixTime.timeFromFixed(date(2013, january, 1).dayOfEra));
    assertEquals(unixTime.timeOfDay(1357032630000), time(9, 30, 30).millisecondsOfDay);
}

shared void testGregorianMonths() {
    assertEquals(1,  gregorian.january);
    assertEquals(2,  gregorian.february);
    assertEquals(3,  gregorian.march);
    assertEquals(4,  gregorian.april);
    assertEquals(5,  gregorian.may);
    assertEquals(6,  gregorian.june);
    assertEquals(7,  gregorian.july);
    assertEquals(8,  gregorian.august);
    assertEquals(9,  gregorian.september);
    assertEquals(10, gregorian.october);
    assertEquals(11, gregorian.november);
    assertEquals(12, gregorian.december);
}

shared void testGregorian() {
    gregorian.checkDate([2013, 1, 1]);
    gregorian.checkDate([2012, 2, 29]);
    gregorian.checkDate([2010, 12, 31]);

    assertEquals([1970, 1, 1], gregorian.dateFrom(unixTime.epoch));
    assertEquals(1, gregorian.dayFrom(unixTime.epoch));
    assertEquals(tuesday.integer, gregorian.dayOfWeekFrom(735065));
    assertEquals(719163, gregorian.fixedFrom([1970,1,1]));

    assertEquals(true, gregorian.leapYear(2012));
    assertEquals(false, gregorian.leapYear(2010));

    assertEquals(gregorian.january, gregorian.monthFrom(719163));
}
