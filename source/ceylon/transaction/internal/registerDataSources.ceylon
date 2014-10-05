import ceylon.transaction.internal {
    registerDriver,
    createConfiguration,
    registerDataSource,
    dsJndiBindings
}

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
            registerDataSource {
                binding = props.binding;
                driver = props.driver;
                databaseNameOrUrl = url;
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