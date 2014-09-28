import ceylon.test {
    ...
}

import javax.transaction {
    TransactionManager,
    Transaction,
    UserTransaction,
    Status {
        status_no_transaction=STATUS_NO_TRANSACTION,
        status_active=STATUS_ACTIVE
    }
}

// A callable which is expected to be run inside a transaction
Boolean txnTestDo() {
    UserTransaction? transaction = tm.currentTransaction;

    assert (is UserTransaction transaction);
    assertEquals (status_active, transaction.status, "Callable called without an active transaction");

    return true;
}

test
void txnTest1() {
    UserTransaction? txn = tm.currentTransaction;

    assert (! is UserTransaction txn);
}

test
void txnTest2() {
    tm.start();
    tm.transaction(txnTestDo);
}

test
void txnTest3() {
    tm.start();
    UserTransaction? transaction = tm.beginTransaction();

    assert (is UserTransaction transaction);

    variable Integer status = transaction.status;

    assertTrue(tm.transactionActive, "tx status should have been active but was ``status``");

    transaction.commit();
    status = transaction.status;

    assertEquals(status_no_transaction, status, "Wrong tx status (was ``status``)");
}

test
void txnTest4() {
    tm.start();
    TransactionManager? transactionManager = tm.transactionManager;
    assert (is TransactionManager transactionManager);

    UserTransaction?  txn1 = tm.currentTransaction;
    assert (! is UserTransaction txn1);

    transactionManager.begin();
    UserTransaction?  txn2 = tm.currentTransaction;
    assert (is UserTransaction txn2);

    Transaction txn = transactionManager.suspend();
    UserTransaction?  txn3 = tm.currentTransaction;
    assert (! is UserTransaction txn3);

    transactionManager.resume(txn);
    UserTransaction?  txn4 = tm.currentTransaction;
    assert (is UserTransaction txn4);

    transactionManager.commit();
    UserTransaction?  txn5 = tm.currentTransaction;
    assert (! is UserTransaction txn5);
}

test
void txnTest5() {
    tm.start();
    TransactionManager? transactionManager = tm.transactionManager;
    assert (is TransactionManager transactionManager);

    transactionManager.begin();
    transactionManager.setRollbackOnly();

    try {
        transactionManager.commit();
        fail ("committed a rollback only transaction");
    } catch (Exception ex) {
    }
}
