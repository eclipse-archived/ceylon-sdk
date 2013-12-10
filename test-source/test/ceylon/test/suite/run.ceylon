import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}

void run() {
    foo(); // XXX workaround: metamodel is not initialized
    createTestRunner([`module test.ceylon.test.suite`], [SimpleLoggingListener()]).run();
}