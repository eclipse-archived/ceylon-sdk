
import javax.transaction {
    UserTransaction,
    JavaTransactionManager=TransactionManager
}

shared interface TransactionManager {
    
    "Start and initialise an instance of the transaction 
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
    
    shared formal UserTransaction? beginTransaction();
    
    shared formal UserTransaction? currentTransaction;
    
    shared formal Boolean transactionActive;
    
    shared formal Boolean transaction(Boolean do());
    
    shared formal JavaTransactionManager? transactionManager;
    
    "Run a recovery scan using the in-process transaction 
     recovery service, if any."
    shared formal void recoveryScan();
    
}

shared TransactionManager transactionManager 
        => concreteTransactionManager;
