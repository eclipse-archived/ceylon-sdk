import ceylon.test { ... }
import ceylon.time { ... }

import ceylon.time.iso8601 { ... }
import ceylon.time.timezone { ... }

testSuite({
    `class ParseISO8601DateTest`, `class ParseIso8601TimeTest`, 
    `class ParseIso8601DateTimeTest`, `class ParseIso8601ZoneDateTimeTest`
})
shared void parseIso8601Tests() {}

shared class ParseISO8601DateTest() {

    /*
     * Happy cases
     */
    value expect2014December29 = shuffle(curry(assertEquals))(date(2014, 12, 29));

    test shared void it_parses_YYYYMMDD_formatted_date()
            => expect2014December29(parseDate("20141229"));

    test shared void it_parses_YYYY_MM_DD_formatted_date()
            => expect2014December29(parseDate("2014-12-29"));

    test shared void it_parses_YYYYWwwD_formatted_date()
            => expect2014December29(parseDate("2015W011"));

    test shared void it_parses_YYYY_Www_D_formatted_date()
            => expect2014December29(parseDate("2015-W01-1"));

    test shared void it_parses_YYYYDDD_formatted_date()
            => expect2014December29(parseDate("2014363"));

    test shared void it_parses_YYYY_DDD_formatted_date()
            => expect2014December29(parseDate("2014-363"));

    /*
     * Failure modes
     */

    test shared void fail_YYYYMMDD_on_invalid_month_number()
            => assertNull(parseDate("05042016"));
     
    test shared void fail_YYYY_MM_DD_on_invalid_month_number()
            => assertNull(parseDate("0504-20-16"));
}


shared class ParseIso8601TimeTest() {
    
    test shared void it_parses_hh_mm_ss_sss_time()
            => assertEquals(parseTime("12:34:05.678"), time(12, 34, 05, 678));

    test shared void it_parses_hhmmss_sss_time()
            => assertEquals(parseTime("123405.678"), time(12, 34, 05, 678));

    test shared void it_parses_hh_mm_ss_time()
            => assertEquals(parseTime("12:34:05"), time(12, 34, 05));

    test shared void it_parses_hhmmss_time()
            => assertEquals(parseTime("123405"), time(12, 34, 05));

    test shared void it_parses_hh_mm_time()
            => assertEquals(parseTime("12:34"), time(12, 34));

    test shared void it_parses_hhmm_time()
            => assertEquals(parseTime("1234"), time(12, 34));

    test shared void it_parses_hh_time()
            => assertEquals(parseTime("12"), time(12, 00));
    
    test shared void it_parses_24_hour_midnight() 
            => assertEquals(parseTime("2400"), time(00, 00));
    
    test shared void it_does_not_parses_24_hour_time() 
            => assertNull(parseTime("24:05"));
    
    test shared void it_parses_hh_with_fractional_minutes()
            => assertEquals(parseTime("12,5"), time(12, 30));
    
    test shared void it_parses_hh_mm_with_fractional_seconds()
            => assertEquals(parseTime("12:34,5"), time(12, 34, 30));
    
    
    test shared void it_parses_hhmm_with_fractional_seconds()
            => assertEquals(parseTime("1234,5"), time(12, 34, 30));
}

shared class ParseIso8601DateTimeTest() {
    
    test shared void it_parses_YYYYMMDD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("20141229T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
    
    test shared void it_parses_24_hour_midnight_datetime() => assertEquals {
        actual = parseDateTime("20141229T2400"); 
        expected = dateTime(2014, 12, 30, 00, 00, 00);
    };
    
    test shared void it_parses_YYYWwwD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("2015W011T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
    
    test shared void it_parses_YYYDDD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("2014363T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
}

shared class ParseIso8601ZoneDateTimeTest() {
    test shared void it_parses_zoneDateTime() => assertEquals {
        actual = parseZoneDateTime("2014363T123405+0530");
        expected = zoneDateTime(timeZone.offset(5, 30), 2014, 12, 29, 12, 34, 05);
    };
    
    test shared void it_parses_Zulu_zoneDateTime() => assertEquals {
        actual = parseZoneDateTime("2014363T123405Z");
        expected = zoneDateTime(timeZone.utc, 2014, 12, 29, 12, 34, 05);
    };
}

shared class ParseIso8601PeriodTest() {
    /*
     * Happy cases:
     */
    
    test shared void accept_Years_period() => assertEquals {
        actual = parsePeriod( "P1Y" );
        expected = Period { years = 1; };
    };
    
    test shared void accept_Months_period() => assertEquals {
        actual = parsePeriod( "P1M" );
        expected = Period { months = 1; };
    };
    
    test shared void accept_Weeks_period() => assertEquals {
        actual = parsePeriod( "P1W" );
        expected = Period { days = 7; };
    };
    
    test shared void accept_Days_period() => assertEquals {
        actual = parsePeriod( "P1D" );
        expected = Period { days = 1; };
    };
    
    test shared void accept_Hours_period() => assertEquals {
        actual = parsePeriod( "PT1H" );
        expected = Period { hours = 1; };
    };
    
    test shared void accept_Minutes_period() => assertEquals {
        actual = parsePeriod( "PT1M" );
        expected = Period { minutes = 1; };
    };
    
    test shared void accept_Seconds_period() => assertEquals {
        actual = parsePeriod( "PT1S" );
        expected = Period { seconds = 1; };
    };

    test shared void accept_DateOnly_period() => assertEquals {
        actual = parsePeriod( "P1Y2M3D" );
        expected = Period { years = 1; months = 2; days = 3; };
    };
    
    test shared void accept_TimeOnly_period() => assertEquals {
        actual = parsePeriod( "PT1H2M3S" );
        expected = Period { hours = 1; minutes = 2; seconds = 3; };
    };
    
    test shared void accept_DateTime_period() => assertEquals {
        actual = parsePeriod( "P1Y2M3DT4H5M6S" );
        expected = Period { years = 1; months = 2; days = 3; hours = 4; minutes = 5; seconds = 6; };
    };
    
    /*
     * Failure modes:
     */
    
    test shared void fail_on_Years_are_after_Months() => assertNull( parsePeriod( "P1M2Y" ) );
    
    test shared void fail_on_Years_are_after_Days() => assertNull( parsePeriod( "P1D2Y" ) );
    
    test shared void fail_on_Months_are_after_Days() => assertNull( parsePeriod( "P2D3M" ) );
    
    test shared void fail_on_Years_are_after_T() => assertNull( parsePeriod( "PT1Y" ) );
    
    test shared void fail_on_Days_are_after_T() => assertNull( parsePeriod( "PT1D" ) );
    
    test shared void fail_on_Digits_are_before_T() => assertNull( parsePeriod( "P1T" ) );
    
    test shared void fail_on_Hours_are_after_Minutes() => assertNull( parsePeriod( "PT1M2H" ) );
    
    test shared void fail_on_Hours_are_after_Seconds() => assertNull( parsePeriod( "PT1S2H" ) );
    
    test shared void fail_on_Minutes_are_after_Seconds() => assertNull( parsePeriod( "PT1S2M" ) );
    
    test shared void fail_on_Hours_are_before_T() => assertNull( parsePeriod( "P1H" ) );
    
    test shared void fail_on_Seconds_are_before_T() => assertNull( parsePeriod( "P1S" ) );
    
    test shared void fail_on_first_char_not_P() => assertNull( parsePeriod( "1Y" ) );
    
    test shared void fail_on_P_only() => assertNull( parsePeriod( "P" ) );
    
    test shared void fail_on_no_designator() => assertNull( parsePeriod( "P3" ) );
    
    test shared void fail_on_unknown_designator() => assertNull( parsePeriod( "P3G" ) );
    
}

shared class Bug583() {
    test shared void it_parses_700_milliseconds() => assertEquals {
        actual = parseDateTime("20160611T123456.7");
        expected = dateTime(2016, 06, 11, 12, 34, 56, 700);
    };

    test shared void it_parses_fractional_hours_025() => assertEquals {
        actual = parseDateTime("20160611T10.025");
        expected = dateTime(2016, 06, 11, 10, 01, 30, 000);
    };

    test shared void it_parses_fractional_hours_01() => assertEquals {
        actual = parseDateTime("20160611T10.01");
        expected = dateTime(2016, 06, 11, 10, 00, 36, 000);
    };

    test shared void it_parses_fractional_minutes() => assertEquals {
        actual = parseDateTime("20160611T1030.01");
        expected = dateTime(2016, 06, 11, 10, 30, 00, 600);
    };

    test shared void it_parses_fractional_minutes_with_colons() => assertEquals {
        actual = parseDateTime("20160611T10:30.01");
        expected = dateTime(2016, 06, 11, 10, 30, 00, 600);
    };
}
