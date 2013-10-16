import ceylon.test {
    createTestRunner
}

shared void run() {
    value result = createTestRunner([`module test.ceylon.interop.java`]).run();
    print(result);
}
