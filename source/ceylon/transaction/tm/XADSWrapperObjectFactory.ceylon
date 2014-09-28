/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2013, Red Hat, Inc., and individual contributors
 * as indicated by the @author tags. See the copyright.txt file in the
 * distribution for a full listing of individual contributors.
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
import ceylon.interop.java {
    javaClass
}
import ceylon.modules.jboss.runtime {
    CeylonModuleLoader
}

import com.arjuna.ats.arjuna.common {
    RecoveryEnvironmentBean
}

import java.lang {
    System,
    ClassLoader,
    RuntimeException
}
import java.util {
    HashMap,
    Hashtable,
    Map
}

import javax.naming {
    ...
}
import javax.naming.spi {
    ObjectFactory
}

import org.jboss.modules {
    DependencySpec {
        createModuleDependencySpec
    },
    Module,
    ModuleIdentifier,
    ModuleLoadException,
    ModuleLoader
}
import org.jboss.modules.filter {
    PathFilters
}


class DriverSpec(moduleName, moduleVersion, dataSource) {
    shared String moduleName;
    shared String moduleVersion;
    shared String dataSource;
}

Map<String,DriverSpec> jdbcDrivers = 
        HashMap<String, DriverSpec>();

{String*} supportedDrivers = {
    "org.postgresql.Driver",
    //"org.h2.Driver",
    "oracle.jdbc.driver.OracleDriver",
    "com.microsoft.sqlserver.jdbc.SQLServerDriver",
    "com.mysql.jdbc.Driver",
    "com.ibm.db2.jcc.DB2Driver",
    "com.sybase.jdbc3.jdbc.SybDriver" };

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

shared Reference getReference(String className, String binding,
    String driver, String databaseName,
    String? host, Integer? port,
    String userName, String password) {
    
    Reference ref = Reference(className, 
        javaClass<XADSWrapperObjectFactory>().name, null);
    
    ref.add(StringRefAddr("binding", binding));
    ref.add(StringRefAddr("driver", driver));
    ref.add(StringRefAddr("databaseName", databaseName));
    ref.add(StringRefAddr("host", host));
    ref.add(StringRefAddr("port", port?.string));
    
    ref.add(StringRefAddr("username", userName));
    ref.add(StringRefAddr("password", password));
    
    return ref;
}

shared Object createXADataSource(String binding, String driver, 
    String databaseName, 
    String? host, Integer? port, 
    String userName, String password) {
    XADSWrapper wrapper;
    assert (exists driverSpec = jdbcDrivers.get(driver) 
        /*exists ds = driverSpec.dataSource, 
        exists mn = driverSpec.moduleName*/);
    
    // load the driver module
    ModuleIdentifier moduleIdentifier 
            = ModuleIdentifier.create(driverSpec.moduleName, 
                        driverSpec.moduleVersion);
    ClassLoader moduleClassLoader;
    try{
        Module m = Module.callerModuleLoader.loadModule(moduleIdentifier);
        moduleClassLoader = m.classLoader;
    }catch(ModuleLoadException x){
        throw RuntimeException("Failed to load module for driver " + driver, x);
    }
    
    // register ceylon.transaction in narnia
    ModuleLoader moduleLoader = Module.callerModuleLoader;
    if (is CeylonModuleLoader moduleLoader) {
        Module transactionModule = Module.callerModule;
        Module narniaModule = Module.forClass(javaClass<RecoveryEnvironmentBean>());
        DependencySpec dependency = 
                createModuleDependencySpec(
            PathFilters.acceptAll(),
            PathFilters.rejectAll(),
            moduleLoader,
            transactionModule.identifier,
            true);
        
        try {
            moduleLoader.updateModule(narniaModule, dependency);
        } catch (ModuleLoadException e) {
            throw RuntimeException("Failed to add ceylon.transaction dependency to narnia", e);
        }
    }
    
    wrapper = XADSWrapper(binding, driver, databaseName, host, port,
        driverSpec.dataSource, moduleClassLoader, userName, password);
    
    if (driver.equals("org.h2.Driver")) {
        wrapper.setProperty("URL", databaseName);
    } else if(driver.equals("org.hsqldb.jdbcDriver")) {
        wrapper.setProperty("Url", databaseName);
        wrapper.setProperty("User", userName);
        wrapper.setProperty("Password", password);
    } else {
        wrapper.setProperty("databaseName", databaseName);
        assert (exists host);
        assert (exists port);
        wrapper.setProperty("serverName", host);
        wrapper.setProperty("portNumber", port);
    }
    
    if (driver.equals("oracle.jdbc.driver.OracleDriver")) {
        wrapper.setProperty("driverType", "thin");
    } else if( driver.equals("com.microsoft.sqlserver.jdbc.SQLServerDriver")) {
        wrapper.setProperty("sendStringParametersAsUnicode", false);
    } else if( driver.equals("com.mysql.jdbc.Driver")) {
        
        // Note: MySQL XA only works on InnoDB tables.
        // set 'default-storage-engine=innodb' in e.g. /etc/my.cnf
        // so that the 'CREATE TABLE ...' statments behave correctly.
        // doing this config on a per connection basis instead is
        // possible but would require lots of code changes :-(
        
        wrapper.setProperty("pinGlobalTxToPhysicalConnection", true); // Bad Things happen if you forget this bit.
    } else if( driver.equals("com.ibm.db2.jcc.DB2Driver")) {
        wrapper.setProperty("driverType", 4);
    } else if( driver.equals("org.h2.Driver")) {
        wrapper.setProperty("URL", databaseName);
    }
    
    return wrapper;
}

String? getStringProperty(Reference ref, String propName) 
        => ref.get(propName)?.content?.string;

Integer? getIntegerProperty(Reference ref, String propName, Integer defValue) {
    if (exists addr = ref.get(propName), 
        exists content = addr.content) {
        return parseInteger(content.string);
    }
    else {
        return defValue;
    }
}

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
shared class XADSWrapperObjectFactory() satisfies ObjectFactory {
    shared actual Object getObjectInstance(Object ref, Name name, 
            Context nameCtx, 
            Hashtable<out Object,out Object> environment) {
        assert (is Reference ref);
        assert (exists binding = getStringProperty(ref, "binding"));
        assert (exists driver = getStringProperty(ref, "driver"));
        assert (exists database = getStringProperty(ref, "databaseName"));
        value host = getStringProperty(ref, "host");
        value port = getIntegerProperty(ref, "port", 0);
        assert (exists user = getStringProperty(ref, "username"));
        assert (exists pass = getStringProperty(ref, "password"));
        return createXADataSource(binding, driver, database,
                host, port, user, pass);
    }
}
