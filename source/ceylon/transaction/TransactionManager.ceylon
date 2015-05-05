
import javax.sql {
    XADataSource
}
import java.sql { Connection }

shared interface TransactionManager {
    
    "Start and initialize an instance of the transaction 
     manager.
     
     If the [[startRecovery]] is true then an in-process 
     transaction recovery service is also started. There 
     must exactly one recovery service per set of transaction 
     logs, so it is recommended that the recovery service
     be run in a 
     [[dedicated process|ceylon.transaction.recovery::run]]
     whenever multiple processes share the same set of 
     transaction logs."
    shared formal void start(Boolean startRecovery = false);
    
    "Stop this transaction manager.
     
     Also stops the in-process transaction recovery service,
     if any."
    shared formal void stop();
    
    "Begin a new transaction and associate it with the current
     thread. Return a [[javax.transaction::UserTransaction]]
     for controlling the new transaction."
    throws (`class AssertionError`, 
        "if the transaction manager is not running")
    shared formal Transaction beginTransaction();
    
    "A [[javax.transaction::UserTransaction]] for 
     controlling the current transaction, or `null` if there
     is no current transaction."
    shared formal Transaction? currentTransaction;
    
    "Determine if there is a transaction active on the current
     thread."
    throws (`class AssertionError`, 
        "if the transaction manager is not running")
    shared formal Boolean transactionActive;
    
    "Perform the given [[work|do]] in a transaction." 
    throws (`class AssertionError`, 
        "if the transaction manager is not running")
    shared formal Boolean transaction(
            "The work. Return `false` to roll back the
             transaction."
            Boolean do());

    "Modify the timeout value that is associated with transactions
     started by the current thread with the beginTransaction method."
    shared formal void setTimeout(
            "The number of seconds after which the next transaction will
             be automatically rolled back if it is still active"
            Integer seconds);

    "Obtain a XA connection source, that is, an instance of
     `Connection()`, for a given JDBC XA [[dataSource]]."
    shared formal Connection newConnectionFromXADataSource(XADataSource dataSource);

    "Obtain a connection source, that is, an instance of
     `Connection()`, for a given JDBC XA [[dataSource]], and
     given credentials."
    shared formal Connection newConnectionFromXADataSourceWithCredentials
        (XADataSource dataSource, [String, String] userNameAndPassword);
}

shared TransactionManager transactionManager 
        => concreteTransactionManager;
