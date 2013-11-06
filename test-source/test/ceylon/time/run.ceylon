import ceylon.test { createTestRunner, SimpleLoggingListener }

"Run all ceylon.time module tests"
shared void run(){
    value result = createTestRunner([`module test.ceylon.time`], [SimpleLoggingListener()]).run();
    print(result);
}