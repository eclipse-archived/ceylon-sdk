import ceylon.test { ... }
import javax.transaction {
    TransactionManager,
    Transaction,
    UserTransaction,
    Status { status_no_transaction = \iSTATUS_NO_TRANSACTION, status_active = \iSTATUS_ACTIVE }
}

Boolean txnTestDo() {
    UserTransaction? transaction = tm.currentTransaction();

    print("asserting is userTransaction");
    assert (is UserTransaction transaction);
    print("asserting status_active");
    assert (transaction.status == status_active);

    return true;
}

//test
void txnTest1() {
    UserTransaction? txn = tm.currentTransaction();

    assert (! is UserTransaction txn);
}

test
void txnTest2() {
    tm.transaction(txnTestDo);
}

//test
void txnTest3() {
    UserTransaction? transaction = tm.beginTransaction();

    if (is UserTransaction transaction) {
        variable Integer status = transaction.status;

        if (!tm.isTxnActive()) {
            print("Error, tx status should have been active but was ``status``");
        }

        transaction.commit();
        status = transaction.status;

        if (status != status_no_transaction) {
          print("Error, tx status should have been no_transaction");
        }
    } else {
        print("Error, failed to lookup user transaction");
    }
}

//test
void txnTest4() {
    tm.start();

    TransactionManager? transactionManager = tm.getTransactionManager();
    assert (is TransactionManager transactionManager);

    UserTransaction?  txn1 = tm.currentTransaction();
    assert (! is UserTransaction txn1);

    transactionManager.begin();
    UserTransaction?  txn2 = tm.currentTransaction();
    assert (is UserTransaction txn2);

    Transaction txn = transactionManager.suspend();
    UserTransaction?  txn3 = tm.currentTransaction();
    assert (! is UserTransaction txn3);

    transactionManager.resume(txn);
    UserTransaction?  txn4 = tm.currentTransaction();
    assert (is UserTransaction txn4);

    transactionManager.commit();
    UserTransaction?  txn5 = tm.currentTransaction();
    assert (! is UserTransaction txn5);
    tm.stop();
}

//test
void txnTest5() {
    TransactionManager? transactionManager = tm.getTransactionManager();
    assert (is TransactionManager transactionManager);

    transactionManager.begin();
    transactionManager.setRollbackOnly();

    try {
        transactionManager.commit();
        assert (false);
    } catch (Exception ex) {
    }
}
