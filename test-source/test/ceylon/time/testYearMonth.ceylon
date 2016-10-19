import ceylon.test {
    test,
    assertEquals
}
import ceylon.time {
    yearMonth
}
import ceylon.time.base {
    january,
    december,
    february,
    october,
    Month,
    november,
    march,
    april
}

shared test void testyearMonthComparision() {
    assertEquals(yearMonth(2016, january) <=> yearMonth(2016, january), equal);
    assertEquals(yearMonth(2015, january) <=> yearMonth(2016, january), smaller);
    assertEquals(yearMonth(2016, december) <=> yearMonth(2016, january), larger);
    assertEquals(yearMonth(2017, december) <=> yearMonth(2016, january), larger);
}

shared test void test_jan_1900() => assertyearMonth(1900, january, !leapYear);
shared test void test_oct_1974() => assertyearMonth(1974, october, !leapYear);
shared test void test_dec_1982() => assertyearMonth(1982, december, !leapYear);
shared test void test_dec_1999() => assertyearMonth(1999, december, !leapYear);
shared test void test_jan_2000() => assertyearMonth(2000, january, leapYear);
shared test void test_feb_2012() => assertyearMonth(2012, february, leapYear);

shared test void testyearMonthPlusMonths() {
    assertEquals(yearMonth(2016, january).plusMonths(1), yearMonth(2016, february));
    assertEquals(yearMonth(2016, january).plusMonths(12), yearMonth(2017, january));
    assertEquals(yearMonth(2016, december).plusMonths(13), yearMonth(2018, january));
}

shared test void testyearMonthMinusMonths() {
    assertEquals(yearMonth(2016, january).minusMonths(1), yearMonth(2015, december));
    assertEquals(yearMonth(2016, january).minusMonths(12), yearMonth(2015, january));
    assertEquals(yearMonth(2016, december).minusMonths(13), yearMonth(2015, november));
}

shared test void testyearMonthWithMonth() {
    assertEquals(yearMonth(2016, january).withMonth(december), yearMonth(2016, december));
    assertEquals(yearMonth(2016, january).withMonth(march), yearMonth(2016, march));
    assertEquals(yearMonth(2016, december).withMonth(april), yearMonth(2016, april));
}

shared test void testyearMonthPlusYears() {
    assertEquals(yearMonth(2016, january).plusYears(1), yearMonth(2017, january));
    assertEquals(yearMonth(2016, january).plusYears(12), yearMonth(2028, january));
    assertEquals(yearMonth(2016, december).plusYears(13), yearMonth(2029, december));
}

shared test void testyearMonthMinusYears() {
    assertEquals(yearMonth(2016, january).minusYears(1), yearMonth(2015, january));
    assertEquals(yearMonth(2016, january).minusYears(12), yearMonth(2004, january));
    assertEquals(yearMonth(2016, december).minusYears(13), yearMonth(2003, december));
}

shared test void testyearMonthWithYear() {
    assertEquals(yearMonth(2016, january).withYear(1900), yearMonth(1900, january));
    assertEquals(yearMonth(2016, january).withYear(1970), yearMonth(1970, january));
    assertEquals(yearMonth(2016, december).withYear(2020), yearMonth(2020, december));
}

shared test void testyearMonthString() {
    assertEquals(yearMonth(2016, january).string, "2016-01");
    assertEquals(yearMonth(2015, april).string, "2015-04");
    assertEquals(yearMonth(2016, december).string, "2016-12");
}

shared test void testyearMonthNeighbour() {
    assertEquals(yearMonth(2016, january).neighbour(0), yearMonth(2016, january));
    assertEquals(yearMonth(2015, april).neighbour(1), yearMonth(2015, april).successor);
    assertEquals(yearMonth(2015, april).neighbour(-1), yearMonth(2015, april).predecessor);
}

shared test void testyearMonthOffset() {
    assertEquals(yearMonth(2016, january).offset(yearMonth(2016, january)), 0);
    assertEquals(yearMonth(2016, january).successor.offset(yearMonth(2016, january)), 1);
}

shared test void testyearMonthOrdinal() {
    value ym1983_01 = yearMonth(1983, january);
    variable value cont = 0;
    for ( current in ym1983_01..yearMonth(1984, january) ) {
        assertEquals( ym1983_01.plusMonths(cont++), current );
    }
}

void assertyearMonth(Integer year, Month month, Boolean leap) {
    value actual = yearMonth(year, month);
    assertEquals(actual.year, year);
    assertEquals(actual.month, month);
    assertEquals(actual.leapYear, leap);
}
