import ceylon.test {
    assertEquals,
    test
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

shared test void test_january_number() => assertEquals(1, january.integer);
shared test void test_february_number() => assertEquals(2, february.integer);
shared test void test_march_number() => assertEquals(3, march.integer);
shared test void test_april_number() => assertEquals(4, april.integer);
shared test void test_may_number() => assertEquals(5, may.integer);
shared test void test_june_number() => assertEquals(6, june.integer);
shared test void test_july_number() => assertEquals(7, july.integer);
shared test void test_august_number() => assertEquals(8, august.integer);
shared test void test_september_number() => assertEquals(9, september.integer);
shared test void test_october_number() => assertEquals(10, october.integer);
shared test void test_november_number() => assertEquals(11, november.integer);
shared test void test_december_number() => assertEquals(12, december.integer);

shared test void test_january_string() => assertEquals("january", january.string);
shared test void test_february_string() => assertEquals("february", february.string);
shared test void test_march_string() => assertEquals("march", march.string);
shared test void test_april_string() => assertEquals("april", april.string);
shared test void test_may_string() => assertEquals("may", may.string);
shared test void test_june_string() => assertEquals("june", june.string);
shared test void test_july_string() => assertEquals("july", july.string);
shared test void test_august_string() => assertEquals("august", august.string);
shared test void test_september_string() => assertEquals("september", september.string);
shared test void test_october_string() => assertEquals("october", october.string);
shared test void test_november_string() => assertEquals("november", november.string);
shared test void test_december_string() => assertEquals("december", december.string);

shared test void test_january_predecessor() => assertEquals(december, january.predecessor);
shared test void test_february_predecessor() => assertEquals(january, february.predecessor);
shared test void test_march_predecessor() => assertEquals(february, march.predecessor);
shared test void test_april_predecessor() => assertEquals(march, april.predecessor);
shared test void test_may_predecessor() => assertEquals(april, may.predecessor);
shared test void test_june_predecessor() => assertEquals(may, june.predecessor);
shared test void test_july_predecessor() => assertEquals(june, july.predecessor);
shared test void test_august_predecessor() => assertEquals(july, august.predecessor);
shared test void test_september_predecessor() => assertEquals(august, september.predecessor);
shared test void test_october_predecessor() => assertEquals(september, october.predecessor);
shared test void test_november_predecessor() => assertEquals(october, november.predecessor);
shared test void test_december_predecessor() => assertEquals(november, december.predecessor);

shared test void test_january_successor() => assertEquals(february, january.successor);
shared test void test_february_successor() => assertEquals(march, february.successor);
shared test void test_march_successor() => assertEquals(april, march.successor);
shared test void test_april_successor() => assertEquals(may, april.successor);
shared test void test_may_successor() => assertEquals(june, may.successor);
shared test void test_june_successor() => assertEquals(july, june.successor);
shared test void test_july_successor() => assertEquals(august, july.successor);
shared test void test_august_successor() => assertEquals(september, august.successor);
shared test void test_september_successor() => assertEquals(october, september.successor);
shared test void test_october_successor() => assertEquals(november, october.successor);
shared test void test_november_successor() => assertEquals(december, november.successor);
shared test void test_december_successor() => assertEquals(january, december.successor);

shared test void test_monthOf_1() => assertEquals(january, monthOf(1));
shared test void test_monthOf_2() => assertEquals(february, monthOf(2));
shared test void test_monthOf_3() => assertEquals(march, monthOf(3));
shared test void test_monthOf_4() => assertEquals(april, monthOf(4));
shared test void test_monthOf_5() => assertEquals(may, monthOf(5));
shared test void test_monthOf_6() => assertEquals(june, monthOf(6));
shared test void test_monthOf_7() => assertEquals(july, monthOf(7));
shared test void test_monthOf_8() => assertEquals(august, monthOf(8));
shared test void test_monthOf_9() => assertEquals(september, monthOf(9));
shared test void test_monthOf_10() => assertEquals(october, monthOf(10));
shared test void test_monthOf_11() => assertEquals(november, monthOf(11));
shared test void test_monthOf_12() => assertEquals(december, monthOf(12));

shared test void test_monthOf_january() => assertEquals(january, monthOf(january));
shared test void test_monthOf_february() => assertEquals(february, monthOf(february));
shared test void test_monthOf_march() => assertEquals(march, monthOf(march));
shared test void test_monthOf_april() => assertEquals(april, monthOf(april));
shared test void test_monthOf_may() => assertEquals(may, monthOf(may));
shared test void test_monthOf_june() => assertEquals(june, monthOf(june));
shared test void test_monthOf_july() => assertEquals(july, monthOf(july));
shared test void test_monthOf_august() => assertEquals(august, monthOf(august));
shared test void test_monthOf_september() => assertEquals(september, monthOf(september));
shared test void test_monthOf_october() => assertEquals(october, monthOf(october));
shared test void test_monthOf_november() => assertEquals(november, monthOf(november));
shared test void test_monthOf_december() => assertEquals(december, monthOf(december));

shared test void test_january_numberOfDays() => assertEquals(31, january.numberOfDays());
shared test void test_february_numberOfDays() => assertEquals(28, february.numberOfDays());
shared test void test_march_numberOfDays() => assertEquals(31, march.numberOfDays());
shared test void test_april_numberOfDays() => assertEquals(30, april.numberOfDays());
shared test void test_may_numberOfDays() => assertEquals(31, may.numberOfDays());
shared test void test_june_numberOfDays() => assertEquals(30, june.numberOfDays());
shared test void test_july_numberOfDays() => assertEquals(31, july.numberOfDays());
shared test void test_august_numberOfDays() => assertEquals(31, august.numberOfDays());
shared test void test_september_numberOfDays() => assertEquals(30, september.numberOfDays());
shared test void test_october_numberOfDays() => assertEquals(31, october.numberOfDays());
shared test void test_november_numberOfDays() => assertEquals(30, november.numberOfDays());
shared test void test_december_numberOfDays() => assertEquals(31, december.numberOfDays());

shared test void test_january_numberOfDays_leapYear() => assertEquals(31, january.numberOfDays(leapYear));
shared test void test_february_numberOfDays_leapYear() => assertEquals(29, february.numberOfDays(leapYear));
shared test void test_march_numberOfDays_leapYear() => assertEquals(31, march.numberOfDays(leapYear));
shared test void test_april_numberOfDays_leapYear() => assertEquals(30, april.numberOfDays(leapYear));
shared test void test_may_numberOfDays_leapYear() => assertEquals(31, may.numberOfDays(leapYear));
shared test void test_june_numberOfDays_leapYear() => assertEquals(30, june.numberOfDays(leapYear));
shared test void test_july_numberOfDays_leapYear() => assertEquals(31, july.numberOfDays(leapYear));
shared test void test_august_numberOfDays_leapYear() => assertEquals(31, august.numberOfDays(leapYear));
shared test void test_september_numberOfDays_leapYear() => assertEquals(30, september.numberOfDays(leapYear));
shared test void test_october_numberOfDays_leapYear() => assertEquals(31, october.numberOfDays(leapYear));
shared test void test_november_numberOfDays_leapYear() => assertEquals(30, november.numberOfDays(leapYear));
shared test void test_december_numberOfDays_leapYear() => assertEquals(31, december.numberOfDays(leapYear));

shared test void test_january_firstDayOfYear() => assertEquals(1, january.firstDayOfYear());
shared test void test_february_firstDayOfYear() => assertEquals(32, february.firstDayOfYear());
shared test void test_march_firstDayOfYear() => assertEquals(60, march.firstDayOfYear());
shared test void test_april_firstDayOfYear() => assertEquals(91, april.firstDayOfYear());
shared test void test_may_firstDayOfYear() => assertEquals(121, may.firstDayOfYear());
shared test void test_june_firstDayOfYear() => assertEquals(152, june.firstDayOfYear());
shared test void test_july_firstDayOfYear() => assertEquals(182, july.firstDayOfYear());
shared test void test_august_firstDayOfYear() => assertEquals(213, august.firstDayOfYear());
shared test void test_september_firstDayOfYear() => assertEquals(244, september.firstDayOfYear());
shared test void test_october_firstDayOfYear() => assertEquals(274, october.firstDayOfYear());
shared test void test_november_firstDayOfYear() => assertEquals(305, november.firstDayOfYear());
shared test void test_december_firstDayOfYear() => assertEquals(335, december.firstDayOfYear());

shared test void test_january_firstDayOfYear_leapYear() => assertEquals(1, january.firstDayOfYear(leapYear));
shared test void test_february_firstDayOfYear_leapYear() => assertEquals(32, february.firstDayOfYear(leapYear));
shared test void test_march_firstDayOfYear_leapYear() => assertEquals(61, march.firstDayOfYear(leapYear));
shared test void test_april_firstDayOfYear_leapYear() => assertEquals(92, april.firstDayOfYear(leapYear));
shared test void test_may_firstDayOfYear_leapYear() => assertEquals(122, may.firstDayOfYear(leapYear));
shared test void test_june_firstDayOfYear_leapYear() => assertEquals(153, june.firstDayOfYear(leapYear));
shared test void test_july_firstDayOfYear_leapYear() => assertEquals(183, july.firstDayOfYear(leapYear));
shared test void test_august_firstDayOfYear_leapYear() => assertEquals(214, august.firstDayOfYear(leapYear));
shared test void test_september_firstDayOfYear_leapYear() => assertEquals(245, september.firstDayOfYear(leapYear));
shared test void test_october_firstDayOfYear_leapYear() => assertEquals(275, october.firstDayOfYear(leapYear));
shared test void test_november_firstDayOfYear_leapYear() => assertEquals(306, november.firstDayOfYear(leapYear));
shared test void test_december_firstDayOfYear_leapYear() => assertEquals(336, december.firstDayOfYear(leapYear));

shared test void test_compareJanuary() {
    assertEquals(equal, january <=> january);
    assertEquals(smaller, january <=> february);
    assertEquals(smaller, january <=> march);
    assertEquals(smaller, january <=> april);
    assertEquals(smaller, january <=> may);
    assertEquals(smaller, january <=> june);
    assertEquals(smaller, january <=> july);
    assertEquals(smaller, january <=> august);
    assertEquals(smaller, january <=> september);
    assertEquals(smaller, january <=> october);
    assertEquals(smaller, january <=> november);
    assertEquals(smaller, january <=> december);
}

shared test void test_compareFebruary() {
    assertEquals(larger, february <=> january);
    assertEquals(equal, february <=> february);
    assertEquals(smaller, february <=> march);
    assertEquals(smaller, february <=> april);
    assertEquals(smaller, february <=> may);
    assertEquals(smaller, february <=> june);
    assertEquals(smaller, february <=> july);
    assertEquals(smaller, february <=> august);
    assertEquals(smaller, february <=> september);
    assertEquals(smaller, february <=> october);
    assertEquals(smaller, february <=> november);
    assertEquals(smaller, february <=> december);
}

shared test void test_compareMarch() {
    assertEquals(larger, march <=> january);
    assertEquals(larger, march <=> february);
    assertEquals(equal, march <=> march);
    assertEquals(smaller, march <=> april);
    assertEquals(smaller, march <=> may);
    assertEquals(smaller, march <=> june);
    assertEquals(smaller, march <=> july);
    assertEquals(smaller, march <=> august);
    assertEquals(smaller, march <=> september);
    assertEquals(smaller, march <=> october);
    assertEquals(smaller, march <=> november);
    assertEquals(smaller, march <=> december);
}

shared test void test_compareApril() {
    assertEquals(larger, april <=> january);
    assertEquals(larger, april <=> february);
    assertEquals(larger, april <=> march);
    assertEquals(equal, april <=> april);
    assertEquals(smaller, april <=> may);
    assertEquals(smaller, april <=> june);
    assertEquals(smaller, april <=> july);
    assertEquals(smaller, april <=> august);
    assertEquals(smaller, april <=> september);
    assertEquals(smaller, april <=> october);
    assertEquals(smaller, april <=> november);
    assertEquals(smaller, april <=> december);
}

shared test void test_compareMay() {
    assertEquals(larger, may <=> january);
    assertEquals(larger, may <=> february);
    assertEquals(larger, may <=> march);
    assertEquals(larger, may <=> april);
    assertEquals(equal, may <=> may);
    assertEquals(smaller, may <=> june);
    assertEquals(smaller, may <=> july);
    assertEquals(smaller, may <=> august);
    assertEquals(smaller, may <=> september);
    assertEquals(smaller, may <=> october);
    assertEquals(smaller, may <=> november);
    assertEquals(smaller, may <=> december);
}

shared test void test_compareJune() {
    assertEquals(larger, june <=> january);
    assertEquals(larger, june <=> february);
    assertEquals(larger, june <=> march);
    assertEquals(larger, june <=> april);
    assertEquals(larger, june <=> may);
    assertEquals(equal, june <=> june);
    assertEquals(smaller, june <=> july);
    assertEquals(smaller, june <=> august);
    assertEquals(smaller, june <=> september);
    assertEquals(smaller, june <=> october);
    assertEquals(smaller, june <=> november);
    assertEquals(smaller, june <=> december);
}

shared test void test_compareJuly() {
    assertEquals(larger, july <=> january);
    assertEquals(larger, july <=> february);
    assertEquals(larger, july <=> march);
    assertEquals(larger, july <=> april);
    assertEquals(larger, july <=> may);
    assertEquals(larger, july <=> june);
    assertEquals(equal, july <=> july);
    assertEquals(smaller, july <=> august);
    assertEquals(smaller, july <=> september);
    assertEquals(smaller, july <=> october);
    assertEquals(smaller, july <=> november);
    assertEquals(smaller, july <=> december);
}

shared test void test_compareAugust() {
    assertEquals(larger, august <=> january);
    assertEquals(larger, august <=> february);
    assertEquals(larger, august <=> march);
    assertEquals(larger, august <=> april);
    assertEquals(larger, august <=> may);
    assertEquals(larger, august <=> june);
    assertEquals(larger, august <=> july);
    assertEquals(equal, august <=> august);
    assertEquals(smaller, august <=> september);
    assertEquals(smaller, august <=> october);
    assertEquals(smaller, august <=> november);
    assertEquals(smaller, august <=> december);
}

shared test void test_compareSeptember() {
    assertEquals(larger, september <=> january);
    assertEquals(larger, september <=> february);
    assertEquals(larger, september <=> march);
    assertEquals(larger, september <=> april);
    assertEquals(larger, september <=> may);
    assertEquals(larger, september <=> june);
    assertEquals(larger, september <=> july);
    assertEquals(larger, september <=> august);
    assertEquals(equal, september <=> september);
    assertEquals(smaller, september <=> october);
    assertEquals(smaller, september <=> november);
    assertEquals(smaller, september <=> december);
}

shared test void test_compareOctober() {
    assertEquals(larger, october <=> january);
    assertEquals(larger, october <=> february);
    assertEquals(larger, october <=> march);
    assertEquals(larger, october <=> april);
    assertEquals(larger, october <=> may);
    assertEquals(larger, october <=> june);
    assertEquals(larger, october <=> july);
    assertEquals(larger, october <=> august);
    assertEquals(larger, october <=> september);
    assertEquals(equal, october <=> october);
    assertEquals(smaller, october <=> november);
    assertEquals(smaller, october <=> december);
}

shared test void test_compareNovember() {
    assertEquals(larger, november <=> january);
    assertEquals(larger, november <=> february);
    assertEquals(larger, november <=> march);
    assertEquals(larger, november <=> april);
    assertEquals(larger, november <=> may);
    assertEquals(larger, november <=> june);
    assertEquals(larger, november <=> july);
    assertEquals(larger, november <=> august);
    assertEquals(larger, november <=> september);
    assertEquals(larger, november <=> october);
    assertEquals(equal, november <=> november);
    assertEquals(smaller, november <=> december);
}

shared test void test_compareDecember() {
    assertEquals(larger, december <=> january);
    assertEquals(larger, december <=> february);
    assertEquals(larger, december <=> march);
    assertEquals(larger, december <=> april);
    assertEquals(larger, december <=> may);
    assertEquals(larger, december <=> june);
    assertEquals(larger, december <=> july);
    assertEquals(larger, december <=> august);
    assertEquals(larger, december <=> september);
    assertEquals(larger, december <=> october);
    assertEquals(larger, december <=> november);
    assertEquals(equal, december <=> december);
}

shared test void test_january_plusMonths() {
    assertEquals(january, january.plusMonths(0));
    assertEquals(february, january.plusMonths(1));
    assertEquals(march, january.plusMonths(2));
    assertEquals(april, january.plusMonths(3));
    assertEquals(may, january.plusMonths(4));
    assertEquals(june, january.plusMonths(5));
    assertEquals(july, january.plusMonths(6));
    assertEquals(august, january.plusMonths(7));
    assertEquals(september, january.plusMonths(8));
    assertEquals(october, january.plusMonths(9));
    assertEquals(november, january.plusMonths(10));
    assertEquals(december, january.plusMonths(11));
    assertEquals(january, january.plusMonths(12));
}

shared test void test_january_minusMonths() {
    assertEquals(january, january.minusMonths(0));
    assertEquals(december, january.minusMonths(1));
    assertEquals(november, january.minusMonths(2));
    assertEquals(october, january.minusMonths(3));
    assertEquals(september, january.minusMonths(4));
    assertEquals(august, january.minusMonths(5));
    assertEquals(july, january.minusMonths(6));
    assertEquals(june, january.minusMonths(7));
    assertEquals(may, january.minusMonths(8));
    assertEquals(april, january.minusMonths(9));
    assertEquals(march, january.minusMonths(10));
    assertEquals(february, january.minusMonths(11));
    assertEquals(january, january.minusMonths(12));
}

shared test void test_january_minus_13() => assertMonthAdd(january.add(-13), [december, -2]);
shared test void test_january_minus_12() => assertMonthAdd(january.add(-12), [january, -1]);
shared test void test_january_minus_11() => assertMonthAdd(january.add(-11), [february, -1]);
shared test void test_january_minus_10() => assertMonthAdd(january.add(-10), [march, -1]);
shared test void test_january_minus_9() => assertMonthAdd(january.add(-9), [april, -1]);
shared test void test_january_minus_8() => assertMonthAdd(january.add(-8), [may, -1]);
shared test void test_january_minus_7() => assertMonthAdd(january.add(-7), [june, -1]);
shared test void test_january_minus_6() => assertMonthAdd(january.add(-6), [july, -1]);
shared test void test_january_minus_5() => assertMonthAdd(january.add(-5), [august, -1]);
shared test void test_january_minus_4() => assertMonthAdd(january.add(-4), [september, -1]);
shared test void test_january_minus_3() => assertMonthAdd(january.add(-3), [october, -1]);
shared test void test_january_minus_2() => assertMonthAdd(january.add(-2), [november, -1]);
shared test void test_january_minus_1() => assertMonthAdd(january.add(-1), [december, -1]);
shared test void test_january_plus_0() => assertMonthAdd(january.add(0), [january, 0]);
shared test void test_january_plus_1() => assertMonthAdd(january.add(1), [february, 0]);
shared test void test_january_plus_2() => assertMonthAdd(january.add(2), [march, 0]);
shared test void test_january_plus_3() => assertMonthAdd(january.add(3), [april, 0]);
shared test void test_january_plus_4() => assertMonthAdd(january.add(4), [may, 0]);
shared test void test_january_plus_5() => assertMonthAdd(january.add(5), [june, 0]);
shared test void test_january_plus_6() => assertMonthAdd(january.add(6), [july, 0]);
shared test void test_january_plus_7() => assertMonthAdd(january.add(7), [august, 0]);
shared test void test_january_plus_8() => assertMonthAdd(january.add(8), [september, 0]);
shared test void test_january_plus_9() => assertMonthAdd(january.add(9), [october, 0]);
shared test void test_january_plus_10() => assertMonthAdd(january.add(10), [november, 0]);
shared test void test_january_plus_11() => assertMonthAdd(january.add(11), [december, 0]);
shared test void test_january_plus_12() => assertMonthAdd(january.add(12), [january, 1]);
shared test void test_january_plus_13() => assertMonthAdd(january.add(13), [february, 1]);



void assertMonthAdd(Month.Overflow actual, [Month, Integer] expected){
    assertEquals(expected, [actual.month, actual.years]);
}
