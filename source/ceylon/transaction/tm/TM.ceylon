import ceylon.transaction.tm { TMImpl }

import javax.transaction {
    UserTransaction,
    TransactionManager
}

shared interface TM {
    shared formal void start(Boolean recovery = true);
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

