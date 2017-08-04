import ceylon.test {
    test, assertTrue
}
import ceylon.time {
    date
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object localDates {
    // TODO error conditions

    shared test void simple() {
        checkValue { input = "0000-01-01"; expected = date(0, 1, 1); };
        checkValue { input = "9999-12-31"; expected = date(9999, 12, 31); };
        checkValue { input = "2017-02-28"; expected = date(2017, 2, 28); };

        // error, disallowed by ceylon.time:
        // checkValue { input = "2017-02-29"; expected = date(2017, 3, 1); };
    }

    shared test void truncatedDate1()
        =>  assertTrue(parseToml("key = 1999-12-3") is TomlParseException);

    shared test void truncatedDate2()
        =>  assertTrue(parseToml("key = 1999-12-") is TomlParseException);

    shared test void truncatedDate3()
        =>  assertTrue(parseToml("key = 1999-12") is TomlParseException);

    shared test void truncatedDate4()
        =>  assertTrue(parseToml("key = 1999-1") is TomlParseException);

    shared test void truncatedDate5()
        =>  assertTrue(parseToml("key = 1999-") is TomlParseException);

    shared void test() {
        simple();
        truncatedDate1();
        truncatedDate2();
        truncatedDate3();
        truncatedDate4();
        truncatedDate5();
    }
}
