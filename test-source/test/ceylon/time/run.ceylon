import ceylon.test { createTestRunner }

"Run all ceylon.time module tests"
shared void run(){
    value result = createTestRunner([`module test.ceylon.time`]).run();
    print(result);
}