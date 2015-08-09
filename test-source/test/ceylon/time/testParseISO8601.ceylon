import ceylon.test { ... }
import ceylon.time { ... }

import ceylon.time.iso8601 { ... }

shared class ISO8601ParserTest() {

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
}

