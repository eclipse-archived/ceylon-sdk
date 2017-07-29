import ceylon.test {
    test
}
import ceylon.time.iso8601 {
    parseZoneDateTime
}

shared object offsetDateTimes {
    // TODO error conditions

    shared test void zulu() {
        checkValue {
            input = "0000-01-01T00:00:00Z";
            expected = parseZoneDateTime("0000-01-01T00:00:00Z");
        };
        checkValue {
            input = "9999-12-31T23:59:59Z";
            expected = parseZoneDateTime("9999-12-31T23:59:59Z");
        };
    }

    shared test void offsets() {
        // FIXME ceylon.time doesn't allow offsets < -12:00, but should that be supported?
        checkValue {
            input = "0000-01-01T00:00:00-00:00";
            expected = parseZoneDateTime("0000-01-01T00:00:00+00:00");
        };
        checkValue {
            input = "0000-01-01T00:00:00+00:00";
            expected = parseZoneDateTime("0000-01-01T00:00:00+00:00");
        };
        
        checkValue {
            input = "0000-01-01T00:00:00-12:00";
            expected = parseZoneDateTime("0000-01-01T00:00:00-12:00");
        };
        checkValue {
            input = "0000-01-01T00:00:00+12:00";
            expected = parseZoneDateTime("0000-01-01T00:00:00+12:00");
        };

        checkValue {
            input = "9999-12-31T23:59:59-00:00";
            expected = parseZoneDateTime("9999-12-31T23:59:59+00:00");
        };
        checkValue {
            input = "9999-12-31T23:59:59+00:00";
            expected = parseZoneDateTime("9999-12-31T23:59:59+00:00");
        };

        checkValue {
            input = "9999-12-31T23:59:59-12:00";
            expected = parseZoneDateTime("9999-12-31T23:59:59-12:00");
        };
        checkValue {
            input = "9999-12-31T23:59:59+12:00";
            expected = parseZoneDateTime("9999-12-31T23:59:59+12:00");
        };

        checkValue {
            input = "2017-07-05T12:00:00+01:23";
            expected = parseZoneDateTime("2017-07-05T12:00:00+01:23");
        };
        checkValue {
            input = "2017-07-05T12:00:00-01:23";
            expected = parseZoneDateTime("2017-07-05T12:00:00-01:23");
        };
    }

    shared void test() {
        zulu();
        offsets();
    }
}
