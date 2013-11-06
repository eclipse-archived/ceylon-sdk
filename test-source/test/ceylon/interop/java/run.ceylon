import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

shared void run() {
    createTestRunner([`module test.ceylon.interop.java`], [SimpleLoggingListener()]).run();
}
