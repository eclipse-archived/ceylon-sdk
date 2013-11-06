import ceylon.test { ... }

"Run the module `test.ceylon.process`."
void run() {
    createTestRunner([`module test.ceylon.process`], [SimpleLoggingListener()]).run();
}