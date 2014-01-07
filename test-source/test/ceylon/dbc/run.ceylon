import ceylon.dbc {
    Sql
}
import ceylon.test { beforeTest }

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

shared Sql sql = Sql(createDataSource());

shared beforeTest void setup() {
    //Some setup, with the same component
    try {
    sql.update("CREATE TABLE test1 (row_id SERIAL PRIMARY KEY, name VARCHAR(40), when TIMESTAMP, day DATE, count INTEGER, price NUMERIC(10,4), flag BOOLEAN)");
    } catch (Exception ex) {
        if (!"Table \"TEST1\" already exists" in ex.message) {
            throw ex;
        }
    }
}
