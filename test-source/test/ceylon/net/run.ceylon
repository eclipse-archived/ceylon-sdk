import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

void run() {
    createTestRunner([`module test.ceylon.net`], [SimpleLoggingListener()]).run();
}