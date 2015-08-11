import ceylon.test { ... }
import ceylon.time { ... }

import ceylon.time.iso8601 { ... }
import ceylon.time.timezone { ... }

shared class ISO8601ParserTest() {

    /* Parse ISO 8601 date */
    
    value expect2014December29 = shuffle(curry(assertEquals))(date(2014, 12, 29));

    shared test void it_parses_YYYYMMDD_formatted_date()
            => expect2014December29(parseDate("20141229"));

    shared test void it_parses_YYYY_MM_DD_formatted_date()
            => expect2014December29(parseDate("2014-12-29"));

    shared test void it_parses_YYYYWwwD_formatted_date()
            => expect2014December29(parseDate("2015W011"));

    shared test void it_parses_YYYY_Www_D_formatted_date()
            => expect2014December29(parseDate("2015-W01-1"));

    shared test void it_parses_YYYYDDD_formatted_date()
            => expect2014December29(parseDate("2014363"));

    shared test void it_parses_YYYY_DDD_formatted_date()
            => expect2014December29(parseDate("2014-363"));

    /* parse ISO 8601 time */
    
    shared test void it_parses_hh_mm_ss_sss_time()
            => assertEquals(parseTime("12:34:05.678"), time(12, 34, 05, 678));

    shared test void it_parses_hhmmss_sss_time()
            => assertEquals(parseTime("123405.678"), time(12, 34, 05, 678));

    shared test void it_parses_hh_mm_ss_time()
            => assertEquals(parseTime("12:34:05"), time(12, 34, 05));

    shared test void it_parses_hhmmss_time()
            => assertEquals(parseTime("123405"), time(12, 34, 05));

    shared test void it_parses_hh_mm_time()
            => assertEquals(parseTime("12:34"), time(12, 34));

    shared test void it_parses_hhmm_time()
            => assertEquals(parseTime("1234"), time(12, 34));

    shared test void it_parses_hh_time()
            => assertEquals(parseTime("12"), time(12, 00));
    
    shared test void it_parses_24_hour_midnight() 
            => assertEquals(parseTime("2400"), time(00, 00));
    
    shared test void it_does_not_parses_24_hour_time() 
            => assertNull(parseTime("24:05"));
    
    shared test void it_parses_hh_with_fractional_minutes()
            => assertEquals(parseTime("12,5"), time(12, 30));
    
    shared test void it_parses_hh_mm_with_fractional_seconds()
            => assertEquals(parseTime("12:34,5"), time(12, 34, 30));
    
    
    shared test void it_parses_hhmm_with_fractional_seconds()
            => assertEquals(parseTime("1234,5"), time(12, 34, 30));
    
    /* Parse ISO 8601 date-time */
    
    shared test void it_parses_YYYYMMDD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("20141229T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
    
    shared test void it_parses_24_hour_midnight_datetime() => assertEquals {
        actual = parseDateTime("20141229T2400"); 
        expected = dateTime(2014, 12, 30, 00, 00, 00);
    };
    
    shared test void it_parses_YYYWwwD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("2015W011T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
    
    shared test void it_parses_YYYDDD_hhmmss_datetime() => assertEquals {
        actual = parseDateTime("2014363T123405");
        expected = dateTime(2014, 12, 29, 12, 34, 05);
    };
    
    shared test void it_parses_zoneDateTime() => assertEquals {
        actual = parseZoneDateTime("2014363T123405+0530");
        expected = zoneDateTime(timeZone.offset(5, 30), 2014, 12, 29, 12, 34, 05);
    };
    
    shared test void it_parses_Zulu_zoneDateTime() => assertEquals {
        actual = parseZoneDateTime("2014363T123405Z");
        expected = zoneDateTime(timeZone.utc, 2014, 12, 29, 12, 34, 05);
    };
}

