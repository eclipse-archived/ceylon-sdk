import ceylon.test { ... }

"Run the module `test.ceylon.file`."
void run() {
    value result = createTestRunner([`module test.ceylon.file`], [SimpleLoggingListener()]).run();
    print(result);
}