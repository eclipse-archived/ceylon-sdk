import org.jnp.server { Main, NamingBeanImpl }
// guessing import
import org.jnp.interfaces { NamingContextFactory }
import javax.naming { InitialContext, NamingException }
import java.lang { System { setProperty }, Thread { currentThread }, Class, ClassLoader }
import ceylon.transaction.tm { DSHelper }
import ceylon.interop.java { javaClassFromInstance }

"Starts a JNDI server"
by("Mike Musgrove")
shared class JndiServer(String bindAddress = "localhost", Integer port = 1099) {
//    Main main = Main();
    NamingBeanImpl namingBean = NamingBeanImpl();

    shared void start() {
        System.setProperty("java.naming.factory.initial", "org.jnp.interfaces.NamingContextFactory");
        System.setProperty("java.naming.factory.url.pkgs", "org.jboss.naming:org.jnp.interfaces");

//        main.namingInfo = namingBean;
//        main.port = port;
//        main.bindAddress = bindAddress;

	Class<NamingBeanImpl> klass = javaClassFromInstance<NamingBeanImpl>(namingBean);
	ClassLoader cl = klass.classLoader;
	ClassLoader prevCl = currentThread().contextClassLoader;
	try{
	    currentThread().contextClassLoader = cl;
            namingBean.start();
	}finally{
	    currentThread().contextClassLoader = prevCl;
	}
//        main.start();
    }

    shared void stop() {
//        main.stop();
        namingBean.stop();
    }

    shared Object? lookup(String name) {
        InitialContext context = InitialContext();

        try {
            return context.lookup(name);
        } catch (NamingException e) {
            return null;
        }
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

