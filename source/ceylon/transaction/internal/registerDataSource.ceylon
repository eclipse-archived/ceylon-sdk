import ceylon.collection {
    HashSet,
    MutableSet
}
import ceylon.transaction.wrapper {
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

"Register a JDBC [[javax.sql::DataSource]] with the 
 transaction infrastructure."
by ("Mike Musgrove")
shared void registerDataSource(String binding, 
    String driver, 
    String databaseNameOrUrl,
    [String, String] userAndPassword, 
    String? host=null, Integer? port=null)  {
    
    if (exists driversProp 
            = properties.getProperty("jdbc.drivers")) {
        properties.setProperty("jdbc.drivers", 
            driversProp + ":" + driver);
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

MutableSet<String> dsJndiBindings = HashSet<String>();


