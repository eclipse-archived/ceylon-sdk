import ceylon.test {
    test,
    assertEquals
}

import ceylon.time {
    Period,
    date,
    time
}
import ceylon.time.timezone.model {
    standardZoneRule,
    AbbreviationZoneFormat,
    ZoneUntil,
    ZoneTimeline,
    ReplacedZoneFormat,
    AtWallClockTime,
	untilPresent
}
import ceylon.time.base {
    january,
    september,
    october
}
import ceylon.time.timezone.parser.iana {
	parseZoneLine
}

shared test void testParseZoneLineForAmericaManaus() {
    variable value zone = parseZoneLine("Zone America/Manaus    -4:00:04 -    LMT    1914");
    variable value expected = ZoneTimeline {
        offset = Period{ hours = -4; seconds = -4; };
        rule = standardZoneRule;
        format = AbbreviationZoneFormat("LMT");
        ZoneUntil(date(1914, january, 1), AtWallClockTime(time(0,0))); // 1914 jan 01
    };
    assertEquals(zone[0], "America/Manaus");
    assertEquals(zone[1], expected);
    
    zone = parseZoneLine("-4:00    Brazil    AM%sT    1988 Sep 12", "America/Manaus");
    expected = ZoneTimeline {
        offset = Period{ hours = -4; };
        rule = standardZoneRule;
        format = ReplacedZoneFormat("AM%sT");
        ZoneUntil(date(1988, september, 12), AtWallClockTime(time(0,0))); // 1988 Sep 12
    };
    assertEquals(zone[0], "America/Manaus");
    assertEquals(zone[1], expected);
    
    zone = parseZoneLine("-4:00    -    AMT    1993 Sep 28", "America/Manaus");
    expected = ZoneTimeline {
        offset = Period{ hours = -4; };
        rule = standardZoneRule;
        format = AbbreviationZoneFormat("AMT");
        ZoneUntil(date(1993, september, 28), AtWallClockTime(time(0,0))); // 1993 Sep 28
    };
    assertEquals(zone[0], "America/Manaus");
    assertEquals(zone[1], expected);
    
    zone = parseZoneLine("-4:00    Brazil    AM%sT    1994 Sep 22", "America/Manaus");
    expected = ZoneTimeline {
        offset = Period{ hours = -4; };
        rule = standardZoneRule;
        format = ReplacedZoneFormat("AM%sT");
        ZoneUntil(date(1994, september, 22), AtWallClockTime(time(0,0))); // 1994 Sep 22
    };
    assertEquals(zone[0], "America/Manaus");
    assertEquals(zone[1], expected);
    
    zone = parseZoneLine("-4:00    -    AMT", "America/Manaus");
    expected = ZoneTimeline {
        offset = Period{ hours = -4; };
        rule = standardZoneRule;
        format = AbbreviationZoneFormat("AMT");
        untilPresent;
    };
    assertEquals(zone[0], "America/Manaus");
    assertEquals(zone[1], expected);
}

test void parseParseZoneLineForAmericaArgentinaUshuaia() {
    variable value zone = parseZoneLine("Zone America/Argentina/Ushuaia -4:33:12 - LMT 1894 Oct 31");
    variable value expected = ZoneTimeline {
        offset = Period{ hours = -4; minutes = -33; seconds = -12; };
        rule = standardZoneRule;
        format = AbbreviationZoneFormat("LMT");
        ZoneUntil(date(1894, october, 31), AtWallClockTime(time(0,0))); // 1894 Oct 31
    };
    assertEquals(zone[0], "America/Argentina/Ushuaia");
    assertEquals(zone[1], expected);
}