import ceylon.dbc {
    Sql,
    newConnectionFromDatasource
}
import ceylon.test {
    createTestRunner,
    SimpleLoggingListener
}

import org.h2.jdbcx {
    JdbcDataSource
}

JdbcDataSource createDataSource() {
    value ds = JdbcDataSource();
    ds.url="jdbc:h2:~/test";
    ds.user="sa";
    ds.password="sa";
    return ds;
}

shared Sql sql = Sql(newConnectionFromDatasource(createDataSource()));

shared void run() {
    //Some setup, with the same component
    try {
        sql.Statement("CREATE TABLE test1 (row_id SERIAL PRIMARY KEY, name VARCHAR(40), when TIMESTAMP, day DATE, count INTEGER, price NUMERIC(10,4), flag BOOLEAN)")
                .execute();
    } catch (Exception ex) {
        if (!"Table \"TEST1\" already exists" in ex.message) {
            throw ex;
        }
    }
    
    createTestRunner([`module test.ceylon.dbc`], [SimpleLoggingListener()]).run();
}