import ceylon.dbc {
    Sql,
    newConnectionFromDataSource
}
import ceylon.test {
    beforeTest,
    SimpleLoggingListener,
    createTestRunner
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

shared Sql sql = Sql(newConnectionFromDataSource(createDataSource()));

shared beforeTest void setup() {
    try {
        sql.Statement("CREATE TABLE test1 (
                           row_id SERIAL PRIMARY KEY, 
                           name VARCHAR(40), 
                           when TIMESTAMP, 
                           day DATE, 
                           count INTEGER, 
                           price NUMERIC(10,4), 
                           flag BOOLEAN)").execute();
    }
    catch (Exception ex) {
        if (!"Table \"TEST1\" already exists" in ex.message) {
            throw ex;
        }
    }
    sql.Update("DELETE FROM test1").execute();
}

void run() => createTestRunner([`module test.ceylon.dbc`], [SimpleLoggingListener()]).run();
