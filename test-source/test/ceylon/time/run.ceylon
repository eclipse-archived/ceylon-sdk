import ceylon.test { createTestRunner, SimpleLoggingListener }

"Run all ceylon.time module tests"
shared void run(){
    createTestRunner([`module test.ceylon.time`], [SimpleLoggingListener()]).run();
}