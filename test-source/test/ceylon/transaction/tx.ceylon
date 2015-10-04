import ceylon.test {
    ...
}
import ceylon.transaction {
    transactionManager,
    active,
    Status,
    noTransaction
}

// A callable which is expected to be run inside a transaction
Boolean txnTestDo() {
    assert (exists transaction = transactionManager.currentTransaction);
    assertEquals (active, transaction.status, 
        "Callable called without an active transaction");

    return true;
}

test
void txnTest1() {
    value txn = transactionManager.currentTransaction;
    assert (!txn exists);
}

test
void txnTest2() {
    transactionManager.start();
    transactionManager.transaction(txnTestDo);
}

test
void txnTest3() {
    transactionManager.start();
    value transaction = transactionManager.beginTransaction();

    Status status1 = transaction.status;
    assertTrue(transactionManager.transactionActive, 
        "tx status should have been active but was ``status1``");

    transaction.commit();
    
    Status status2 = transaction.status;
    assertEquals(noTransaction, status2, 
        "Wrong tx status (was ``status2``)");
}

test
void txnTest4() {
    transactionManager.start();
    value txn1 = transactionManager.currentTransaction;
    assert (!txn1 exists);

    transactionManager.beginTransaction();
    value txn2 = transactionManager.currentTransaction;
    assert (exists txn2);
//
//    Transaction txn = transactionManager.suspend();
//    UserTransaction?  txn3 = transactionManager.currentTransaction;
//    assert (! is UserTransaction txn3);
//
//    transactionManager.resume(txn);
//    UserTransaction?  txn4 = transactionManager.currentTransaction;
//    assert (is UserTransaction txn4);

    txn2.commit();
    value txn5 = transactionManager.currentTransaction;
    assert (!txn5 exists);
}

test
void txnTest5() {
    transactionManager.start();
    
    value tx = transactionManager.beginTransaction();
    tx.markRollbackOnly();

    try {
        tx.commit();
        fail ("committed a rollback only transaction");
    } catch (Exception ex) {
    }
    
    Status status = tx.status;
    assertEquals(noTransaction, status, 
        "Wrong tx status (was ``status``)");
}

test
void txnTest6() {
    transactionManager.start();
    value tx = transactionManager.beginTransaction();
    variable Boolean calledBefore = false;
    tx.callBeforeCompletion(() => calledBefore=true);
    variable Boolean calledAfter = false;
    tx.callAfterCompletion((status) => calledAfter=true);
    tx.commit();
    assert(calledAfter, calledBefore);
}

test
void txnTest7() {
    transactionManager.start();
    value tx = transactionManager.beginTransaction();
    variable Boolean calledBefore = false;
    tx.callBeforeCompletion(() => calledBefore=true);
    variable Boolean calledAfter = false;
    tx.callAfterCompletion((status) => calledAfter=true);
    tx.rollback();
    assert(calledAfter, !calledBefore);
}


test
void txnTest8() {
    transactionManager.start();
    value tx = transactionManager.beginTransaction();
    variable Boolean calledBefore = false;
    tx.callBeforeCompletion(() => calledBefore=true);
    variable Boolean calledAfter = false;
    tx.callAfterCompletion((status) => calledAfter=true);
    tx.markRollbackOnly();
    try {
        tx.commit();
        assert (false);
    }
    catch (ex) {}
    assert(calledAfter, !calledBefore);
}

