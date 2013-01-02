import ceylon.test {suite}

shared void run() {
    suite("ceylon.math",
        "Whole" -> wholeTests,
        "Decimal" -> decimalTests,
        "Float" -> floatTests,
        "Integer" -> intTests);
}