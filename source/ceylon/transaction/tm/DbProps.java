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
package ceylon.transaction.tm;

import java.io.*;
import java.util.*;

import com.arjuna.common.util.propertyservice.PropertiesFactory;

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
public class DbProps {
    public static final String DB_PREFIXES_NAME = "DB_PREFIXES";

    public final static String MODULE_NAME = "ModuleName";
    public final static String MODULE_VERSION = "ModuleVersion";
    public final static String DS_CLASSNAME = "DataSourceClassName";


    public final static String BINDING = "Binding";
    public final static String DRIVER = "Driver";
    public final static String DATABASE_URL = "DatabaseURL";
    public final static String DATABASE_NAME = "DatabaseName";
    public final static String HOST = "Host";
    public final static String PORT = "Port";
    public final static String DATABASE_USER = "DatabaseUser";
    public final static String DATABASE_PASSWORD = "DatabasePassword";

    private String moduleName;
    private String moduleVersion;
    private String dataSourceClassName;

    private String binding;
    private String driver;
    private String databaseURL;
    private String databaseName;
    private String host;
    private int port;
    private String databaseUser;
    private String databasePassword;

    public DbProps() {}

    private DbProps(String prefix, String binding, String moduleName, String moduleVersion, String dataSourceClassName,
                   String driver, String databaseURL, String databaseName,
                   String host, String portName, String databaseUser, String databasePassword) {
        this.binding = binding;
        this.moduleName = moduleName;
        this.moduleVersion = moduleVersion;
        this.dataSourceClassName = dataSourceClassName;
        this.driver = driver;
        this.databaseURL = databaseURL;
        this.databaseName = databaseName;
        this.host = host;
        this.port = 0;
        this.databaseUser = databaseUser;
        this.databasePassword = databasePassword;

        if (moduleName == null || moduleVersion == null  || dataSourceClassName == null)
            throw new IllegalArgumentException("Dbconfig group " + prefix + ": missing module data (moduleName, moduleVersion and DS ClassName) for binding " + binding);

        if (binding == null || driver == null || databaseUser == null || databasePassword == null)
            throw new IllegalArgumentException("Dbconfig group " + prefix + ": missing database properties for binding " + binding);

        if (databaseURL == null && (databaseName == null || host == null || portName == null))
            throw new IllegalArgumentException("Dbconfig group " + prefix + ": missing database URL or (databaseName, host and port) for binding " + binding);

        if (portName != null) {
            try {
                port = Integer.parseInt(portName);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Dbconfig group " + prefix + ": Invalid port number for binding " + binding);
            }
        }
    }

    public String getModuleName() {
        return moduleName;
    }

    public String getModuleVersion() {
        return moduleVersion;
    }

    public String getDataSourceClassName() {
        return dataSourceClassName;
    }

    public String getBinding() {
        return binding;
    }

    public String getDriver() {
        return driver;
    }

    public String getDatabaseURL() {
        return databaseURL;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public String getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }

    public String getDatabaseUser() {
        return databaseUser;
    }

    public String getDatabasePassword() {
        return databasePassword;
    }

    private Properties loadProperties(String fileName) throws IOException {
        File file = new File(fileName);
        Properties p = new Properties();

        if (!file.exists())
            file.createNewFile();

        InputStream is = new FileInputStream(file);

        p.load(is);
        is.close();

        return p;
    }

    public Map<String, DbProps> getConfig(String fileName) {
        Properties props;
        Map<String, DbProps> dbConfigs = new HashMap<String, DbProps>();

        try {
            props = fileName == null ? new Properties() : loadProperties(fileName);
            //props = PropertiesFactory.getPropertiesFromFile(fileName, this.getClass().getClassLoader());
        } catch (Exception e) {
            System.err.printf("%s (you can set the location via a system property: dbc.properties=<file>%n",
                e.getMessage());
            if (e.getMessage().contains("missing property file"))
                return dbConfigs;

            throw new RuntimeException(e);
        }

        //props.list(System.out);
        String dbProp = props.getProperty(DB_PREFIXES_NAME);

        if (dbProp == null || dbProp.length() == 0)
            return dbConfigs;

        for (String prefix : dbProp.split(",")) {
            prefix = prefix.trim();
            String binding = props.getProperty(prefix + '_' + BINDING);
            dbConfigs.put(binding, new DbProps(prefix, binding,
                    props.getProperty(prefix + '_' + MODULE_NAME),
                    props.getProperty(prefix + '_' + MODULE_VERSION),
                    props.getProperty(prefix + '_' + DS_CLASSNAME),

                    props.getProperty(prefix + '_' + DRIVER),
                    props.getProperty(prefix + '_' + DATABASE_URL),
                    props.getProperty(prefix + '_' + DATABASE_NAME),
                    props.getProperty(prefix + '_' + HOST),
                    props.getProperty(prefix + '_' + PORT),
                    props.getProperty(prefix + '_' + DATABASE_USER),
                    props.getProperty(prefix + '_' + DATABASE_PASSWORD))
            );
        }

        return dbConfigs;
    }
}
