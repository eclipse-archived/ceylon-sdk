import ceylon.transaction.tm { TransactionServiceFactory, JndiServer, DSHelper { bindDataSources } }

import java.lang { Class }
import javax.sql { XADataSource }

//import io.narayana.spi {
//    TransactionServiceFactory
//}

import javax.transaction {
    TransactionManager,
    UserTransaction,
    Status { status_no_transaction = \iSTATUS_NO_TRANSACTION, status_active = \iSTATUS_ACTIVE }
}

shared class TMImpl() satisfies TM {

    JndiServer jndiServer = JndiServer();
    TransactionServiceFactory transactionServiceFactory = TransactionServiceFactory();
	variable UserTransaction? userTransaction = null;
	variable TransactionManager? transactionManager = null;

    shared actual void start(Boolean recovery) {
        jndiServer.start();

		bindDataSources();
        transactionServiceFactory.start(recovery);

        Object? ut = jndiServer.lookup("java:/UserTransaction");
        if (is UserTransaction ut) {
		    userTransaction = ut;
		}

        Object? tm = jndiServer.lookup("java:/TransactionManager");
        if (is TransactionManager tm) {
		    transactionManager = tm;
		} else {
		    print("java:/TransactionManager lookup failed");
		}
    }

    shared actual void stop() {
        transactionServiceFactory.stop();
        jndiServer.stop();
		userTransaction = null;
		transactionManager = null;
    }

    shared actual UserTransaction? beginTransaction() {
        Object? ut = userTransaction; //jndiServer.lookup("java:/UserTransaction");

        if (is UserTransaction ut) {
            ut.begin();
            return ut;
        }

        return null;
    }

    shared actual UserTransaction? currentTransaction() {
        Object? ut = userTransaction;

        if (is UserTransaction ut ) {
		    if (ut.status != status_no_transaction) {
		        return ut;
			}
		}

        return null;
    }

    shared actual TransactionManager? getTransactionManager() {
        Object? tm = transactionManager;

        if (is TransactionManager tm ) {
		    return tm;
		}

        return null;
    }

	shared actual Boolean isTxnActive() {
	    UserTransaction? txn = currentTransaction();

        if (is UserTransaction txn) {
		    return true;
		}

		return false;
	}

    shared actual JndiServer getJndiServer() {
	    return jndiServer;
    }

    "Execute the passed Callable within a transaction. If any
     exception is thrown from within the Callable, the transaction will
     be rolled back; otherwise it is committed."
    shared actual Boolean transaction(Boolean do()) {
        UserTransaction? transaction = beginTransaction();
        variable value ok = false;

        if (exists transaction) {
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
