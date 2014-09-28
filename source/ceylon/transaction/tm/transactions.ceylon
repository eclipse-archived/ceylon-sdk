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
    javaClass
}

import com.arjuna.ats.arjuna.common {
    \IrecoveryPropertyManager {
        recoveryEnvironmentBean
    }
}
import com.arjuna.ats.arjuna.logging {
    \ItsLogger {
        logger
    }
}
import com.arjuna.ats.arjuna.recovery {
    RecoveryManager,
    RecoveryModule
}
import com.arjuna.ats.internal.arjuna.recovery {
    AtomicActionRecoveryModule
}
import com.arjuna.ats.internal.jta.recovery.arjunacore {
    XARecoveryModule
}
import com.arjuna.ats.jdbc {
    TransactionalDriver
}
import com.arjuna.ats.jdbc.common {
    \IjdbcPropertyManager {
        jdbcEnvironmentBean
    }
}
import com.arjuna.ats.jta.common {
    \IjtaPropertyManager {
        jtaEnvironmentBean
    }
}
import com.arjuna.ats.jta.utils {
    JNDIManager {
        ...
    }
}

import java.lang {
    Thread,
    Runtime
}
import java.sql {
    DriverManager
}
import java.util {
    HashSet,
    Set,
    Arrays
}

import javax.naming {
    InitialContext,
    NamingException
}

/**
 * @author <a href="mailto:mmusgrov@redhat.com">Mike Musgrove</a>
 */
    
variable RecoveryManager? recoveryManager = null;
variable Boolean initialized = false;
InitialContext initialContext = InitialContext();
variable Boolean replacedJndiProperties = false;

/**
 * Makes the transaction service available by bind various transaction related object into the default
 * JNDI tree.
 * @param startRecoveryService set to true to start the recovery service.
 * @throws InitializationException if no usable InitialContext is available
 */
shared /*synchronized*/ void start(Boolean startRecoveryService) {
    if (initialized) {
        return;
    }

    try {
        Thread.currentThread().contextClassLoader 
                = javaClass<TransactionManager>().classLoader;

        replacedJndiProperties 
                = jdbcEnvironmentBean.jndiProperties.empty;
        if (replacedJndiProperties) {
            jdbcEnvironmentBean.jndiProperties 
                    = initialContext.environment;
        }

        DriverManager.registerDriver(TransactionalDriver());
    } catch (Exception e) {
        if (logger.infoEnabled) {
            logger.info("TransactionServiceFactory error:", e);
        }
        throw Exception("No suitable JNDI provider available", e);
    }
    
    registerTransactionManagerJndiBindings(initialContext);

    initialized = true;

    if (startRecoveryService) {
        package.startRecoveryService();
    }

    object thread extends Thread() {
        run() => stop();
    }
    
    Runtime.runtime.addShutdownHook(thread);
}

shared /*synchronized*/ void recoveryScan() 
        => recoveryManager?.scan();

/**
 * Stop the transaction service. If the recovery manager was started previously then it to will be stopped.
 */
shared /*synchronized*/ void stop() {
    if (!initialized) {
        return;
    }
    
    recoveryManager?.terminate();
    recoveryManager = null;
    
    unregisterTransactionManagerJndiBindings();
    
    try {
        DriverManager.deregisterDriver(TransactionalDriver());
    }
    catch (Exception e) {
        if (logger.infoEnabled) {
            logger.debug("Unable to deregister TransactionalDriver: " 
                + e.message, e);
        }
    }
    
    if (replacedJndiProperties) {
        jdbcEnvironmentBean.jndiProperties = null;
    }
    
    initialized = false;
}

 void startRecoveryService() {
    if (!recoveryManager exists) {
        recoveryEnvironmentBean.recoveryModules 
                = Arrays.asList<RecoveryModule>
                (AtomicActionRecoveryModule(), 
                 XARecoveryModule());
        
        value rm = RecoveryManager.manager();
        rm.initialize();
        recoveryManager = rm;
    }
}

void registerJDBCXARecoveryHelper(String binding, 
    String user, String password) {
    //TODO?!
}

Set<String> tmJndiBindings = HashSet<String>();

void registerTransactionManagerJndiBindings(InitialContext initialContext) {
    try {
        bindJTATransactionManagerImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.transactionManagerJNDIContext);
        bindJTAUserTransactionImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.userTransactionJNDIContext);
        bindJTATransactionSynchronizationRegistryImplementation(initialContext);
        tmJndiBindings.add(jtaEnvironmentBean.transactionSynchronizationRegistryJNDIContext);
    } catch (NamingException e) {
        if (logger.infoEnabled) {
            logger.infof("Unable to bind TM into JNDI: %s", e.message);
        }
        throw Exception("Unable to bind TM into JNDI", e);
    }
}


void unregisterTransactionManagerJndiBindings() {
    value bindingIterator = tmJndiBindings.iterator();
    while (bindingIterator.hasNext()) {
        try {
            initialContext.unbind(bindingIterator.next());
        } catch (NamingException e) {
            if (logger.debugEnabled) {
                logger.debugf("Unable to unregister JNDI binding: %s" + e.message);
            }
        }
        bindingIterator.remove();
    }
    dsJndiBindings.clear();
}
