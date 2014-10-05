import ceylon.transaction.internal {
    registerDataSource,
    registerDriverInternal=registerDriver
}

"Register a JDBC [[javax.sql::DataSource]] with the 
 transaction infrastructure."
shared void registerDataSourceUrl(
    "The name under which the datasource will be registered."
    String binding,
    "The class name of a [[registered|registerDriver]] 
     JDBC driver."
    String driver,
    "The JDBC URL of the database." 
    String databaseUrl,
    [String, String] userAndPassword)
        => registerDataSource {
            binding = binding;
            driver = driver;
            databaseNameOrUrl = databaseUrl;
            userAndPassword = userAndPassword;
        };

"Register a JDBC [[javax.sql::DataSource]] with the 
 transaction infrastructure."
shared void registerDataSourceName(
    "The name under which the datasource will be registered."
    String binding,
    "The class name of a [[registered|registerDriver]] 
     JDBC driver."
    String driver,
    "The name of the database." 
    String databaseName, 
    "The host name of the database."
    String host, 
    "The port number of the database."
    Integer port,
    [String, String] userAndPassword) 
        => registerDataSource {
            binding = binding;
            driver = driver;
            databaseNameOrUrl = databaseName;
            userAndPassword = userAndPassword;
            host = host;
            port = port;
        };

"Register a JDBC driver with the transaction infrastructure."
shared void registerDriver(
    "The name of the JDBC driver class."
    String driver, 
    "The module that provides the JDBC driver."
    [String,String] moduleAndVersion, 
    "The name of the XA-compliant [[javax.sql::DataSource]]."
    String dataSourceClassName) 
        => registerDriverInternal {
            driver = driver;
            moduleAndVersion = moduleAndVersion;
            dataSourceClassName = dataSourceClassName;
        };