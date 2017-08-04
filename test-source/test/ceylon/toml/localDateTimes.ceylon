import ceylon.test {
    test, assertTrue
}
import ceylon.time {
    dateTime
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object localDateTimes {

    shared test void simple() {
        checkValue { input = "0000-01-01T00:00:00"; expected = dateTime(0, 1, 1, 0, 0, 0); };
        checkValue { input = "9999-12-31T23:59:59"; expected = dateTime(9999, 12, 31, 23, 59, 59); };
    }

    shared test void withMillis() {
        checkValue { input = "0000-01-01T00:00:00.1"; expected = dateTime(0, 1, 1, 0, 0, 0, 100); };
        checkValue { input = "0000-01-01T00:00:00.001"; expected = dateTime(0, 1, 1, 0, 0, 0, 1); };

        checkValue { input = "9999-12-31T23:59:59.1"; expected = dateTime(9999, 12, 31, 23, 59, 59, 100); };
        checkValue { input = "9999-12-31T23:59:59.001"; expected = dateTime(9999, 12, 31, 23, 59, 59, 1); };
    }

    shared test void truncateMillis() {
        checkValue { input = "0000-01-01T00:00:00.0001"; expected = dateTime(0, 1, 1, 0, 0, 0, 0); };
        checkValue { input = "0000-01-01T00:00:00.0009"; expected = dateTime(0, 1, 1, 0, 0, 0, 0); };

        checkValue { input = "0000-01-01T00:00:00.0000000001"; expected = dateTime(0, 1, 1, 0, 0, 0, 0); };
        checkValue { input = "0000-01-01T00:00:00.0000000009"; expected = dateTime(0, 1, 1, 0, 0, 0, 0); };
    }

    shared test void truncatedTime1()
        =>  assertTrue(parseToml("key = 1999-12-31T23:1") is TomlParseException);

    shared test void truncatedTime2()
        =>  assertTrue(parseToml("key = 1999-12-31T23:") is TomlParseException);

    shared test void truncatedTime3()
        =>  assertTrue(parseToml("key = 1999-12-31T2") is TomlParseException);

    shared void test() {
        simple();
        withMillis();
        truncateMillis();
        truncatedTime1();
        truncatedTime2();
        truncatedTime3();
    }
}
