import java.sql {
    Connection
}

import javax.sql {
    DataSource
}

"Obtain a connection source, that is, an instance of 
 `Connnection()`, for a given JDBC [[dataSource]]."
see (`function newConnectionFromDataSourceWithCredentials`)
shared Connection newConnectionFromDataSource
        (DataSource dataSource)()
        => dataSource.connection;

"Obtain a connection source, that is, an instance of 
 `Connnection()`, for a given JDBC [[dataSource]], and
 given credentials."
see (`function newConnectionFromDataSource`)
shared Connection newConnectionFromDataSourceWithCredentials
        (DataSource dataSource, String user, String pass)()
        => dataSource.getConnection(user, pass);