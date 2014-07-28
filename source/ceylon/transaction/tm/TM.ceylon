import ceylon.transaction.tm { TMImpl }

import javax.transaction {
    UserTransaction,
    TransactionManager
}

//see (`class ceylon.transaction.rm.RecoveryManager`)
shared interface TM {
    "Start and initialise an instance of the transaction manager.
     If the startRecovery parameter is true then an in process instance
     of a [[RecoveryManager]] is started. There must only be one
     RecoveryManager per set of transaction logs so the recommended
     operation is to start the RecoveryManager out of process."
    shared formal void start(Boolean startRecovery = false);
    shared formal void stop();
    shared formal UserTransaction? beginTransaction();
    shared formal UserTransaction? currentTransaction();
    shared formal TransactionManager? getTransactionManager();
    shared formal Boolean isTxnActive();
    shared formal Boolean transaction(Boolean do());
    shared formal JndiServer getJndiServer();
}

// package level transaction manager
TM tm = TMImpl();
shared TM getTM() => tm;

