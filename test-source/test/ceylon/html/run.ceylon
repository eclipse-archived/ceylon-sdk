import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

"Run the module `test.ceylon.html`."
shared void run() {
    createTestRunner([`module test.ceylon.html`], [SimpleLoggingListener()]).run();
}