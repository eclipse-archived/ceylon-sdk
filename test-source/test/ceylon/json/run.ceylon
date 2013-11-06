import ceylon.test { ... }

shared void run(){
    createTestRunner([`module test.ceylon.json`], [SimpleLoggingListener()]).run();
}