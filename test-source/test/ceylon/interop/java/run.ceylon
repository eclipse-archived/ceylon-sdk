import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

shared void run() {
    value result = createTestRunner([`module test.ceylon.interop.java`], [SimpleLoggingListener()]).run();
    print(result);
}
