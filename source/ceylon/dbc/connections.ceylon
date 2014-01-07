import java.sql {
    Connection
}

import javax.sql {
    DataSource
}

"Obtain a connection source, that is, an instance of 
 `Connnection()`, for a given JDBC [[dataSource]]."
shared Connection newConnectionFromDatasource
        (DataSource dataSource)()
        => dataSource.connection;

"Obtain a connection source, that is, an instance of 
 `Connnection()`, for a given JDBC [[dataSource]], and
 given credentials."
shared Connection newConnectionFromDatasourceWithCredentials
        (DataSource dataSource, String user, String pass)()
        => dataSource.getConnection(user, pass);