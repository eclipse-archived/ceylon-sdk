import ceylon.test {
    ...
}
import ceylon.transaction {
    tm=transactionManager,
    active,
    Status,
    noTransaction
}

// A callable which is expected to be run inside a transaction
Boolean txnTestDo() {
    assert (exists transaction = tm.currentTransaction);
    assertEquals (active, transaction.status, 
        "Callable called without an active transaction");

    return true;
}

test
void txnTest1() {
    value txn = tm.currentTransaction;
    assert (!txn exists);
}

test
void txnTest2() {
    tm.start();
    tm.transaction(txnTestDo);
}

test
void txnTest3() {
    tm.start();
    value transaction = tm.beginTransaction();

    Status status1 = transaction.status;
    assertTrue(tm.transactionActive, 
        "tx status should have been active but was ``status1``");

    transaction.commit();
    
    Status status2 = transaction.status;
    assertEquals(noTransaction, status2, 
        "Wrong tx status (was ``status2``)");
}

test
void txnTest4() {
    tm.start();
    value txn1 = tm.currentTransaction;
    assert (!txn1 exists);

    tm.beginTransaction();
    value txn2 = tm.currentTransaction;
    assert (exists txn2);
//
//    Transaction txn = transactionManager.suspend();
//    UserTransaction?  txn3 = tm.currentTransaction;
//    assert (! is UserTransaction txn3);
//
//    transactionManager.resume(txn);
//    UserTransaction?  txn4 = tm.currentTransaction;
//    assert (is UserTransaction txn4);

    txn2.commit();
    value txn5 = tm.currentTransaction;
    assert (!txn5 exists);
}

test
void txnTest5() {
    tm.start();
    
    value tx = tm.beginTransaction();
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
    tm.start();
    value tx = tm.beginTransaction();
    variable Boolean calledBefore = false;
    tx.callBeforeCompletion(() => calledBefore=true);
    variable Boolean calledAfter = false;
    tx.callAfterCompletion((status) => calledAfter=true);
    tx.commit();
    assert(calledAfter, calledBefore);
}

test
void txnTest7() {
    tm.start();
    value tx = tm.beginTransaction();
    variable Boolean calledBefore = false;
    tx.callBeforeCompletion(() => calledBefore=true);
    variable Boolean calledAfter = false;
    tx.callAfterCompletion((status) => calledAfter=true);
    tx.rollback();
    assert(calledAfter, !calledBefore);
}


test
void txnTest8() {
    tm.start();
    value tx = tm.beginTransaction();
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

