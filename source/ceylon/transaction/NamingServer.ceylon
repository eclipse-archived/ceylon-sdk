import com.arjuna.ats.jta.common {
    jtaPropertyManager {
        jtaEnvironmentBean
    }
}
import com.arjuna.ats.jta.utils {
    JNDIManager {
        ...
    }
}

import java.lang {
    System {
        setProperty
    },
    Thread {
        currentThread
    },
    Runtime {
        javaRuntime=runtime
    },
    Runnable,
    Types {
        classForInstance
    }
}
import java.util {
    Set,
    HashSet
}

import javax.naming {
    InitialContext,
    NamingException
}

import org.jnp.server {
    Main,
    NamingBeanImpl
}


"Mediates interaction with a JNDI server."
by ("Mike Musgrove")
class NamingServer(bindAddress = "localhost", port = 1099) {
    
    Integer port;
    String bindAddress;
    
    variable value running = false;
    
    shared void start() {
        setProperty("java.naming.factory.initial", 
            "org.jnp.interfaces.NamingContextFactory");
        setProperty("java.naming.factory.url.pkgs", 
            "org.jboss.naming:org.jnp.interfaces");
        
        value jndiServer = Main();
        value namingBean = NamingBeanImpl();
        
        value previousClassLoader 
                = currentThread().contextClassLoader;
        value namingBeanClassLoader 
                = classForInstance(namingBean).classLoader;
        try {
            currentThread().contextClassLoader = namingBeanClassLoader;
            jndiServer.namingInfo = namingBean;
            jndiServer.port = port;
            jndiServer.bindAddress = bindAddress;

            namingBean.start();
            //jndiServer.start();
            running = true;
            object shutdownHook satisfies Runnable {
                shared actual void run() {
                    if (running) {
                        //jndiServer.stop();
                        namingBean.stop();
                    }
                }
            }
            value shutdownThread 
                    = Thread(shutdownHook, "Shutdown thread");
            shutdownThread.daemon = false;
            javaRuntime.addShutdownHook(shutdownThread);

        } finally {
            currentThread().contextClassLoader = previousClassLoader;
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
    
}


Set<String> tmJndiBindings = HashSet<String>();

void registerTransactionManagerJndiBindings() {
    value initialContext = InitialContext();
    try {
        bindJTATransactionManagerImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.transactionManagerJNDIContext);
        bindJTAUserTransactionImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.userTransactionJNDIContext);
        bindJTATransactionSynchronizationRegistryImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.transactionSynchronizationRegistryJNDIContext);
    }
    catch (NamingException e) {
        throw Exception("Unable to bind TM into JNDI", e);
    }
}


void unregisterTransactionManagerJndiBindings() {
    value initialContext = InitialContext();
    value bindingIterator = tmJndiBindings.iterator();
    while (bindingIterator.hasNext()) {
        try {
            initialContext.unbind(bindingIterator.next());
        }
        catch (NamingException e) {}
        bindingIterator.remove();
    }
}

