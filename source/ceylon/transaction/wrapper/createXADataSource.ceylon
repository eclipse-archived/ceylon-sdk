import ceylon.interop.java {
    javaClass
}
import ceylon.modules.jboss.runtime {
    CeylonModuleLoader
}
import ceylon.transaction.internal {
    getDriverSpec
}

import com.arjuna.ats.arjuna.common {
    RecoveryEnvironmentBean
}

import java.lang {
    RuntimeException,
    ClassLoader
}

import org.jboss.modules {
    DependencySpec,
    Module,
    ModuleLoadException,
    ModuleIdentifier,
    ModuleLoader
}
import org.jboss.modules.filter {
    PathFilters
}

shared XADataSourceWrapper createXADataSource(String binding, 
    String driver, 
    String databaseNameOrUrl, 
    String? host, Integer? port, 
    [String,String] userAndPassword) {

    assert (exists driverSpec = getDriverSpec(driver) 
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
    }
    catch(ModuleLoadException x) {
        throw RuntimeException("Failed to load module for driver " + driver, x);
    }
    
    // register ceylon.transaction in narnia
    ModuleLoader moduleLoader = Module.callerModuleLoader;
    if (is CeylonModuleLoader moduleLoader) {
        Module transactionModule = Module.callerModule;
        Module narniaModule = Module.forClass(javaClass<RecoveryEnvironmentBean>());
        DependencySpec dependency = 
                DependencySpec.createModuleDependencySpec(
                    PathFilters.acceptAll(),
                    PathFilters.rejectAll(),
                    moduleLoader,
                    transactionModule.identifier,
                    true);
        
        try {
            moduleLoader.updateModule(narniaModule, dependency);
        }
        catch (ModuleLoadException e) {
            throw RuntimeException("Failed to add ceylon.transaction dependency to narnia", e);
        }
    }
    
    value wrapper = XADataSourceWrapper {
        binding = binding;
        driver = driver;
        databaseNameOrUrl = databaseNameOrUrl;
        host = host;
        port = port;
        dataSourceClassName = driverSpec.dataSourceClassName;
        classLoader = moduleClassLoader;
        userAndPassword = userAndPassword;
    };
    
    wrapper.setProperties();
    
    return wrapper;
}