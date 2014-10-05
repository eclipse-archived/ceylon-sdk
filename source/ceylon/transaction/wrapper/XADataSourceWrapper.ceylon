import ceylon.interop.java {
    javaClassFromInstance,
    javaClass
}

import com.arjuna.ats.jdbc {
    TransactionalDriver
}

import java.io {
    PrintWriter,
    Serializable
}
import java.lang {
    ExceptionInInitializerError,
    Class,
    ClassLoader,
    Int=Integer {
        intType=TYPE
    },
    Bool=Boolean {
        boolType=TYPE
    },
    Str=String
}
import java.sql {
    Connection,
    SQLException
}
import java.util {
    Properties
}

import javax.naming {
    Reference,
    Referenceable,
    StringRefAddr
}
import javax.sql {
    DataSource,
    XADataSource
}

by ("Mike Musgrove")
shared class XADataSourceWrapper(binding, 
    driver, 
    databaseNameOrUrl, 
    host, port,
    dataSourceClassName, 
    classLoader, 
    userAndPassword) 
        satisfies XADataSource & Serializable & 
                  Referenceable & DataSource {

    value arjunaJDBC2Driver = TransactionalDriver();
    
    String binding;
    String txDriverUrl;
    Properties properties;
    String dataSourceClassName;
    ClassLoader classLoader;
    XADataSource dataSource;
    String driver;
    String databaseNameOrUrl;
    String? host;
    Integer? port;
    [String,String] userAndPassword;

    try {
        assert (is XADataSource ds 
            = classLoader.loadClass(dataSourceClassName).newInstance());
        dataSource = ds;
        txDriverUrl = TransactionalDriver.arjunaDriver + binding;
        properties = Properties();
        properties.put(TransactionalDriver.userName, userAndPassword[0]);
        properties.put(TransactionalDriver.password, userAndPassword[1]);
        properties.put(TransactionalDriver.createDb, true);
    }
    catch (Exception e) {
        throw ExceptionInInitializerError(e);
    }
    
    getXAConnection(String? user, String? password) 
            => dataSource.getXAConnection(user, password);
    
    xaConnection 
            => getXAConnection(userAndPassword[0], 
                               userAndPassword[1]);

    shared actual PrintWriter logWriter 
            => dataSource.logWriter;
    
    assign logWriter 
            => dataSource.logWriter = logWriter;

    shared actual Integer loginTimeout 
            => dataSource.loginTimeout;
    
    assign loginTimeout 
            => dataSource.loginTimeout = loginTimeout;

    parentLogger => dataSource.parentLogger;

    // DataSource implementation
    connection => arjunaJDBC2Driver.connect(txDriverUrl, properties);

    shared actual Connection getConnection(String u, String p) {
        Properties dbProperties = Properties(properties);
        dbProperties.put(TransactionalDriver.userName, u);
        dbProperties.put(TransactionalDriver.password, p);
        return arjunaJDBC2Driver.connect(txDriverUrl, dbProperties);
    }

    shared actual T unwrap<T>(Class<T> tClass) {
        throw SQLException("Not a wrapper");
    }

    isWrapperFor(Class<out Object>? clazz) => false;

    shared actual Reference reference {
        Reference ref = Reference(javaClassFromInstance(this).name, 
            javaClass<XADataSourceWrapperObjectFactory>().name, null);
        
        ref.add(StringRefAddr("binding", binding));
        ref.add(StringRefAddr("driver", driver));
        ref.add(StringRefAddr("databaseName", databaseNameOrUrl));
        ref.add(StringRefAddr("host", host));
        ref.add(StringRefAddr("port", port?.string));
        
        ref.add(StringRefAddr("username", userAndPassword[0]));
        ref.add(StringRefAddr("password", userAndPassword[1]));
        
        return ref;
    }
    
    shared void setProperties() {
        if (driver.equals("org.h2.Driver")) {
            setProperty("URL", databaseNameOrUrl);
        }
        else if (driver.equals("org.hsqldb.jdbcDriver")) {
            setProperty("Url", databaseNameOrUrl);
            setProperty("User", userAndPassword[0]);
            setProperty("Password", userAndPassword[1]);
        }
        else {
            setProperty("databaseName", databaseNameOrUrl);
            assert (exists host);
            assert (exists port);
            setProperty("serverName", host);
            setProperty("portNumber", port);
        }
        if (driver.equals("oracle.jdbc.driver.OracleDriver")) {
            setProperty("driverType", "thin");
        }
        else if (driver.equals("com.microsoft.sqlserver.jdbc.SQLServerDriver")) {
            setProperty("sendStringParametersAsUnicode", false);
        }
        else if (driver.equals("com.mysql.jdbc.Driver")) {
            
            // Note: MySQL XA only works on InnoDB tables.
            // set 'default-storage-engine=innodb' in e.g. /etc/my.cnf
            // so that the 'CREATE TABLE ...' statments behave correctly.
            // doing this config on a per connection basis instead is
            // possible but would require lots of code changes :-(
            
            setProperty("pinGlobalTxToPhysicalConnection", true); // Bad Things happen if you forget this bit.
        }
        else if (driver.equals("com.ibm.db2.jcc.DB2Driver")) {
            setProperty("driverType", 4);
        }
        else if (driver.equals("org.h2.Driver")) {
            setProperty("URL", databaseNameOrUrl);
        }
    }
    
    void setProperty(String name, Object item) {
        Class<out Object> type;
        Object javaItem;
        if (is String item) {
            type = javaClass<Str>();
            javaItem = Str(item);
        }
        else if (is Integer item) {
            type = intType;
            javaItem = Int.valueOf(item);
        }
        else if (is Boolean item) {
            type = boolType;
            javaItem = Bool.valueOf(item);
        }
        else {
            type = javaClassFromInstance(item);
            javaItem = item;
        }
        String setter = "set" + name[0..0].uppercased + name[1...];
        javaClassFromInstance(dataSource)
                .getMethod(setter, type)
                .invoke(dataSource, javaItem);
    }
    
}
