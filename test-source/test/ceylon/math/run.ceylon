import ceylon.test {
    createTestRunner
}

shared void run() {
    value result = createTestRunner([`module test.ceylon.math`]).run();
    print(result);
}