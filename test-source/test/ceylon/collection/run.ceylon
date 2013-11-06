import ceylon.test { ... }

shared void run() {
    createTestRunner([`module test.ceylon.collection`], [SimpleLoggingListener()]).run();
}