import java.io {
    FileInputStream,
    InputStream,
    File
}
import java.lang {
    System,
    RuntimeException
}
import java.util {
    Map,
    Properties,
    HashMap
}

by ("Mike Musgrove")
class DatasourceProperties(prefix, binding, 
    moduleName, moduleVersion, 
    dataSourceClassName,
    driver, 
    databaseURL, databaseName,
    host, portName, 
    databaseUser, databasePassword) {
    
    shared String prefix;
    shared String binding;
    
    shared String moduleName;
    shared String moduleVersion;    
    shared String dataSourceClassName;
    shared String driver;
    shared String databasePassword;
    shared String databaseUser;
    
    shared String? databaseURL;
    shared String? databaseName;
    shared String? host;
    shared String? portName;
    shared Integer? port;
    
    if (exists databaseURL) {
        assert (!databaseURL.empty);
    }
    
    assert (databaseURL exists || 
        (databaseName exists && host exists && portName exists));
            
    if (exists portName) {
        port = parseInteger(portName);
    }
    else {
        port = null;
    }

}

Map<String,DatasourceProperties> createConfiguration(String? fileName) {
    
    value configurations = HashMap<String,DatasourceProperties>();
    
    Properties props;
    try {
        if (exists fileName) {
            props = loadProperties(fileName);
        }
        else {
            props = Properties();
        }
        //props = PropertiesFactory.getPropertiesFromFile(fileName, this.getClass().getClassLoader());
    }
    catch (Exception e) {
        System.err.printf(
            "%s (you can set the location via a system property: dbc.properties=<file>%n",
            e.message);
        if (e.message.contains("missing property file")) {
            return configurations;
        }
        throw RuntimeException(e);
    }
    
    if (exists dbProp = props.getProperty("DB_PREFIXES")) {
        for (prefix in dbProp.split(','.equals, true, false)) {
            String trimmed = prefix.trimmed;
            String binding = props.getProperty(trimmed + "_" + "Binding");
            assert (exists moduleName = props.getProperty(trimmed + "_" + "ModuleName"));
            assert (exists moduleVersion = props.getProperty(trimmed + "_" + "ModuleVersion"));
            assert (exists className = props.getProperty(trimmed + "_" + "DataSourceClassName"));
            assert (exists driver = props.getProperty(trimmed + "_" + "Driver"));
            assert (exists user = props.getProperty(trimmed + "_" + "DatabaseUser"));
            assert (exists pass = props.getProperty(trimmed + "_" + "DatabasePassword"));
            String? url = props.getProperty(trimmed + "_" + "DatabaseURL");
            String? name = props.getProperty(trimmed + "_" + "DatabaseName");
            String? host = props.getProperty(trimmed + "_" + "Host");
            String? port = props.getProperty(trimmed + "_" + "Port");
            configurations.put(binding, 
                DatasourceProperties(trimmed, binding,
                    moduleName, moduleVersion, className, driver,
                    url, name, host, port, user, pass));
        }
    }
    else {
        return configurations;
    }
    
    
    return configurations;
}

Properties loadProperties(String fileName) {
    File file = File(fileName);
    Properties p = Properties();
    if (!file.\iexists()) {
        file.createNewFile();
    }
    InputStream stream = FileInputStream(file);
    p.load(stream);
    stream.close();
    return p;
}
