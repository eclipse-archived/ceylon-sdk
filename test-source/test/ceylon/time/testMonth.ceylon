import ceylon.test {
    assertEquals,
    test,
    parameters
}
import ceylon.time.base {
    january,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december,
    monthOf,
    Month
}

[Integer, Month][12] month_number_tests = [
    [1, january],
    [2, february],
    [3, march],
    [4, april],
    [5, may],
    [6, june],
    [7, july],
    [8, august],
    [9, september],
    [10, october],
    [11, november],
    [12, december]
];
parameters (`value month_number_tests`)
shared test void test_month_number(Integer number, Month month)
        => assertEquals { expected = number; actual = month.integer; };

[String, Month][12] month_string_tests = [
    ["january", january],
    ["february", february],
    ["march", march],
    ["april", april],
    ["may", may],
    ["june", june],
    ["july", july],
    ["august", august],
    ["september", september],
    ["october", october],
    ["november", november],
    ["december", december]
];
parameters (`value month_string_tests`)
shared test void test_month_string(String string, Month month)
        => assertEquals { expected = string; actual = month.string; };

[Month, Month][12] month_predSucc_tests = [
    [december, january],
    [january, february],
    [february, march],
    [march, april],
    [april, may],
    [may, june],
    [june, july],
    [july, august],
    [august, september],
    [september, october],
    [october, november],
    [november, december]
];
parameters (`value month_predSucc_tests`)
shared test void test_month_predecessor(Month predecessor, Month month)
        => assertEquals { expected = predecessor; actual = month.predecessor; };
parameters (`value month_predSucc_tests`)
shared test void test_month_successor(Month month, Month successor)
        => assertEquals { expected = successor; actual = month.successor; };

parameters (`value month_number_tests`)
shared test void test_monthOf(Integer number, Month month) {
    assertEquals { expected = month; actual = monthOf(number); "month of number"; };
    assertEquals { expected = month; actual = monthOf(month); "month of month"; };
}

[Integer, Integer, Month][12] numberOfDays_tests = [
    [31, 31, january],
    [28, 29, february],
    [31, 31, march],
    [30, 30, april],
    [31, 31, may],
    [30, 30, june],
    [31, 31, july],
    [31, 31, august],
    [30, 30, september],
    [31, 31, october],
    [30, 30, november],
    [31, 31, december]
];
parameters (`value numberOfDays_tests`)
shared test void test_numberOfDays(Integer onRegularYear, Integer onLeapYear, Month month) {
    assertEquals { expected = onRegularYear; actual = month.numberOfDays(); "regular year"; };
    assertEquals { expected = onLeapYear; actual = month.numberOfDays(leapYear); "leap year"; };
}

[Integer, Integer, Month][12] firstDayOfYear_tests = [
    [1, 1, january],
    [32, 32, february],
    [60, 61, march],
    [91, 92, april],
    [121, 122, may],
    [152, 153, june],
    [182, 183, july],
    [213, 214, august],
    [244, 245, september],
    [274, 275, october],
    [305, 306, november],
    [335, 336, december]
];
parameters (`value firstDayOfYear_tests`)
shared test void test_firstDayOfYear(Integer onRegularYear, Integer onLeapYear, Month month) {
    assertEquals { expected = onRegularYear; actual = month.firstDayOfYear(); "regular year"; };
    assertEquals { expected = onLeapYear; actual = month.firstDayOfYear(leapYear); "leap year"; };
}

shared test void test_compare() {
    for (i in 1:12) {
        for (j in 1:12) {
            assertEquals { expected = i <=> j; actual = monthOf(i) <=> monthOf(j); };
        }
    }
}

[Integer, Month, Month][13] january_PlusMinusMonths_tests = [
    [0, january, january],
    [1, february, december],
    [2, march, november],
    [3, april, october],
    [4, may, september],
    [5, june, august],
    [6, july, july],
    [7, august, june],
    [8, september, may],
    [9, october, april],
    [10, november, march],
    [11, december, february],
    [12, january, january]
];
parameters (`value january_PlusMinusMonths_tests`)
shared test void test_january_plusMinusMonths(Integer offset, Month plus, Month minus) {
    assertEquals { expected = plus; actual = january.plusMonths(offset); "plusMonths"; };
    assertEquals { expected = minus; actual = january.minusMonths(offset); "minusMonths"; };
}

[Month, Integer, Integer][27] january_add_tests = [
    [december, -2, -13],
    [january, -1, -12],
    [february, -1, -11],
    [march, -1, -10],
    [april, -1, -9],
    [may, -1, -8],
    [june, -1, -7],
    [july, -1, -6],
    [august, -1, -5],
    [september, -1, -4],
    [october, -1, -3],
    [november, -1, -2],
    [december, -1, -1],
    [january, 0, 0],
    [february, 0, 1],
    [march, 0, 2],
    [april, 0, 3],
    [may, 0, 4],
    [june, 0, 5],
    [july, 0, 6],
    [august, 0, 7],
    [september, 0, 8],
    [october, 0, 9],
    [november, 0, 10],
    [december, 0, 11],
    [january, 1, 12],
    [february, 1, 13]
];
parameters (`value january_add_tests`)
shared test void test_january_add(Month expectedMonth, Integer expectedYears, Integer offset) {
    value actual = january.add(offset);
    assertEquals { expected = [expectedMonth, expectedYears]; actual = [actual.month, actual.years]; };
}

// Enumerable tests:
shared test void monthOffsetsAlwaysIncreasing1() => assertEquals {
    actual = [for (m in february..january) m.offset(february)];
    expected = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
};

shared test void monthOffsetsAlwaysIncreasing2() => assertEquals {
    actual = [for (m in february..january) m.offset(january)];
    expected = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0];
};

shared test void monthOffsetsAlwaysIncreasing3() => assertEquals {
    actual = [for (m in february..january) february.offset(m)];
    expected = [0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
};

shared test void monthOffsetsAlwaysIncreasing4() => assertEquals {
    actual = [for (m in february..january) january.offset(m)];
    expected = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0];
};

shared test void monthsNeigbours() => assertEquals {
    actual = [for (i in -12..12) january.neighbour(i)];
    expected = [january, february, march, april, may, june, july, august, september, october, november, december, january, february, march, april, may, june, july, august, september, october, november, december, january];
};
