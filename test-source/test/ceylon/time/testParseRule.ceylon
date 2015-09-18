import ceylon.test { ... }
import ceylon.time.base { ... }
import ceylon.time { newTime = time, ... }
import ceylon.time.timezone.model { ... }

import ceylon.time.timezone.parser.iana { parseRuleLine }

testSuite({
    `class ParseBrazil1931OnlyRuleTest`,
    `class ParseBrazil2013To2014RuleTest`,
    `class ParseChile1987OnlyRuleTest`,
    `class ParseFalk1984To1985RuleTest`
})
shared void parseRuleTests() {}

shared class ParseBrazil1931OnlyRuleTest() {
    value rule = parseRuleLine("Rule    Brazil    1931    only    -    Oct     3    11:00    1:00    S");

    shared test void ruleNameIsBrazil() => assertEquals(rule[0],          "Brazil");
    shared test void ruleFrom1931()     => assertEquals(rule[1].fromYear, 1931);
    shared test void ruleTo1931()       => assertEquals(rule[1].toYear,   1931);
    shared test void ruleInOctober()    => assertEquals(rule[1].inMonth,  october);
    shared test void ruleOnThird()      => assertEquals(rule[1].onDay,    OnFixedDay(3));
    shared test void ruleAtEleven()     => assertEquals(rule[1].atTime,   AtWallClockTime(newTime(11, 00)));
    shared test void ruleSaving1h()     => assertEquals(rule[1].save,     Period { hours = 1; });
    shared test void ruleLetterS()      => assertEquals(rule[1].letter,   "S");
}

shared class ParseBrazil2013To2014RuleTest() {
    value rule = parseRuleLine("Rule    Brazil    2013    2014    -    Feb    Sun>=15    0:00    0    -");

    shared test void ruleNameIsBrazil() => assertEquals(rule[0],          "Brazil");
    shared test void ruleFrom2013()     => assertEquals(rule[1].fromYear, 2013);
    shared test void ruleTo2014()       => assertEquals(rule[1].toYear,   2014);
    shared test void ruleInFebruary()   => assertEquals(rule[1].inMonth,  february);
    shared test void ruleOnFirstSun()   => assertEquals(rule[1].onDay,    OnFirstOfMonth(sunday, 15));
    shared test void ruleAtMidnight()   => assertEquals(rule[1].atTime,   AtWallClockTime(newTime(0, 00)));
    shared test void ruleSaving0()      => assertEquals(rule[1].save,     Period());
    shared test void ruleLetter_()      => assertEquals(rule[1].letter,   "-");
}

shared class ParseChile1987OnlyRuleTest() {
    value rule = parseRuleLine("Rule    Chile    1987    only    -    Apr    12    3:00u    0    -");

    shared test void ruleNameIsBrazil() => assertEquals(rule[0],          "Chile");
    shared test void ruleFrom1987()     => assertEquals(rule[1].fromYear, 1987);
    shared test void ruleTo1987()       => assertEquals(rule[1].toYear,   1987);
    shared test void ruleInApril()      => assertEquals(rule[1].inMonth,  april);
    shared test void ruleOn12()         => assertEquals(rule[1].onDay,    OnFixedDay(12));
    shared test void ruleAtThree()      => assertEquals(rule[1].atTime,   AtWallClockTime(newTime(3, 00)));
    shared test void ruleSaving0()      => assertEquals(rule[1].save,     Period());
    shared test void ruleLetter_()      => assertEquals(rule[1].letter,   "-");
}

shared class ParseFalk1984To1985RuleTest() {
    value rule = parseRuleLine("Rule    Falk    1984    1985    -    Apr    lastSun    0:00    0    -");

    shared test void ruleNameIsBrazil() => assertEquals(rule[0],          "Falk");
    shared test void ruleFrom1984()     => assertEquals(rule[1].fromYear, 1984);
    shared test void ruleTo1985()       => assertEquals(rule[1].toYear,   1985);
    shared test void ruleInApril()      => assertEquals(rule[1].inMonth,  april);
    shared test void ruleOnLastSunday() => assertEquals(rule[1].onDay,    OnLastOfMonth(sunday));
    shared test void ruleAtMidnight()   => assertEquals(rule[1].atTime,   AtWallClockTime(newTime(0, 00)));
    shared test void ruleSaving0()      => assertEquals(rule[1].save,     Period());
    shared test void ruleLetter_()      => assertEquals(rule[1].letter,   "-");
}



testSuite({
    `class OnLastOfMonthTest`,
    `class OnFirstOfMonthTest`,
    `function fixedDayRuleProducesFixedDate`
})
shared void onDayRuleTests() {}

shared test void fixedDayRuleProducesFixedDate() => assertEquals {
    actual = OnFixedDay(3).date(1931, october);
    expected = date(1931, october, 3);
};

shared class OnFirstOfMonthTest() {
    value firstSundayOnOrAfter27 = OnFirstOfMonth(sunday, 27);

    shared test void sunday27() => assertEquals {
        actual = firstSundayOnOrAfter27.date(2015, september);
        expected = date(2015, september, 27);
    };

    shared test void nextSunday() => assertEquals {
        actual = firstSundayOnOrAfter27.date(2015, may);
        expected = date(2015, may, 31);
    };

    shared test void nextMonth() => assertThatException { 
        function exceptionSource() {
            return firstSundayOnOrAfter27.date(2015, february);
        }
    };

}

shared class OnLastOfMonthTest() {
    value onLastSunday = OnLastOfMonth(sunday);

    shared test void returnsLastSundayOfApril1983() => assertEquals {
        actual = onLastSunday.date(1983, april);
        expected = date(1983, april, 24);
    };

    shared test void returnsSunday() => assertEquals {
        actual = onLastSunday.date(1983, april).dayOfWeek;
        expected = sunday;
    };

    shared test void nextSundayIsInMarch() => assertEquals {
        actual = onLastSunday.date(1983, april).plusWeeks(1).month;
        expected = may;
    };

}