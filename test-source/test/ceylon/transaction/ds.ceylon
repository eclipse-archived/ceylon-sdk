import ceylon.test { ... }

import java.lang { System { setProperty } }
import ceylon.transaction.tm { TM }
import ceylon.collection { HashMap, MutableMap, HashSet, MutableSet }
import ceylon.dbc { Sql }

import javax.transaction {
    TransactionManager,
    Transaction,
    UserTransaction,
    Status { status_no_transaction = \iSTATUS_NO_TRANSACTION, status_active = \iSTATUS_ACTIVE }
}

import org.h2.jdbcx {JdbcDataSource}

import javax.sql { DataSource }

variable Integer nextKey = 1;
String dbloc = "jdbc:h2:ceylondb";

void init() {
    setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", "tmp");
    setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", "tmp");

    tm.start();

    assertFalse (tm.isTxnActive(), "Old transaction still associated with thread");
    tm.getJndiServer().registerDriverSpec("org.h2.Driver", "org.h2", "1.3.168", "org.h2.jdbcx.JdbcDataSource");
    tm.getJndiServer().registerDSUrl("h2", "org.h2.Driver", dbloc, "sa", "sa");
}

void fini() {
    tm.stop();
}

Boolean updateTable(Sql sq, String dml, Boolean ignoreErrors) {
    try {
        sq.update(dml);
        return true;
    } catch (Exception ex) {
        print("``dml`` error: ``ex.message``");
        if (!ignoreErrors) {
            throw ex;
        }
        return false;
    }
}

void initDb(Sql sql) {
    updateTable(sql, "DROP TABLE CEYLONKV", true);

    updateTable(sql, "CREATE TABLE CEYLONKV (key VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY ( key ))", true);
}

// insert two values into each of the requested dbs
Integer insertTable(Collection<Sql> dbs) {
    for (sql in dbs) {
        sql.update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)", "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
    for (sql in dbs) {
        sql.update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)", "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;

    return 2;
}

void transactionalWork(Boolean doInTxn, Boolean commit, MutableMap<String,Sql> sqlMap) {
    UserTransaction? transaction;

    if (doInTxn) {
        transaction = tm.beginTransaction();
    } else {
        transaction = null;
    }

    MutableMap<String,Integer> counts = getRowCounts(sqlMap);
    Integer rows = insertTable(sqlMap.values);

    if (exists transaction) {
        if (commit) {
            transaction.commit();
            checkRowCounts(counts, getRowCounts(sqlMap), rows);
        } else {
            transaction.rollback();
            checkRowCounts(counts, getRowCounts(sqlMap), 0);
            nextKey = nextKey - 2;
        }
    } else {
        checkRowCounts(counts, getRowCounts(sqlMap), rows);
    }
}

MutableMap<String,Sql> getSqlHelper({String+} bindings) {
    MutableMap<String,Sql> sqlMap = HashMap<String,Sql>();

    for (dsName in bindings) {
        DataSource? ds = getXADataSource(dsName);
        assert (is DataSource ds);
        Sql sql = Sql(ds);
        sqlMap.put(dsName, sql);
        initDb(sql);
    }

    return sqlMap;
}

// Test XA transactions with one resource
test
void sqlTest1() {
    init();
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings2);

    // local commit
    transactionalWork(false, true, sqlMap);
    // XA commit
    transactionalWork(true, true, sqlMap);
    fini();
}

// Test XA transactions with multiple resources
void sqlTest2(Boolean doInTxn) {
    init();
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);

    // XA abort
    transactionalWork(doInTxn, false, sqlMap);

    // XA commit
    transactionalWork(doInTxn, true, sqlMap);
    fini();
}

test
void sqlTest2a() {
    init();
    sqlTest2(false);
    fini();
}

test
void sqlTest2b() {
    init();
    sqlTest2(true);
    fini();
}

// same as sqlTest2 with a callable
test
void sqlTest3() {
    init();
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);
    variable MutableMap<String,Integer> counts = getRowCounts(sqlMap);

    // run a transaction but have the callable request an abort
    tm.transaction {
        function do() {
            insertTable(sqlMap.values);
    
            return false; // abort transaction
        }
    };

    checkRowCounts(counts, getRowCounts(sqlMap), 0);

    // repeat but have the callable commit
    counts = getRowCounts(sqlMap);

    tm.transaction {
        function do() {
            insertTable(sqlMap.values);
    
            nextKey = nextKey - 2;

            return true; // commit transaction
        }
    };

    checkRowCounts(counts, getRowCounts(sqlMap), 2);

    fini();
}

test
void localTxnTest() {
    init();
    MutableSet<Sql> sqlSet = HashSet<Sql>();
    value ds = JdbcDataSource();

    ds.url=dbloc;
    ds.user="sa";
    ds.password="sa";

    Sql sql = Sql(ds);

    sqlSet.add(sql);

    updateTable(sql, "DROP TABLE CEYLONKV", true);
    updateTable(sql, "CREATE TABLE CEYLONKV (key VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY ( key ))", true);

    Integer rows = insertTable(sqlSet);

    if (exists count = sql.queryForInteger("SELECT count(*) FROM CEYLONKV")) {
        assert (count == rows);
    }

    updateTable(sql, "DROP TABLE CEYLONKV", true);
    fini();
}

MutableMap<String,Integer> getRowCounts(MutableMap<String,Sql> sqlMap) {
    MutableMap<String,Integer> values = HashMap<String,Integer>();

    for (entry in sqlMap) {
      Sql sql = entry.item;
      Integer? count = sql.queryForInteger("SELECT count(*) FROM CEYLONKV");

      assert (exists count);
      values.put (entry.key, count);
    }

    return values;
}

void checkRowCounts(MutableMap<String,Integer> prev, MutableMap<String,Integer> curr, Integer delta) {
    for (entry in prev) {
        Integer? c = curr[entry.key];
        if (exists c) {
            assert(entry.item + delta == c);
        } 
    }
}

