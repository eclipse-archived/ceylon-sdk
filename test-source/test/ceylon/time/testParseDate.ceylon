import ceylon.test { ... }
import ceylon.time { ... }

import ceylon.time.parse { ... }

shared class ISO8601ParserTest() {

    value expect2014December29 = shuffle(curry(assertEquals))(date(2014, 12, 29));

    shared test void it_parses_YYYYMMDD_formatted_string()
            => expect2014December29(parseDate("20141229"));

    shared test void it_parses_YYYY_MM_DD_formatted_string()
            => expect2014December29(parseDate("2014-12-29"));

    shared test void it_parses_YYYYWwwD_formatted_string()
            => expect2014December29(parseDate("2015W011"));

    shared test void it_parses_YYYY_Www_D_formatted_string()
            => expect2014December29(parseDate("2015-W01-1"));

    shared test void it_parses_YYYYDDD_formatted_string()
            => expect2014December29(parseDate("2014363"));

    shared test void it_parses_YYYY_DDD_formatted_string()
            => expect2014December29(parseDate("2014-363"));

}
