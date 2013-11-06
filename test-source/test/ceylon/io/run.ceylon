import ceylon.test { ... }

void run() {
    value result = createTestRunner([`module test.ceylon.io`], [SimpleLoggingListener()]).run();
    print(result);
}