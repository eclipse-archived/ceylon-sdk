import ceylon.test {
    createTestRunner, SimpleLoggingListener
}

"Run the module `test.ceylon.html`."
shared void run() {
    value result = createTestRunner([`module test.ceylon.html`], [SimpleLoggingListener()]).run();
    print(result);
}