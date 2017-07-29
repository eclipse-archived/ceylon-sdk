import ceylon.test {
    test
}
import ceylon.time {
    date
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

    shared void test() {
        simple();
    }
}
