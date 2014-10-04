import ceylon.test {
    beforeTest,
    afterTest
}
import ceylon.transaction {
    TransactionManager,
    transactionManager
}

import javax.naming {
    InitialContext
}
import javax.sql {
    DataSource
}

TransactionManager tm = transactionManager;

//{String+} dsBindings = { "h2", "postgresql" };
{String+} dsBindings = { "h2" };
{String+} dsBindings2 = { "h2" };

DataSource? getXADataSource(String binding) {
    if (is DataSource ds = InitialContext().lookup(binding)) {
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
