import ceylon.test { ... }

shared void run() {
    value result = createTestRunner([`module test.ceylon.collection`]).run();
    print(result);
}