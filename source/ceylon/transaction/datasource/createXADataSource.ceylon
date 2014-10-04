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
    RuntimeException,
    ClassLoader
}

import org.jboss.modules {
    DependencySpec {
        createModuleDependencySpec
    },
    Module,
    ModuleLoadException,
    ModuleIdentifier,
    ModuleLoader
}
import org.jboss.modules.filter {
    PathFilters
}

shared Object createXADataSource(String binding, 
    String driver, 
    String databaseNameOrUrl, 
    String? host, Integer? port, 
    [String,String] userAndPassword) {

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
    
    value wrapper = XADSWrapper(binding, driver, databaseNameOrUrl, host, port,
        driverSpec.dataSourceClassName, moduleClassLoader, userAndPassword[0], userAndPassword[1]);
    
    if (driver.equals("org.h2.Driver")) {
        wrapper.setProperty("URL", databaseNameOrUrl);
    } else if(driver.equals("org.hsqldb.jdbcDriver")) {
        wrapper.setProperty("Url", databaseNameOrUrl);
        wrapper.setProperty("User", userAndPassword[0]);
        wrapper.setProperty("Password", userAndPassword[1]);
    } else {
        wrapper.setProperty("databaseName", databaseNameOrUrl);
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
        wrapper.setProperty("URL", databaseNameOrUrl);
    }
    
    return wrapper;
}