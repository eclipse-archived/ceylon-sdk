import ceylon.transaction.tm { TM, getTM }
import javax.sql { DataSource }

import ceylon.test { createTestRunner, SimpleLoggingListener }

shared TM tm = getTM();

//{String+} dsBindings = { "h2", "postgresql" };
{String+} dsBindings = { "h2" };
{String+} dsBindings2 = { "h2" };

shared DataSource? getXADataSource(String binding) {
    Object? ds = tm.getJndiServer().lookup(binding);

    if (is DataSource ds) {
        return ds;
    } else {
        return null;
    }
}

shared void run() {
    assert (!tm.isTxnActive());
    tm.start();

    tm.getJndiServer().registerDSUrl("h2", "org.h2.Driver", "jdbc:h2:~/ceylondb", "sa", "sa");

    createTestRunner([`module test.ceylon.transaction`], [SimpleLoggingListener()]).run();

	tm.stop();
}
