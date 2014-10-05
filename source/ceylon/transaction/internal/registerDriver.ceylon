import ceylon.collection {
    MutableMap,
    HashMap
}
import ceylon.transaction.internal {
    supportedDrivers
}
"Register a JDBC driver with the transaction infrastructure."
shared void registerDriver(
    "The name of the JDBC driver class."
    String driver, 
    "The module that provides the JDBC driver."
    [String,String] moduleAndVersion, 
    "The name of the XA-compliant [[javax.sql::DataSource]]."
    String dataSourceClassName) {
    if (!driver in supportedDrivers) {
        process.writeError("Warning: ``driver`` is an unsupported driver");
    }
    jdbcDrivers.put(driver, 
        DriverSpec {
            moduleName = moduleAndVersion[0];
            moduleVersion = moduleAndVersion[1];
            dataSourceClassName = dataSourceClassName;
        });
}

shared class DriverSpec(moduleName, moduleVersion, dataSourceClassName) {
    shared String moduleName;
    shared String moduleVersion;
    shared String dataSourceClassName;
}

shared DriverSpec? getDriverSpec(String driver) => jdbcDrivers[driver];

MutableMap<String,DriverSpec> jdbcDrivers = HashMap<String,DriverSpec>();
