import ceylon.interop.java {
    javaClassFromInstance,
    javaClass
}
import ceylon.transaction.datasource {
    getReference
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
    Referenceable
}
import javax.sql {
    DataSource,
    XADataSource
}

by ("Mike Musgrove")
class XADSWrapper(binding, 
    driver, 
    databaseName, 
    host, port,
    dataSourceClassName, 
    classLoader, 
    userAndPassword) 
        satisfies XADataSource & Serializable & Referenceable & DataSource {

    TransactionalDriver arjunaJDBC2Driver = TransactionalDriver();
    
    String binding;
    String txDriverUrl;
    Properties properties;
    String dataSourceClassName;
    ClassLoader classLoader;
    XADataSource dataSource;
    String driver;
    String databaseName;
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
    } catch (Exception e) {
        throw ExceptionInInitializerError(e);
    }
    
    shared void setProperty(String name, Object item) {
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

    isWrapperFor(Class<out Object>? aClass) => false;

    shared actual Reference reference 
            => getReference(javaClassFromInstance(this).name,
                binding, driver, databaseName, host, port, 
                userAndPassword[0], userAndPassword[1]);
}
