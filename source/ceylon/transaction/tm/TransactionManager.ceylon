import ceylon.transaction.rm {
    RecoveryManager
}
import ceylon.transaction.tm {
    ConcreteTransactionManager
}

import javax.transaction {
    UserTransaction,
    JavaTransactionManager=TransactionManager
}

see (`interface RecoveryManager`)
shared interface TransactionManager {
    
    "Start and initialise an instance of the transaction 
     manager.If the [[startRecovery]] parameter is true then 
     an in process instance of a [[RecoveryManager]] is 
     started. There must only be one `RecoveryManager` per 
     set of transaction logs so the recommended operation is 
     to start the `RecoveryManager` out of process."
    shared formal void start(Boolean startRecovery = false);
    
    shared formal void stop();
    
    shared formal UserTransaction? beginTransaction();
    
    shared formal UserTransaction? currentTransaction;
    
    shared formal Boolean transactionActive;
    
    shared formal Boolean transaction(Boolean do());
    
    shared formal JavaTransactionManager? transactionManager;
    
}

// package level transaction manager
ConcreteTransactionManager concreteTransactionManager 
        = ConcreteTransactionManager();

shared TransactionManager transactionManager 
        => concreteTransactionManager;

shared JndiServer jndiServer 
        => concreteTransactionManager.jndiServer;


