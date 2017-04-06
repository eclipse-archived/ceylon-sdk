import com.arjuna.ats.jdbc {
    TransactionalDriver {
        xadsPropertyName=xaDataSource
    }
}
import com.arjuna.ats.jdbc.common {
    jdbcPropertyManager {
        jdbcEnvironmentBean
    }
}

import java.lang {
    Runtime,
    Thread,
    JavaString=String,
    Types {
        classForType
    }
}
import java.sql {
    DriverManager {
        getConnection,
        registerDriver,
        deregisterDriver
    },
    Connection
}
import java.util {
    Properties
}

import javax.naming {
    InitialContext
}
import javax.sql {
    XADataSource
}
import javax.transaction {
    JavaTransactionManager=TransactionManager,
    UserTransaction,
    JavaStatus=Status,
    Synchronization
}
import javax.transaction.xa {
    XAResource
}

class ConcreteTransactionManager() 
        satisfies TransactionManager {
    
    String txDriverUrl = "jdbc:arjuna:";

    shared NamingServer jndiServer = NamingServer();

    variable JavaTransactionManager? transactionManager = null;
    
    variable UserTransaction? userTransaction = null;
    
    variable TransactionRecoveryManager? recoveryManager = null;
    variable Boolean initialized = false;
    variable Boolean replacedJndiProperties = false;
    
    "Start the transaction service."
    throws(`class Exception`, 
        "if no JNDI InitialContext is available")
    shared actual void start(
            "If `true`, an in-process recovery service is started."
            Boolean startRecoveryService) {

        jndiServer.start();

        if (!initialized) {
            try {
                Thread.currentThread()
                        .contextClassLoader
                            = classForType<TransactionManager>()
                                    .classLoader;

                replacedJndiProperties
                        = jdbcEnvironmentBean.jndiProperties
                            .empty;
                if (replacedJndiProperties) {
                    jdbcEnvironmentBean.jndiProperties
                            = InitialContext().environment;
                }
                
                registerDriver(TransactionalDriver());
            }
            catch (Exception e) {
                throw Exception("No suitable JNDI provider available", e);
            }
            registerTransactionManagerJndiBindings();

            initialized = true;
            
            if (startRecoveryService) {
                if (!recoveryManager exists) {
                    recoveryManager = ConcreteRecoveryManager();
                    recoveryManager?.start();
                }
            }
            
            object thread extends Thread() {
                run() => outer.stop();
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

    shared actual Connection 
    newConnectionFromXADataSource(XADataSource dataSource) {
        Properties dbProperties = Properties();
        dbProperties[xadsPropertyName] = dataSource;
        return getConnection(txDriverUrl, dbProperties);
    }

    shared actual Connection 
    newConnectionFromXADataSourceWithCredentials(
            XADataSource dataSource, 
            [String, String] userNameAndPassword) {
        Properties dbProperties = Properties();
        dbProperties[JavaString(TransactionalDriver.userName)]
            = JavaString(userNameAndPassword[0]);
        dbProperties[JavaString(TransactionalDriver.password)]
            = JavaString(userNameAndPassword[1]);
        dbProperties[xadsPropertyName] = dataSource;
        return getConnection(txDriverUrl, dbProperties);
    }

    shared actual void setTimeout(Integer timeout) {
        assert (exists ut = userTransaction);
        ut.setTransactionTimeout(timeout);
    }
        
    "Stop the transaction service. If an in-process recovery 
     manager is running, then it to will be stopped."
    shared actual void stop() {
        if (initialized) {
            recoveryManager?.stop();
            recoveryManager = null;
            
            unregisterTransactionManagerJndiBindings();
            
            try {
                deregisterDriver(TransactionalDriver());
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
        
        Status toStatus(Integer status) {
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
        
        shared actual Status status {
            if (exists status = transactionManager?.status) {
                return toStatus(status);
            }
            else {
                return noTransaction;
            }
        }
        
        shared actual void callAfterCompletion(
                void afterCompletionFun(Status status)) {
            assert(exists tx = transactionManager?.transaction);
            tx.registerSynchronization(
                    object satisfies Synchronization {
                shared actual void beforeCompletion() {}
                shared actual void afterCompletion(Integer int) 
                        => afterCompletionFun(toStatus(int));
            });
        }
        
        shared actual void callBeforeCompletion(
                void beforeCompletionFun()) {
            assert(exists tx = transactionManager?.transaction);
            tx.registerSynchronization(
                    object satisfies Synchronization {
                shared actual void beforeCompletion()
                        => beforeCompletionFun();
                shared actual void afterCompletion(Integer int) {}
            });
        }
    
        shared actual void enlistResource(XAResource xar) {
            assert(exists tx = transactionManager?.transaction);
            tx.enlistResource(xar);
        }
    }

    shared actual Transaction beginTransaction() {
        assert (exists ut = userTransaction);
        ut.begin();
        return ConcreteTransaction();
    }

    currentTransaction
            => if (exists ut = userTransaction,
                   ut.status != JavaStatus.statusNoTransaction)
            then ConcreteTransaction()
            else null;

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

ConcreteTransactionManager concreteTransactionManager 
        = ConcreteTransactionManager();
