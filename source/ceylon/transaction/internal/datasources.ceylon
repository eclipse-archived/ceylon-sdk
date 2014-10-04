import ceylon.collection {
    HashSet,
    MutableSet,
    HashMap,
    MutableMap
}
import ceylon.transaction.datasource {
    registerDriver,
    registerDataSourceUrl
}
import ceylon.transaction.internal {
    createXADataSource
}

import com.arjuna.ats.arjuna.logging {
    \ItsLogger {
        logger
    }
}
import com.arjuna.ats.jdbc {
    TransactionalDriver {
        userNameProp=userName,
        passwordProp=password
    }
}

import java.lang {
    System {
        properties
    }
}

import javax.naming {
    InitialContext
}

by ("Mike Musgrove")
void registerDataSource(String binding, 
    String driver, 
    String databaseNameOrUrl,
    [String, String] userAndPassword, 
    String? host=null, Integer? port=null)  {
    
    if (exists driversProp = properties.getProperty("jdbc.drivers")) {
        properties.setProperty("jdbc.drivers", driversProp + ":" + driver);
    }
    else {
        properties.setProperty("jdbc.drivers", driver);
    }
    
    properties.setProperty(userNameProp, userAndPassword[0]);
    properties.setProperty(passwordProp, userAndPassword[1]);
    
    System.properties = properties;

    Object xaDataSourceToBind;
    try {
        xaDataSourceToBind = 
                createXADataSource {
                    binding = binding;
                    driver = driver;
                    databaseNameOrUrl = databaseNameOrUrl;
                    host = host;
                    port = port;
                    userAndPassword = userAndPassword;
                };
    }
    catch (Exception e) {
        value msg = "Cannot bind ``databaseNameOrUrl `` for driver ``driver``";
        if (logger.infoEnabled) {
            logger.info(msg);
        }
        throw Exception(msg, e);
    }

    try {
        InitialContext().rebind(binding, xaDataSourceToBind);
    } 
    catch (Exception e) {
        value msg = "Cannot bind ``databaseNameOrUrl `` to ``binding``: ``e.message``";
        if (logger.infoEnabled) {
            logger.infof(msg);
        }
        throw Exception(msg, e);
    }

    //registerJDBCXARecoveryHelper(binding, userName, password);
}

"Register a JDBC [[javax.sql::DataSource]] with the 
 transaction infrastructure."
shared void registerDataSourceUrlInternal(
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
shared void registerDataSourceNameInternal(
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

MutableSet<String> dsJndiBindings = HashSet<String>();

shared void registerDataSources(String dbConfigFileName = "dbc.properties") {
    value dbConfigs = createConfiguration(dbConfigFileName);
    
    value iter = dbConfigs.values().iterator();
    while (iter.hasNext()) {
        value props = iter.next();
        
        registerDriver {
            driver = props.driver;
            moduleAndVersion = [props.moduleName, 
                                props.moduleVersion];
            dataSourceClassName = props.dataSourceClassName;
        };
        
        if (exists url = props.databaseURL) {
            registerDataSourceUrl {
                binding = props.binding;
                driver = props.driver;
                databaseUrl = url;
                userAndPassword = [props.databaseUser,
                                   props.databasePassword];
            };
        }
        else {
            assert (exists name=props.databaseName, 
                    exists host=props.host,
                    exists port=props.port);
            registerDataSource {
                binding = props.binding;
                driver = props.driver;
                databaseNameOrUrl = name;
                userAndPassword = [props.databaseUser,
                                   props.databasePassword];
                host = host;
                port = port;
            };
        }
        
        dsJndiBindings.add(props.binding);
    }
}

"Register a JDBC driver with the transaction infrastructure."
shared void registerDriverInternal(
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

MutableMap<String,DriverSpec> jdbcDrivers = HashMap<String,DriverSpec>();

class DriverSpec(moduleName, moduleVersion, dataSourceClassName) {
    shared String moduleName;
    shared String moduleVersion;
    shared String dataSourceClassName;
}
