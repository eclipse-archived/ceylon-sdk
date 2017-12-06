import ceylon.test {
    test, assertTrue
}
import ceylon.time.iso8601 {
    parseZoneDateTime
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object offsetDateTimes {

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
        // TODO ceylon.time doesn't allow offsets < -12:00, but should that be supported?
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

    shared test void badZone1()
        =>  assertTrue(parseToml("key = 2017-07-05T12:00:00z") is TomlParseException);

    shared test void badZone2()
        =>  assertTrue(parseToml("key = 2017-07-05T12:00:0012:00") is TomlParseException);

    shared test void badZone3()
        =>  assertTrue(parseToml("key = 2017-07-05T12:00:00+12:0") is TomlParseException);

    shared test void badZone4()
        =>  assertTrue(parseToml("key = 2017-07-05T12:00:00+1") is TomlParseException);

    shared void test() {
        zulu();
        offsets();
        badZone1();
        badZone2();
        badZone3();
        badZone4();
    }
}
