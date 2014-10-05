import ceylon.interop.java {
    javaClass
}
import ceylon.transaction.internal {
    registerDataSources
}

import com.arjuna.ats.arjuna.common {
    \IrecoveryPropertyManager {
        recoveryEnvironmentBean
    }
}
import com.arjuna.ats.arjuna.recovery {
    RecoveryModule,
    RecoveryManager
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

import java.lang {
    Runtime,
    Thread
}
import java.sql {
    DriverManager
}
import java.util {
    Arrays
}

import javax.naming {
    InitialContext
}
import javax.transaction {
    JavaTransactionManager=TransactionManager,
    UserTransaction,
    JavaStatus=Status
}

class ConcreteTransactionManager() satisfies TransactionManager {

    shared NamingServer jndiServer = NamingServer();
    
    variable JavaTransactionManager? transactionManager = null;
    
    variable UserTransaction? userTransaction = null;
    
    "Start the transaction service."
    throws(`class Exception`, 
        "if no JNDI InitialContext is available")
    shared actual void start(
            "If `true`, an in-process recovery service is started."
            Boolean startRecoveryService) {
        jndiServer.start();
        if (exists dataSourceConfigPropertyFile 
                = process.propertyValue("dbc.properties")) {
            registerDataSources(dataSourceConfigPropertyFile);
        }
        else {
            registerDataSources();
        }

        if (!initialized) {
            try {
                Thread.currentThread().contextClassLoader 
                        = javaClass<TransactionManager>().classLoader;
                
                replacedJndiProperties 
                        = jdbcEnvironmentBean.jndiProperties.empty;
                if (replacedJndiProperties) {
                    jdbcEnvironmentBean.jndiProperties 
                            = InitialContext().environment;
                }
                
                DriverManager.registerDriver(TransactionalDriver());
            }
            catch (Exception e) {
                throw Exception("No suitable JNDI provider available", e);
            }
            registerTransactionManagerJndiBindings();
            
            initialized = true;
            
            if (startRecoveryService) {
                if (!recoveryManager exists) {
                    recoveryEnvironmentBean.recoveryModules 
                            = Arrays.asList<RecoveryModule>
                            (AtomicActionRecoveryModule(), XARecoveryModule());
                    value rm = RecoveryManager.manager();
                    rm.initialize();
                    recoveryManager = rm;
                }
            }
            
            object thread extends Thread() {
                run() => stop();
            }
            Runtime.runtime.addShutdownHook(thread);
            
        }
        
        assert (is UserTransaction ut 
                = jndiServer.lookup("java:/UserTransaction"));
        userTransaction = ut;
        assert (is JavaTransactionManager tm 
                = jndiServer.lookup("java:/TransactionManager"));
        transactionManager = tm;
    }

    "Stop the transaction service. If an in-process recovery 
     manager is running, then it to will be stopped."
    shared actual void stop() {
        if (initialized) {
            recoveryManager?.terminate();
            recoveryManager = null;
            
            unregisterTransactionManagerJndiBindings();
            
            try {
                DriverManager.deregisterDriver(TransactionalDriver());
            }
            catch (Exception e) {
                e.printStackTrace();
            }
            
            if (replacedJndiProperties) {
                jdbcEnvironmentBean.jndiProperties = null;
            }
            
            initialized = false;
        }
        
        userTransaction = null;
        transactionManager = null;
    }
    
    recoveryScan() => recoveryManager?.scan();
    
    class ConcreteTransaction() satisfies Transaction {
        
        shared actual void commit() {
            assert (exists ut = userTransaction);
            ut.commit();
        }
        
        shared actual void rollback() {
            assert (exists ut = userTransaction);
            ut.rollback();
        }
        
        shared actual void markRollbackOnly() {
            assert (exists ut = userTransaction);
            ut.setRollbackOnly();
        }
        
        shared actual Status status {
            if (exists status = transactionManager?.status) {
                switch (status)
                case (0) {
                    return active;
                }
                case (1) {
                    return markedRolledBack;
                }
                case (2) {
                    return prepared;
                }
                case (3) {
                    return committed;
                }
                case (4) {
                    return rolledback;
                }
                case (5) {
                    return unknown;
                }
                case (6) {
                    return noTransaction;
                }
                case (7) {
                    return preparing;
                }
                case (8) {
                    return committing;
                }
                case (9) {
                    return rollingBack;
                }
                else {
                    "illegal transaction status"
                    assert (false);
                }
            }
            else {
                return noTransaction;
            }
        }
        
        shared actual void setTimeout(Integer timeout) {
            assert (exists ut = userTransaction);
            ut.setTransactionTimeout(timeout);
        }
        
    }

    shared actual Transaction beginTransaction() {
        assert (exists ut = userTransaction);
        ut.begin();
        return ConcreteTransaction();
    }

    shared actual Transaction? currentTransaction {
        if (exists ut = userTransaction) {
            if (ut.status != JavaStatus.\iSTATUS_NO_TRANSACTION) {
                return ConcreteTransaction();
            }
        }
        return null;
    }
    
    transactionActive => currentTransaction exists;

    shared actual Boolean transaction(Boolean do()) {
        variable value ok = false;
        value transaction = beginTransaction();
        try {
            ok = do();
        }
        catch (exception) {
            ok = false;
            transaction.markRollbackOnly();
            throw exception;
        }
        finally {
            try {
                if (ok) {
                    transaction.commit();
                }
                else {
                    transaction.rollback();
                }
            }
            catch (Exception e) {
                ok = false;
            }
        }
        return ok;
    }
}

variable RecoveryManager? recoveryManager = null;
variable Boolean initialized = false;
variable Boolean replacedJndiProperties = false;

ConcreteTransactionManager concreteTransactionManager 
        = ConcreteTransactionManager();
