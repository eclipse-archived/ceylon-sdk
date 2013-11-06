import ceylon.test { ... }

"Run the module `test.ceylon.process`."
void run() {
    value result = createTestRunner([`module test.ceylon.process`], [SimpleLoggingListener()]).run();
    print(result);
}