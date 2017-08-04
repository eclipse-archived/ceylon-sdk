import ceylon.test {
    test, assertTrue
}
import ceylon.time {
    time
}
import ceylon.toml {
    parseToml, TomlParseException
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

    shared test void truncatedTime1()
        =>  assertTrue(parseToml("key = 07:32:00.") is TomlParseException);

    shared test void truncatedTime2()
        =>  assertTrue(parseToml("key = 07:32:0") is TomlParseException);

    shared test void truncatedTime3()
        =>  assertTrue(parseToml("key = 07:32:") is TomlParseException);

    shared test void truncatedTime4()
        =>  assertTrue(parseToml("key = 07:32") is TomlParseException);

    shared test void truncatedTime5()
        =>  assertTrue(parseToml("key = 07:3") is TomlParseException);

    shared test void truncatedTime6()
        =>  assertTrue(parseToml("key = 07:") is TomlParseException);

    shared void test() {
        simpleTimes();
        timesWithMillis();
        truncatedTime1();
        truncatedTime2();
        truncatedTime3();
        truncatedTime4();
        truncatedTime5();
        truncatedTime6();
    }
}
