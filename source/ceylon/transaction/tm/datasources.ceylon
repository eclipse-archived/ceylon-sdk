/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2013, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General shared License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General shared License for more details.
 *
 * You should have received a copy of the GNU Lesser General shared
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
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
    HashSet,
    Set
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

    registerJDBCXARecoveryHelper(binding, userName, password);
}

shared void bindDataSources(String dbConfigFileName="dbc.properties")
        => registerDatasourceJndiBindings(dbConfigFileName);

shared  void registerDSUrl(String binding, String driver, 
    String databaseUrl,
    String userName, String password) 
        => registerDataSource(binding, driver, 
        databaseUrl, 
        userName, password);

shared  void registerDSName(String binding, String driver, 
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
