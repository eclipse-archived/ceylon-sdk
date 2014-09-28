import ceylon.test {
    beforeTest,
    afterTest
}
import ceylon.transaction.tm {
    TransactionManager,
    jndiServer,
    transactionManager
}

import javax.sql {
    DataSource
}

shared TransactionManager tm = transactionManager;

//{String+} dsBindings = { "h2", "postgresql" };
{String+} dsBindings = { "h2" };
{String+} dsBindings2 = { "h2" };

shared DataSource? getXADataSource(String binding) {
    Object? ds = jndiServer.lookup(binding);

    if (is DataSource ds) {
        return ds;
    } else {
        return null;
    }
}

shared beforeTest void setup() {
    init();
}

shared afterTest void tearDown() {
	fini();
}
