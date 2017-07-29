import ceylon.test {
    test
}
import ceylon.time {
    time
}

shared object times {
    // TODO error conditions

    shared test void simpleTimes() {
        checkValue { input = "00:00:00"; expected = time(00, 00, 00); };
        checkValue { input = "23:59:59"; expected = time(23, 59, 59); };
        checkValue { input = "10:10:00"; expected = time(10, 10, 00); };
    }

    shared test void timesWithMillis() {
        checkValue { input = "10:10:00.1"; expected = time(10, 10, 00, 100); };
        checkValue { input = "10:10:00.01"; expected = time(10, 10, 00, 10); };
        checkValue { input = "10:10:00.001"; expected = time(10, 10, 00, 1); };
        checkValue { input = "10:10:00.0001"; expected = time(10, 10, 00, 0); };

        checkValue { input = "10:10:00.9"; expected = time(10, 10, 00, 900); };
        checkValue { input = "10:10:00.09"; expected = time(10, 10, 00, 90); };
        checkValue { input = "10:10:00.009"; expected = time(10, 10, 00, 9); };
        checkValue { input = "10:10:00.0009"; expected = time(10, 10, 00, 0); };

        checkValue { input = "10:10:00.999"; expected = time(10, 10, 00, 999); };
        checkValue { input = "10:10:00.9999"; expected = time(10, 10, 00, 999); };
        checkValue { input = "10:10:00.999999999999"; expected = time(10, 10, 00, 999); };

        checkValue { input = "10:10:00.123"; expected = time(10, 10, 00, 123); };
        checkValue { input = "10:10:00.789"; expected = time(10, 10, 00, 789); };
    }

    shared void test() {
        simpleTimes();
        timesWithMillis();
    }
}
