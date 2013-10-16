import ceylon.test { ... }

shared void run(){
    value result = createTestRunner([`module test.ceylon.json`]).run();
    print(result);
}