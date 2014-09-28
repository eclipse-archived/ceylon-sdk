import ceylon.interop.java {
    javaClassFromInstance
}

import java.lang {
    System {
        setProperty
    },
    Thread {
        currentThread
    },
    Runtime {
        jRuntime=runtime
    },
    Runnable,
    Class,
    ClassLoader
}

import javax.naming {
    InitialContext,
    NamingException
}

import org.jnp.server {
    Main,
    NamingBeanImpl
}

"Starts a JNDI server"
by("Mike Musgrove")
shared class JndiServer(bindAddress = "localhost", port = 1099) {
    
    Integer port;
    String bindAddress;
    
    Main jndiServer = Main();
    NamingBeanImpl namingBean = NamingBeanImpl();
    variable Boolean running = false;
    object shutdownHook satisfies Runnable {
        run() => stop();
    }

    shared void start() {
        setProperty("java.naming.factory.initial", 
            "org.jnp.interfaces.NamingContextFactory");
        setProperty("java.naming.factory.url.pkgs", 
            "org.jboss.naming:org.jnp.interfaces");

        Class<out Object> nbClazz = javaClassFromInstance(namingBean);
        Class<out Object> mClazz = javaClassFromInstance(jndiServer);
        ClassLoader cl = nbClazz.classLoader;
        ClassLoader prevCl = currentThread().contextClassLoader;

        try {
            currentThread().contextClassLoader = cl;
            jndiServer.namingInfo = namingBean;
            jndiServer.port = port;
            jndiServer.bindAddress = bindAddress;
            //jndiServer.rmiPort = 1098;
            //jndiServer.rmiBindAddress = "localhost";

            namingBean.start();
            //jndiServer.start();
            running = true;
            Thread shutdownThread = Thread(shutdownHook, "Shutdown thread");
            shutdownThread.daemon = false;
            jRuntime.addShutdownHook(shutdownThread);

        } finally {
            currentThread().contextClassLoader = prevCl;
        }
    }

    void stop() {
        if (running) {
            //jndiServer.stop();
            namingBean.stop();
        }
    }

    shared Object? lookup(String name) {
        try {
            return InitialContext().lookup(name);
        }
        catch (NamingException e) {
            return null;
        }
    }
    
    shared
    void registerDriverSpec(String driverClassName,
        String moduleName, String moduleVersion, 
        String dataSourceClassName) 
            => package.registerDriverSpec(driverClassName, 
                    moduleName, moduleVersion, 
                    dataSourceClassName);
    
    throws(`class Exception`, 
        "If the requested datasource cannot be instantiated")
    shared 
    void registerDSUrl(String binding, String driver, 
            String databaseUrl, 
        String userName, String password)
            // can throw InitializationException 
            => package.registerDSUrl(binding, driver, 
                    databaseUrl, 
                    userName, password);
    
    throws(`class Exception`, 
        "If the requested datasource cannot be instantiated")
    shared 
    void registerDSName(String binding, String driver, 
            String databaseName, 
        String host, Integer port, 
        String userName, String password) 
            => package.registerDSName(binding, driver, 
                    databaseName, 
                    host, port, 
                    userName, password);
}

