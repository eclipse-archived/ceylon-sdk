import ceylon.test {
    createTestRunner
}

"Run the module `test.ceylon.html`."
shared void run() {
    value result = createTestRunner([`module test.ceylon.html`]).run();
    print(result);
}