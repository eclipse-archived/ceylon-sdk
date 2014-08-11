import ceylon.time.timezone.parser {
    Rule,
    DayRule,
    TimeRule,
    Day,
    Signal
}
import ceylon.time.base {
    october,
    Month,
    DayOfWeek,
    february,
    sunday
}
import ceylon.time {
    Period,
    newTime = time,
    Time
}
import ceylon.test {
    assertTrue,
    test,
    assertEquals
}

List<Rule>? brazilRule = provider.rules.get("Brazil");

test void testBrazilRules() {
//Rule    Brazil    1931    only    -    Oct     3    11:00    1:00    S
    assertRule {
        _fromYear = 1931;
        _toYear = 1931;
        _type = "-";
        _month = october;
        _onDay = "3";
        _day = 3;
        _dow = null;
        _comparison = equal;
        _atTime = "11:00";
        _time = newTime(11,0);
        _signal = 1;
        _period = Period{hours = 1;};
        _letter = "S";
    }; 
    
//Rule    Brazil    2013    2014    -    Feb    Sun>=15    0:00    0    -
    assertRule {
        _fromYear = 2013;
        _toYear = 2014;
        _type = "-";
        _month = february;
        _onDay = "Sun>=15";
        _day = 15;
        _dow = sunday;
        _comparison = larger;
        _atTime = "0:00";
        _time = newTime(0,0);
        _signal = 1;
        _period = Period();
        _letter = "-";
    }; 
    
}

void assertRule(Integer _fromYear, Integer _toYear, String _type, Month _month, 
                String _onDay, Day? _day, DayOfWeek? _dow, Comparison _comparison,
                String _atTime, Time _time, Signal _signal,
                Period _period, String _letter) {
    assert(exists brazilRule);

    value rule =
            Rule {
        fromYear = _fromYear;
        toYear = _toYear;
        type = _type;
        month = _month;
        onDay = DayRule(_onDay);
        atTime = TimeRule(_atTime);
        offset = _period;
        letter = _letter;
    };
    
    assertTrue(brazilRule.contains(rule));
    assertEquals(rule.onDay.day, _day);
    assertEquals(rule.onDay.dayOfWeek, _dow);
    assertEquals(rule.onDay.comparison, _comparison);
    
    assertEquals(rule.atTime.time, _time);
    assertEquals(rule.atTime.signal, _signal);
}