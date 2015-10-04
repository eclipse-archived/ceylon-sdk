import java.sql {
    Connection
}

import javax.sql {
    DataSource,
    XADataSource
}

import ceylon.transaction {
    transactionManager
}

"Obtain a connection source, that is, an instance of 
 `Connection()`, for a given JDBC [[dataSource]]."
see (`function newConnectionFromDataSourceWithCredentials`)
shared Connection newConnectionFromDataSource
        (DataSource dataSource)()
        => dataSource.connection;

"Obtain a connection source, that is, an instance of 
 `Connection()`, for a given JDBC [[dataSource]], and
 given credentials."
see (`function newConnectionFromDataSource`)
shared Connection newConnectionFromDataSourceWithCredentials
        (DataSource dataSource, String user, String pass)()
        => dataSource.getConnection(user, pass);

"Obtain a XA connection source, that is, an instance of 
 `Connection()`, for a given JDBC XA [[dataSource]]."
see (`function newConnectionFromXADataSource`)
shared Connection newConnectionFromXADataSource
        (XADataSource dataSource)()
        => transactionManager.newConnectionFromXADataSource(dataSource);

"Obtain a connection source, that is, an instance of 
 `Connection()`, for a given JDBC XA [[dataSource]], and
 given credentials."
see (`function newConnectionFromDataSource`)
shared Connection newConnectionFromXADataSourceWithCredentials
        (XADataSource dataSource, String user, String pass)()
        => transactionManager.newConnectionFromXADataSourceWithCredentials(dataSource, [user, pass]);

