import ceylon.test { assertEquals, suite }
import ceylon.time.base { january, february, march, april, may, june, july, august, september, october, november, december, monthOf, Month }

shared void runMonthTests(String suiteName="Month tests") {
    suite(suiteName,
    "Testing month january number" -> test_january_number,
    "Testing month february number" -> test_february_number,
    "Testing month march number" -> test_march_number,
    "Testing month april number" -> test_april_number,
    "Testing month may number" -> test_may_number,
    "Testing month june number" -> test_june_number,
    "Testing month july number" -> test_july_number,
    "Testing month august number" -> test_august_number,
    "Testing month september number" -> test_september_number,
    "Testing month october number" -> test_october_number,
    "Testing month november number" -> test_november_number,
    "Testing month december number" -> test_december_number,
    "Testing month january string" -> test_january_string,
    "Testing month february string" -> test_february_string,
    "Testing month march string" -> test_march_string,
    "Testing month april string" -> test_april_string,
    "Testing month may string" -> test_may_string,
    "Testing month june string" -> test_june_string,
    "Testing month july string" -> test_july_string,
    "Testing month august string" -> test_august_string,
    "Testing month september string" -> test_september_string,
    "Testing month october string" -> test_october_string,
    "Testing month november string" -> test_november_string,
    "Testing month december string" -> test_december_string,
    "Testing month january predecessor" -> test_january_predecessor,
    "Testing month february predecessor" -> test_february_predecessor,
    "Testing month march predecessor" -> test_march_predecessor,
    "Testing month april predecessor" -> test_april_predecessor,
    "Testing month may predecessor" -> test_may_predecessor,
    "Testing month june predecessor" -> test_june_predecessor,
    "Testing month july predecessor" -> test_july_predecessor,
    "Testing month august predecessor" -> test_august_predecessor,
    "Testing month september predecessor" -> test_september_predecessor,
    "Testing month october predecessor" -> test_october_predecessor,
    "Testing month november predecessor" -> test_november_predecessor,
    "Testing month december predecessor" -> test_december_predecessor,
    "Testing month january successor" -> test_january_successor,
    "Testing month february successor" -> test_february_successor,
    "Testing month march successor" -> test_march_successor,
    "Testing month april successor" -> test_april_successor,
    "Testing month may successor" -> test_may_successor,
    "Testing month june successor" -> test_june_successor,
    "Testing month july successor" -> test_july_successor,
    "Testing month august successor" -> test_august_successor,
    "Testing month september successor" -> test_september_successor,
    "Testing month october successor" -> test_october_successor,
    "Testing month november successor" -> test_november_successor,
    "Testing month december successor" -> test_december_successor,
    "Testing month of 1" -> test_monthOf_1,
    "Testing month of 2" -> test_monthOf_2,
    "Testing month of 3" -> test_monthOf_3,
    "Testing month of 4" -> test_monthOf_4,
    "Testing month of 5" -> test_monthOf_5,
    "Testing month of 6" -> test_monthOf_6,
    "Testing month of 7" -> test_monthOf_7,
    "Testing month of 8" -> test_monthOf_8,
    "Testing month of 9" -> test_monthOf_9,
    "Testing month of 10" -> test_monthOf_10,
    "Testing month of 11" -> test_monthOf_11,
    "Testing month of 12" -> test_monthOf_12,
    "Testing month of january" -> test_monthOf_january,
    "Testing month of february" -> test_monthOf_february,
    "Testing month of march" -> test_monthOf_march,
    "Testing month of april" -> test_monthOf_april,
    "Testing month of may" -> test_monthOf_may,
    "Testing month of june" -> test_monthOf_june,
    "Testing month of july" -> test_monthOf_july,
    "Testing month of august" -> test_monthOf_august,
    "Testing month of september" -> test_monthOf_september,
    "Testing month of october" -> test_monthOf_october,
    "Testing month of november" -> test_monthOf_november,
    "Testing month of december" -> test_monthOf_december,
    "Testing month january number of days" -> test_january_numberOfDays,
    "Testing month february number of days" -> test_february_numberOfDays,
    "Testing month march number of days" -> test_march_numberOfDays,
    "Testing month april number of days" -> test_april_numberOfDays,
    "Testing month may number of days" -> test_may_numberOfDays,
    "Testing month june number of days" -> test_june_numberOfDays,
    "Testing month july number of days" -> test_july_numberOfDays,
    "Testing month august number of days" -> test_august_numberOfDays,
    "Testing month september number of days" -> test_september_numberOfDays,
    "Testing month october number of days" -> test_october_numberOfDays,
    "Testing month november number of days" -> test_november_numberOfDays,
    "Testing month december number of days" -> test_december_numberOfDays,
    "Testing month january number of days leap year" -> test_january_numberOfDays_leapYear,
    "Testing month february number of days leap year" -> test_february_numberOfDays_leapYear,
    "Testing month march number of days leap year" -> test_march_numberOfDays_leapYear,
    "Testing month april number of days leap year" -> test_april_numberOfDays_leapYear,
    "Testing month may number of days leap year" -> test_may_numberOfDays_leapYear,
    "Testing month june number of days leap year" -> test_june_numberOfDays_leapYear,
    "Testing month july number of days leap year" -> test_july_numberOfDays_leapYear,
    "Testing month august number of days leap year" -> test_august_numberOfDays_leapYear,
    "Testing month september number of days leap year" -> test_september_numberOfDays_leapYear,
    "Testing month october number of days leap year" -> test_october_numberOfDays_leapYear,
    "Testing month november number of days leap year" -> test_november_numberOfDays_leapYear,
    "Testing month december number of days leap year" -> test_december_numberOfDays_leapYear,
    "Testing month january first day of year" -> test_january_firstDayOfYear,
    "Testing month february first day of year" -> test_february_firstDayOfYear,
    "Testing month march first day of year" -> test_march_firstDayOfYear,
    "Testing month april first day of year" -> test_april_firstDayOfYear,
    "Testing month may first day of year" -> test_may_firstDayOfYear,
    "Testing month june first day of year" -> test_june_firstDayOfYear,
    "Testing month july first day of year" -> test_july_firstDayOfYear,
    "Testing month august first day of year" -> test_august_firstDayOfYear,
    "Testing month september first day of year" -> test_september_firstDayOfYear,
    "Testing month october first day of year" -> test_october_firstDayOfYear,
    "Testing month november first day of year" -> test_november_firstDayOfYear,
    "Testing month december first day of year" -> test_december_firstDayOfYear,
    "Testing month january first day of leap year" -> test_january_firstDayOfYear_leapYear,
    "Testing month february first day of leap year" -> test_february_firstDayOfYear_leapYear,
    "Testing month march first day of leap year" -> test_march_firstDayOfYear_leapYear,
    "Testing month april first day of leap year" -> test_april_firstDayOfYear_leapYear,
    "Testing month may first day of leap year" -> test_may_firstDayOfYear_leapYear,
    "Testing month june first day of leap year" -> test_june_firstDayOfYear_leapYear,
    "Testing month july first day of leap year" -> test_july_firstDayOfYear_leapYear,
    "Testing month august first day of leap year" -> test_august_firstDayOfYear_leapYear,
    "Testing month september first day of leap year" -> test_september_firstDayOfYear_leapYear,
    "Testing month october first day of leap year" -> test_october_firstDayOfYear_leapYear,
    "Testing month november first day of leap year" -> test_november_firstDayOfYear_leapYear,
    "Testing month december first day of leap year" -> test_december_firstDayOfYear_leapYear,
    "Testing month compare january" -> test_compareJanuary,
    "Testing month compare february" -> test_compareFebruary,
    "Testing month compare march" -> test_compareMarch,
    "Testing month compare april" -> test_compareApril,
    "Testing month compare may" -> test_compareMay,
    "Testing month compare june" -> test_compareJune,
    "Testing month compare july" -> test_compareJuly,
    "Testing month compare august" -> test_compareAugust,
    "Testing month compare september" -> test_compareSeptember,
    "Testing month compare october" -> test_compareOctober,
    "Testing month compare november" -> test_compareNovember,
    "Testing month compare december" -> test_compareDecember,
    "Testing month plus months" -> test_january_plusMonths,
    "Testing month minus months" -> test_january_minusMonths,
    "Testing month january minus 13" -> test_january_minus_13,
    "Testing month january minus 12" -> test_january_minus_12,
    "Testing month january minus 11" -> test_january_minus_11,
    "Testing month january minus 10" -> test_january_minus_10,
    "Testing month january minus 9" -> test_january_minus_9,
    "Testing month january minus 8" -> test_january_minus_8,
    "Testing month january minus 7" -> test_january_minus_7,
    "Testing month january minus 6" -> test_january_minus_6,
    "Testing month january minus 5" -> test_january_minus_5,
    "Testing month january minus 4" -> test_january_minus_4,
    "Testing month january minus 3" -> test_january_minus_3,
    "Testing month january minus 2" -> test_january_minus_2,
    "Testing month january minus 1" -> test_january_minus_1,
    "Testing month january plus 0" -> test_january_plus_0,
    "Testing month january plus 1" -> test_january_plus_1,
    "Testing month january plus 2" -> test_january_plus_2,
    "Testing month january plus 3" -> test_january_plus_3,
    "Testing month january plus 4" -> test_january_plus_4,
    "Testing month january plus 5" -> test_january_plus_5,
    "Testing month january plus 6" -> test_january_plus_6,
    "Testing month january plus 7" -> test_january_plus_7,
    "Testing month january plus 8" -> test_january_plus_8,
    "Testing month january plus 9" -> test_january_plus_9,
    "Testing month january plus 10" -> test_january_plus_10,
    "Testing month january plus 11" -> test_january_plus_11,
    "Testing month january plus 12" -> test_january_plus_12,
    "Testing month january plus 13" -> test_january_plus_13
);
}

shared void test_january_number() => assertEquals(1, january.integer);
shared void test_february_number() => assertEquals(2, february.integer);
shared void test_march_number() => assertEquals(3, march.integer);
shared void test_april_number() => assertEquals(4, april.integer);
shared void test_may_number() => assertEquals(5, may.integer);
shared void test_june_number() => assertEquals(6, june.integer);
shared void test_july_number() => assertEquals(7, july.integer);
shared void test_august_number() => assertEquals(8, august.integer);
shared void test_september_number() => assertEquals(9, september.integer);
shared void test_october_number() => assertEquals(10, october.integer);
shared void test_november_number() => assertEquals(11, november.integer);
shared void test_december_number() => assertEquals(12, december.integer);

shared void test_january_string() => assertEquals("january", january.string);
shared void test_february_string() => assertEquals("february", february.string);
shared void test_march_string() => assertEquals("march", march.string);
shared void test_april_string() => assertEquals("april", april.string);
shared void test_may_string() => assertEquals("may", may.string);
shared void test_june_string() => assertEquals("june", june.string);
shared void test_july_string() => assertEquals("july", july.string);
shared void test_august_string() => assertEquals("august", august.string);
shared void test_september_string() => assertEquals("september", september.string);
shared void test_october_string() => assertEquals("october", october.string);
shared void test_november_string() => assertEquals("november", november.string);
shared void test_december_string() => assertEquals("december", december.string);

shared void test_january_predecessor() => assertEquals(december, january.predecessor);
shared void test_february_predecessor() => assertEquals(january, february.predecessor);
shared void test_march_predecessor() => assertEquals(february, march.predecessor);
shared void test_april_predecessor() => assertEquals(march, april.predecessor);
shared void test_may_predecessor() => assertEquals(april, may.predecessor);
shared void test_june_predecessor() => assertEquals(may, june.predecessor);
shared void test_july_predecessor() => assertEquals(june, july.predecessor);
shared void test_august_predecessor() => assertEquals(july, august.predecessor);
shared void test_september_predecessor() => assertEquals(august, september.predecessor);
shared void test_october_predecessor() => assertEquals(september, october.predecessor);
shared void test_november_predecessor() => assertEquals(october, november.predecessor);
shared void test_december_predecessor() => assertEquals(november, december.predecessor);

shared void test_january_successor() => assertEquals(february, january.successor);
shared void test_february_successor() => assertEquals(march, february.successor);
shared void test_march_successor() => assertEquals(april, march.successor);
shared void test_april_successor() => assertEquals(may, april.successor);
shared void test_may_successor() => assertEquals(june, may.successor);
shared void test_june_successor() => assertEquals(july, june.successor);
shared void test_july_successor() => assertEquals(august, july.successor);
shared void test_august_successor() => assertEquals(september, august.successor);
shared void test_september_successor() => assertEquals(october, september.successor);
shared void test_october_successor() => assertEquals(november, october.successor);
shared void test_november_successor() => assertEquals(december, november.successor);
shared void test_december_successor() => assertEquals(january, december.successor);

shared void test_monthOf_1() => assertEquals(january, monthOf(1));
shared void test_monthOf_2() => assertEquals(february, monthOf(2));
shared void test_monthOf_3() => assertEquals(march, monthOf(3));
shared void test_monthOf_4() => assertEquals(april, monthOf(4));
shared void test_monthOf_5() => assertEquals(may, monthOf(5));
shared void test_monthOf_6() => assertEquals(june, monthOf(6));
shared void test_monthOf_7() => assertEquals(july, monthOf(7));
shared void test_monthOf_8() => assertEquals(august, monthOf(8));
shared void test_monthOf_9() => assertEquals(september, monthOf(9));
shared void test_monthOf_10() => assertEquals(october, monthOf(10));
shared void test_monthOf_11() => assertEquals(november, monthOf(11));
shared void test_monthOf_12() => assertEquals(december, monthOf(12));

shared void test_monthOf_january() => assertEquals(january, monthOf(january));
shared void test_monthOf_february() => assertEquals(february, monthOf(february));
shared void test_monthOf_march() => assertEquals(march, monthOf(march));
shared void test_monthOf_april() => assertEquals(april, monthOf(april));
shared void test_monthOf_may() => assertEquals(may, monthOf(may));
shared void test_monthOf_june() => assertEquals(june, monthOf(june));
shared void test_monthOf_july() => assertEquals(july, monthOf(july));
shared void test_monthOf_august() => assertEquals(august, monthOf(august));
shared void test_monthOf_september() => assertEquals(september, monthOf(september));
shared void test_monthOf_october() => assertEquals(october, monthOf(october));
shared void test_monthOf_november() => assertEquals(november, monthOf(november));
shared void test_monthOf_december() => assertEquals(december, monthOf(december));

shared void test_january_numberOfDays() => assertEquals(31, january.numberOfDays());
shared void test_february_numberOfDays() => assertEquals(28, february.numberOfDays());
shared void test_march_numberOfDays() => assertEquals(31, march.numberOfDays());
shared void test_april_numberOfDays() => assertEquals(30, april.numberOfDays());
shared void test_may_numberOfDays() => assertEquals(31, may.numberOfDays());
shared void test_june_numberOfDays() => assertEquals(30, june.numberOfDays());
shared void test_july_numberOfDays() => assertEquals(31, july.numberOfDays());
shared void test_august_numberOfDays() => assertEquals(31, august.numberOfDays());
shared void test_september_numberOfDays() => assertEquals(30, september.numberOfDays());
shared void test_october_numberOfDays() => assertEquals(31, october.numberOfDays());
shared void test_november_numberOfDays() => assertEquals(30, november.numberOfDays());
shared void test_december_numberOfDays() => assertEquals(31, december.numberOfDays());

shared void test_january_numberOfDays_leapYear() => assertEquals(31, january.numberOfDays(leapYear));
shared void test_february_numberOfDays_leapYear() => assertEquals(29, february.numberOfDays(leapYear));
shared void test_march_numberOfDays_leapYear() => assertEquals(31, march.numberOfDays(leapYear));
shared void test_april_numberOfDays_leapYear() => assertEquals(30, april.numberOfDays(leapYear));
shared void test_may_numberOfDays_leapYear() => assertEquals(31, may.numberOfDays(leapYear));
shared void test_june_numberOfDays_leapYear() => assertEquals(30, june.numberOfDays(leapYear));
shared void test_july_numberOfDays_leapYear() => assertEquals(31, july.numberOfDays(leapYear));
shared void test_august_numberOfDays_leapYear() => assertEquals(31, august.numberOfDays(leapYear));
shared void test_september_numberOfDays_leapYear() => assertEquals(30, september.numberOfDays(leapYear));
shared void test_october_numberOfDays_leapYear() => assertEquals(31, october.numberOfDays(leapYear));
shared void test_november_numberOfDays_leapYear() => assertEquals(30, november.numberOfDays(leapYear));
shared void test_december_numberOfDays_leapYear() => assertEquals(31, december.numberOfDays(leapYear));

shared void test_january_firstDayOfYear() => assertEquals(1, january.fisrtDayOfYear());
shared void test_february_firstDayOfYear() => assertEquals(32, february.fisrtDayOfYear());
shared void test_march_firstDayOfYear() => assertEquals(60, march.fisrtDayOfYear());
shared void test_april_firstDayOfYear() => assertEquals(91, april.fisrtDayOfYear());
shared void test_may_firstDayOfYear() => assertEquals(121, may.fisrtDayOfYear());
shared void test_june_firstDayOfYear() => assertEquals(152, june.fisrtDayOfYear());
shared void test_july_firstDayOfYear() => assertEquals(182, july.fisrtDayOfYear());
shared void test_august_firstDayOfYear() => assertEquals(213, august.fisrtDayOfYear());
shared void test_september_firstDayOfYear() => assertEquals(244, september.fisrtDayOfYear());
shared void test_october_firstDayOfYear() => assertEquals(274, october.fisrtDayOfYear());
shared void test_november_firstDayOfYear() => assertEquals(305, november.fisrtDayOfYear());
shared void test_december_firstDayOfYear() => assertEquals(335, december.fisrtDayOfYear());

shared void test_january_firstDayOfYear_leapYear() => assertEquals(1, january.fisrtDayOfYear(leapYear));
shared void test_february_firstDayOfYear_leapYear() => assertEquals(32, february.fisrtDayOfYear(leapYear));
shared void test_march_firstDayOfYear_leapYear() => assertEquals(61, march.fisrtDayOfYear(leapYear));
shared void test_april_firstDayOfYear_leapYear() => assertEquals(92, april.fisrtDayOfYear(leapYear));
shared void test_may_firstDayOfYear_leapYear() => assertEquals(122, may.fisrtDayOfYear(leapYear));
shared void test_june_firstDayOfYear_leapYear() => assertEquals(153, june.fisrtDayOfYear(leapYear));
shared void test_july_firstDayOfYear_leapYear() => assertEquals(183, july.fisrtDayOfYear(leapYear));
shared void test_august_firstDayOfYear_leapYear() => assertEquals(214, august.fisrtDayOfYear(leapYear));
shared void test_september_firstDayOfYear_leapYear() => assertEquals(245, september.fisrtDayOfYear(leapYear));
shared void test_october_firstDayOfYear_leapYear() => assertEquals(275, october.fisrtDayOfYear(leapYear));
shared void test_november_firstDayOfYear_leapYear() => assertEquals(306, november.fisrtDayOfYear(leapYear));
shared void test_december_firstDayOfYear_leapYear() => assertEquals(336, december.fisrtDayOfYear(leapYear));

shared void test_compareJanuary() {
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

shared void test_compareFebruary() {
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

shared void test_compareMarch() {
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

shared void test_compareApril() {
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

shared void test_compareMay() {
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

shared void test_compareJune() {
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

shared void test_compareJuly() {
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

shared void test_compareAugust() {
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

shared void test_compareSeptember() {
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

shared void test_compareOctober() {
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

shared void test_compareNovember() {
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

shared void test_compareDecember() {
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

shared void test_january_plusMonths() {
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

shared void test_january_minusMonths() {
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

shared void test_january_minus_13() => assertMonthAdd(january.add(-13), [december, -2]);
shared void test_january_minus_12() => assertMonthAdd(january.add(-12), [january, -1]);
shared void test_january_minus_11() => assertMonthAdd(january.add(-11), [february, -1]);
shared void test_january_minus_10() => assertMonthAdd(january.add(-10), [march, -1]);
shared void test_january_minus_9() => assertMonthAdd(january.add(-9), [april, -1]);
shared void test_january_minus_8() => assertMonthAdd(january.add(-8), [may, -1]);
shared void test_january_minus_7() => assertMonthAdd(january.add(-7), [june, -1]);
shared void test_january_minus_6() => assertMonthAdd(january.add(-6), [july, -1]);
shared void test_january_minus_5() => assertMonthAdd(january.add(-5), [august, -1]);
shared void test_january_minus_4() => assertMonthAdd(january.add(-4), [september, -1]);
shared void test_january_minus_3() => assertMonthAdd(january.add(-3), [october, -1]);
shared void test_january_minus_2() => assertMonthAdd(january.add(-2), [november, -1]);
shared void test_january_minus_1() => assertMonthAdd(january.add(-1), [december, -1]);
shared void test_january_plus_0() => assertMonthAdd(january.add(0), [january, 0]);
shared void test_january_plus_1() => assertMonthAdd(january.add(1), [february, 0]);
shared void test_january_plus_2() => assertMonthAdd(january.add(2), [march, 0]);
shared void test_january_plus_3() => assertMonthAdd(january.add(3), [april, 0]);
shared void test_january_plus_4() => assertMonthAdd(january.add(4), [may, 0]);
shared void test_january_plus_5() => assertMonthAdd(january.add(5), [june, 0]);
shared void test_january_plus_6() => assertMonthAdd(january.add(6), [july, 0]);
shared void test_january_plus_7() => assertMonthAdd(january.add(7), [august, 0]);
shared void test_january_plus_8() => assertMonthAdd(january.add(8), [september, 0]);
shared void test_january_plus_9() => assertMonthAdd(january.add(9), [october, 0]);
shared void test_january_plus_10() => assertMonthAdd(january.add(10), [november, 0]);
shared void test_january_plus_11() => assertMonthAdd(january.add(11), [december, 0]);
shared void test_january_plus_12() => assertMonthAdd(january.add(12), [january, 1]);
shared void test_january_plus_13() => assertMonthAdd(january.add(13), [february, 1]);



void assertMonthAdd(Month.Overflow actual, [Month, Integer] expected){
    assertEquals(expected, [actual.month, actual.years]);
}

