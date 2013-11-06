import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

shared void run() {
    value result = createTestRunner([`module test.ceylon.math`], [SimpleLoggingListener()]).run();
    print(result);
}