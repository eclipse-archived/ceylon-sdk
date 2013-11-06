import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

shared void run() {
    createTestRunner([`module test.ceylon.math`], [SimpleLoggingListener()]).run();
}