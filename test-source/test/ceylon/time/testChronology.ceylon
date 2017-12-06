import ceylon.test {
    assertEquals,
    test,
    parameters
}
import ceylon.time {
    date,
    time
}
import ceylon.time.base {
    january,
    tuesday
}
import ceylon.time.chronology {
    unixTime,
    gregorian
}

shared test void testUnixTime() {
    assertEquals { expected = 719163; actual = unixTime.epoch; };
    assertEquals { expected = 719163; actual = unixTime.fixedFromTime(1); };
    assertEquals { expected = 1356998400000; actual = unixTime.timeFromFixed(date(2013, january, 1).dayOfEra); };
    assertEquals { expected = unixTime.timeOfDay(1357032630000); actual = time(9, 30, 30).millisecondsOfDay; };
}

[[Integer, Integer]*] gregorianMonths = [
    [1,  gregorian.january],
    [2,  gregorian.february],
    [3,  gregorian.march],
    [4,  gregorian.april],
    [5,  gregorian.may],
    [6,  gregorian.june],
    [7,  gregorian.july],
    [8,  gregorian.august],
    [9,  gregorian.september],
    [10, gregorian.october],
    [11, gregorian.november],
    [12, gregorian.december]
];
parameters (`value gregorianMonths`)
shared test void testGregorianMonths(Integer expectedMonth, Integer actualMonth)
        => assertEquals { expected = expectedMonth; actual = actualMonth; };

shared test void testGregorian() {
    gregorian.checkDate([2013, 1, 1]);
    gregorian.checkDate([2012, 2, 29]);
    gregorian.checkDate([2010, 12, 31]);

    assertEquals { expected = [1970, 1, 1]; actual = gregorian.dateFrom(unixTime.epoch); };
    assertEquals { expected = 1; actual = gregorian.dayFrom(unixTime.epoch); };
    assertEquals { expected = tuesday.integer; actual = gregorian.dayOfWeekFrom(735065); };
    assertEquals { expected = 719163; actual = gregorian.fixedFrom([1970,1,1]); };

    assertEquals { expected = true; actual = gregorian.leapYear(2012); };
    assertEquals { expected = false; actual = gregorian.leapYear(2010); };

    assertEquals { expected = gregorian.january; actual = gregorian.monthFrom(719163); };
}
