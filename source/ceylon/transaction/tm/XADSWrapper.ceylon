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
    Referenceable
}
import javax.sql {
    DataSource,
    XADataSource
}

by ("Mike Musgrove")
shared class XADSWrapper(binding, driver, 
    databaseName, 
    host, port,
    xaDSClassName, classLoader, 
    userName, password) 
        satisfies XADataSource & Serializable & Referenceable & DataSource {

    TransactionalDriver arjunaJDBC2Driver = TransactionalDriver();
    
    String binding;
    String txDriverUrl;
    Properties properties;
    String xaDSClassName;
    ClassLoader classLoader;
    XADataSource xaDataSource;
    String driver;
    String databaseName;
    String? host;
    Integer? port;
    String userName;
    String password;

    try {
        assert (is XADataSource ds 
            = classLoader.loadClass(xaDSClassName).newInstance());
        xaDataSource = ds;
        txDriverUrl = TransactionalDriver.arjunaDriver + binding;
        properties = Properties();
        properties.put(TransactionalDriver.userName, userName);
        properties.put(TransactionalDriver.password, password);
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
        javaClassFromInstance(xaDataSource)
                .getMethod(setter, type)
                .invoke(xaDataSource, javaItem);
    }

    getXAConnection(String? user, String? password) 
            => xaDataSource.getXAConnection(user, password);
    
    xaConnection 
            => getXAConnection(userName, password);

    shared actual PrintWriter logWriter 
            => xaDataSource.logWriter;

    assign logWriter 
            => xaDataSource.logWriter = logWriter;

    shared actual Integer loginTimeout 
            => xaDataSource.loginTimeout;
    
    assign loginTimeout 
            => xaDataSource.loginTimeout = loginTimeout;

    parentLogger => xaDataSource.parentLogger;

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
                binding, driver, databaseName, host, port, userName, password);
}
