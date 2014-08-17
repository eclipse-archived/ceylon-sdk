import ceylon.time.base {
    october,
    february,
    sunday,
    april
}
import ceylon.time {
    Period,
    newTime = time,
    date
}
import ceylon.test {
    test,
    assertEquals
}
import ceylon.time.timezone.model {
    wallClockDefinition,
    AtTime,
    utcTimeDefinition,
    OnLastOfMonth,
    OnFixedDay,
    OnFirstOfMonth,
    Rule
}
import ceylon.time.timezone.parser {
    parseRuleLine
}

//Sample of more simple and correct tests:
shared test void parseSimpleRuleLine() {
    variable value rule = parseRuleLine("Rule    Brazil    1931    only    -    Oct     3    11:00    1:00    S");
    assertEquals(rule[0], "Brazil");
    assertEquals(rule[1],
        Rule(1931, 1931, october, OnFixedDay(3), AtTime(newTime(11,0), wallClockDefinition), Period{hours=1;}, "S"));
    
    rule = parseRuleLine("Rule    Brazil    2013    2014    -    Feb    Sun>=15    0:00    0    -");
    assertEquals(rule[0], "Brazil");
    assertEquals(rule[1],
        Rule(2013, 2014, february, OnFirstOfMonth(sunday, 15), AtTime(newTime(0,0), wallClockDefinition), Period(), "-"));
    
    rule = parseRuleLine("Rule    Chile    1987    only    -    Apr    12    3:00u    0    -");
    assertEquals(rule[0], "Chile");
    assertEquals(rule[1],
        Rule(1987, 1987, april, OnFixedDay(12), AtTime(newTime(3,0), utcTimeDefinition), Period(), "-"));
    
    rule = parseRuleLine("Rule    Falk    1984    1985    -    Apr    lastSun    0:00    0    -");
    assertEquals(rule[0], "Falk");
    assertEquals(rule[1],
        Rule(1984, 1985, april, OnLastOfMonth(sunday), AtTime(newTime(0,0), wallClockDefinition), Period(), "-"));
}

shared test void onFixedDayRuleProducesFixedDate() {
    assertEquals(OnFixedDay(3).date(1931, october), date(1931, october, 3));
}

shared test void onFirstOfMonthRuleProducesOnFirstOfMonthDate() {
    assertEquals(OnFirstOfMonth(sunday, 15).date(2013, february), date(2013, february, 17));
    assertEquals(OnFirstOfMonth(sunday, 15).date(2014, february), date(2014, february, 16));
}

shared test void onLastOfMonthDayRuleProducesLastOfMonthDate() {
    assertEquals(OnLastOfMonth(sunday).date(1983, april), date(1983, april, 24));
    assertEquals(OnLastOfMonth(sunday).date(1984, april), date(1984, april, 29));
    assertEquals(OnLastOfMonth(sunday).date(2004, february), date(2004, february, 29));
}
