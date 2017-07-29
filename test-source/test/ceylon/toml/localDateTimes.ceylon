import ceylon.test {
    test
}
import ceylon.time {
    dateTime
}

shared object localDateTimes {
    // TODO error conditions

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

    shared void test() {
        simple();
        withMillis();
    }
}
