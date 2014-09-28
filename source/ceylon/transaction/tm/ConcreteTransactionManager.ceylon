import javax.transaction {
    JavaTransactionManager=TransactionManager,
    UserTransaction,
    Status {
        status_no_transaction=STATUS_NO_TRANSACTION
    }
}

class ConcreteTransactionManager() satisfies TransactionManager {

    shared JndiServer jndiServer = JndiServer();
    
    shared actual variable JavaTransactionManager? transactionManager = null;
    
    variable UserTransaction? userTransaction = null;
    
    shared actual void start(Boolean recovery) {
        jndiServer.start();
        if (exists dataSourceConfigPropertyFile 
            = process.propertyValue("dbc.properties")) {
            bindDataSources(dataSourceConfigPropertyFile);
        }
        else {
            bindDataSources();
        }
        package.start(recovery);
        if (is UserTransaction ut 
            = jndiServer.lookup("java:/UserTransaction")) {
            userTransaction = ut;
        }
        if (is JavaTransactionManager tm 
            = jndiServer.lookup("java:/TransactionManager")) {
            transactionManager = tm;
        } else {
            print("java:/TransactionManager lookup failed");
        }
    }

    shared actual void stop() {
        package.stop();
        userTransaction = null;
        transactionManager = null;
    }

    shared actual UserTransaction? beginTransaction() {
        if (is UserTransaction ut = userTransaction) {
            ut.begin();
            return ut;
        }
        return null;
    }

    shared actual UserTransaction? currentTransaction {
        if (is UserTransaction ut = userTransaction) {
            if (ut.status != status_no_transaction) {
                return ut;
            }
        }
        return null;
    }
    
    transactionActive => currentTransaction exists;

    "Execute the passed Callable within a transaction. If any
     exception is thrown from within the Callable, the transaction will
     be rolled back; otherwise it is committed."
    shared actual Boolean transaction(Boolean do()) {
        variable value ok = false;
        if (exists transaction = beginTransaction()) {
            try {
                ok = do();
            } finally {
                try {
                    if (ok) {
                        transaction.commit();
                    } else {
                        transaction.rollback();
                    }
                } catch (Exception e) {
                    ok = false;
                }
            }
        }

        return ok;
    }
}
