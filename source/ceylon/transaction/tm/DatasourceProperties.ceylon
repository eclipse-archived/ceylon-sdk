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

by ("Mike Musgrove")
shared class DatasourceProperties(prefix, binding, 
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

shared Map<String,DatasourceProperties> createConfig(String? fileName) {
    Properties props;
    value dbConfigs = HashMap<String,DatasourceProperties>();
    
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
            return dbConfigs;
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
            dbConfigs.put(binding, 
                DatasourceProperties(trimmed, binding,
                    moduleName, moduleVersion, className, driver,
                    url, name, host, port, user, pass));
        }
    }
    else {
        return dbConfigs;
    }
    
    
    return dbConfigs;
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
