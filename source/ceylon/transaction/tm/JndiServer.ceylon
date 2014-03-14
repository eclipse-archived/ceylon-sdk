import org.jnp.server { Main, NamingBeanImpl }
import org.jnp.interfaces { NamingContextFactory }
import javax.naming { InitialContext, NamingException }
import java.lang {
    System { setProperty },
    Thread { currentThread },
    Runtime { jRuntime = runtime },
    JRunnable = Runnable,
    Class,
    ClassLoader }
import ceylon.transaction.tm { DSHelper }
import ceylon.interop.java { javaClassFromInstance }

"Starts a JNDI server"
by("Mike Musgrove")
shared class JndiServer(String bindAddress = "localhost", Integer port = 1099) {
    Main jndiServer = Main();
    NamingBeanImpl namingBean = NamingBeanImpl();
    variable Boolean running = false;
    object shutdownHook satisfies JRunnable {
        shared actual void run() {
            stop();
        }
    }


    shared void start() {
        setProperty("java.naming.factory.initial", "org.jnp.interfaces.NamingContextFactory");
        setProperty("java.naming.factory.url.pkgs", "org.jboss.naming:org.jnp.interfaces");

        Class<NamingBeanImpl> nbClazz = javaClassFromInstance<NamingBeanImpl>(namingBean);
        Class<Main> mClazz = javaClassFromInstance<Main>(jndiServer);
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
        InitialContext context = InitialContext();

        try {
            return context.lookup(name);
        } catch (NamingException e) {
            return null;
        }
    }

    shared
    void registerDriverSpec(String driverClassName,
                            String moduleName, String moduleVersion, String dataSourceClassName) {
        DSHelper.registerDriverSpec(driverClassName, moduleName, moduleVersion, dataSourceClassName);
    }

    shared throws(`class Exception`, "If the requested datasource cannot be instantiated")
    void registerDSUrl(String binding, String driver, String databaseUrl, 
                    String userName, String password) {
        // can throw InitializationException
        DSHelper.registerDSUrl(binding, driver, databaseUrl, userName, password);
    }

    shared throws(`class Exception`, "If the requested datasource cannot be instantiated")
    void registerDSName(String binding, String driver, String databaseName, String host, Integer port, 
                    String userName, String password) {
        DSHelper.registerDSName(binding, driver, databaseName, host, port, userName, password);
    }
}

