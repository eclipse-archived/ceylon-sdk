import ceylon.transaction.tm { TM, getTM }
import java.lang { System { setProperty } }
import javax.sql { DataSource }

import ceylon.test {
    beforeTest,
    afterTest
}

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

shared beforeTest void setup() {
    init();
}

shared afterTest void tearDown() {
	fini();
}
