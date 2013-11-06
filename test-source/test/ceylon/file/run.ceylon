import ceylon.test { ... }

"Run the module `test.ceylon.file`."
void run() {
    createTestRunner([`module test.ceylon.file`], [SimpleLoggingListener()]).run();
}