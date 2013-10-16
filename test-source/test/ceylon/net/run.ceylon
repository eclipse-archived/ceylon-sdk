import ceylon.test {
    createTestRunner
}

void run() {
    value result = createTestRunner([`module test.ceylon.net`]).run();
    print(result);
}