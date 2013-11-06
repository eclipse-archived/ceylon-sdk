import ceylon.test { ... }

void run() {
    createTestRunner([`module test.ceylon.io`], [SimpleLoggingListener()]).run();
}