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
import java.util {
    HashMap,
    Map,
    Set,
    HashSet
}

import javax.naming {
    InitialContext
}

by ("Mike Musgrove")
shared void registerDataSource(String binding, String driver, 
                               String databaseName,
                               String userName, String password, 
                               String? host=null, Integer? port=null)  {
    
    if (exists driversProp = properties.getProperty("jdbc.drivers")) {
        properties.setProperty("jdbc.drivers", driversProp + ":" + driver);
    }
    else {
        properties.setProperty("jdbc.drivers", driver);
    }
    
    properties.setProperty(userNameProp, userName);
    properties.setProperty(passwordProp, password);
    
    System.properties = properties;

    Object xaDataSourceToBind;
    try {
        xaDataSourceToBind = 
                createXADataSource(binding, driver, 
                    databaseName, host, port, 
                    userName, password);
    }
    catch (Exception e) {
        if (logger.infoEnabled) {
            logger.info("Cannot bind " + 
                databaseName + " for driver " + driver);
        }
        throw Exception("Cannot bind " + 
            databaseName + " for driver " + driver, e);
    }

    try {
        InitialContext().rebind(binding, xaDataSourceToBind);
    } 
    catch (Exception e) {
        if (logger.infoEnabled) {
            logger.infof(
                "%s: Cannot bind datasource into JNDI: %s", 
                binding, e.message);
        }
        throw Exception(binding + 
            ": Cannot bind datasource into JNDI", e);
    }

    //registerJDBCXARecoveryHelper(binding, userName, password);
}

shared void bindDataSources(String dbConfigFileName="dbc.properties")
        => registerDatasourceJndiBindings(dbConfigFileName);

shared void registerDSUrl(String binding, String driver, 
    String databaseUrl,
    String userName, String password) 
        => registerDataSource(binding, driver, 
        databaseUrl, 
        userName, password);

shared void registerDSName(String binding, String driver, 
    String databaseName, 
    String host, Integer port,
    String userName, String password) 
        => registerDataSource(binding, driver, 
        databaseName, 
        userName, password, 
        host, port);

Set<String> dsJndiBindings = HashSet<String>();

void registerDatasourceJndiBindings(String dbConfigFileName) {
    value dbConfigs = createConfig(dbConfigFileName);
    
    value iter = dbConfigs.values().iterator();
    while (iter.hasNext()) {
        value props = iter.next();
        
        registerDriverSpec(props.driver, props.moduleName,
            props.moduleVersion, props.dataSourceClassName);
        
        if (exists url = props.databaseURL) {
            registerDSUrl(props.binding, props.driver, url,
                props.databaseUser, props.databasePassword);
        }
        else {
            assert (exists name=props.databaseName, 
                    exists host=props.host, 
                    exists port=props.port);
            registerDataSource(props.binding, props.driver, name,
                props.databaseUser, props.databasePassword, host, port);
        }
        dsJndiBindings.add(props.binding);
    }
}

shared void registerDriverSpec(String driverClassName, 
    String moduleName, String moduleVersion,
    String dataSourceClassName) {
    if (!driverClassName in supportedDrivers) {
        System.err.printf("Warning, " + driverClassName + " is an unsupported driver%n");
        //throw new IllegalArgumentException("Unsupported driver: " + driverClassName);
    }
    jdbcDrivers.put(driverClassName, 
        DriverSpec(moduleName, moduleVersion, 
            dataSourceClassName));
}

Map<String,DriverSpec> jdbcDrivers = 
        HashMap<String, DriverSpec>();

class DriverSpec(moduleName, moduleVersion, dataSource) {
    shared String moduleName;
    shared String moduleVersion;
    shared String dataSource;
}



