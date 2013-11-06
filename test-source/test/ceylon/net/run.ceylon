import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

void run() {
    value result = createTestRunner([`module test.ceylon.net`], [SimpleLoggingListener()]).run();
    print(result);
}