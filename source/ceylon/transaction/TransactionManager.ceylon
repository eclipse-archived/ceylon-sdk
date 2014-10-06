
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
    
    "Begin a new transaction, returning a 
     [[javax.transaction::UserTransaction]] for controlling 
     the new transaction."
    throws (`class AssertionError`, 
        "if the transaction manager is not running")
    shared formal Transaction beginTransaction();
    
    "A [[javax.transaction::UserTransaction]] for 
     controlling the current transaction, or `null` if there
     is no current transaction."
    shared formal Transaction? currentTransaction;
    
    "Determine if there is a transaction active."
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
    
    //"The JTA [[javax.transaction::TransactionManager]], or
    // `null` if the transaction manager is not running."
    //shared formal JavaTransactionManager? transactionManager;
    
    "Run a recovery scan using the in-process transaction 
     recovery service, if any."
    shared formal void recoveryScan();
    
}

shared TransactionManager transactionManager 
        => concreteTransactionManager;
