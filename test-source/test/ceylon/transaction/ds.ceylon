import ceylon.collection {
    ArrayList,
    HashMap,
    MutableMap,
    HashSet,
    MutableSet
}
import ceylon.dbc {
    Sql,
    newConnectionFromDataSource,
    newConnectionFromXADataSourceWithCredentials
}
import ceylon.test {
    ...
}
import ceylon.transaction {
    transactionManager,
    Transaction
}

import javax.sql {
    XADataSource
}

import java.lang {
    System {
        setProperty
    }
}

import org.h2.jdbcx {
    JdbcDataSource
}

shared Integer tx_NONE = 0;
shared Integer tx_COMMIT = 1;
shared Integer tx_ROLLBACK = 2;

variable Integer nextKey = 1;
String tmpdir = process.propertyValue("java.io.tmpdir") else "~";
String dbloc = "jdbc:h2:" + tmpdir + "/ceylondb";

void init() {
    setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", "tmp");
    setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", "tmp");
    
    transactionManager.start(false);
    
    assertFalse (transactionManager.transactionActive, "Old transaction still associated with thread");
}

void fini() {
    transactionManager.stop();
}

XADataSource createDataSource(String url) {
    value ds = JdbcDataSource();
    ds.url=url;
    return ds;
}

Boolean updateTable(Sql sq, String dml, Boolean ignoreErrors) {
    try {
        sq.Update(dml).execute();
        return true;
    }
    catch (Exception ex) {
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
        sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").execute( "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
    for (sql in dbs) {
        sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").execute( "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;

    return 2;
}

MutableMap<String,Integer> countRows(MutableMap<String,Sql> sqlMap) {
    value values = HashMap<String,Integer>();

    for (entry in sqlMap) {
      Sql sql = entry.item;
      value count = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer?>();
      assert (exists count);
      values.put (entry.key, count);
    }

    return values;
}

Integer runTxn(Integer how, Boolean enlistDummyResource, MutableMap<String,Sql> sqlMap, variable Integer nextKV) {
    Transaction? transaction;

    if (how != tx_NONE) {
        transaction = transactionManager.beginTransaction();
        if (enlistDummyResource) {
            enlistDummyXAResources(transaction);
        }
    } else {
        transaction = null;
    }

    // list to hold the number of rows before the txn
    value list = ArrayList<Integer> { initialCapacity = 2; growthFactor = 1.5; };

    for (sql in sqlMap.items) {
        Integer? rowCnt = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer>();
        sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").
                    execute( "k" + nextKV.string, "v" + nextKV.string);
        assert (exists rowCnt);

        if (how != tx_ROLLBACK) {
            list.add(rowCnt + 1);
        }
    }

    if (how == tx_COMMIT) {
        assert (exists transaction );
        transaction.commit();
        nextKV = nextKV + 1;
    } else if (how == tx_ROLLBACK) {
        assert (exists transaction );
        transaction.rollback();
    } else {
        nextKV = nextKV + 1;
    }

    Iterator<Integer> iterator = list.iterator();
    for (sql in sqlMap.items) {
        Integer? rowCnt = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer>();
        Integer|Finished c = iterator.next();

        assert (exists rowCnt);

        if (!c is Finished) {
          assert(rowCnt == c);
        }
    }

    return nextKV;
}

void enlistDummyXAResources(Transaction? tx) {
    assert (exists tx);
    DummyXAResource dummyResource = DummyXAResource();

    tx.enlistResource(dummyResource);
}

MutableMap<String,Sql> getSqlHelper({String+} bindings) {
    value sqlMap = HashMap<String,Sql>();
    for (dsName in bindings) {
        Sql sql = Sql(newConnectionFromXADataSourceWithCredentials(createDataSource(dbloc), "sa", "sa"));
        sqlMap[dsName] = sql;
        initDb(sql);
    }
    return sqlMap;
}

// Test XA transactions with one resource
test
void sqlTest1() {
    value sqlMap = getSqlHelper(dsBindings2);

    // local commit
    nextKey = runTxn(tx_NONE, false, sqlMap, nextKey);
    // XA commit
    nextKey = runTxn(tx_COMMIT, false, sqlMap, nextKey);
}

// Test XA transactions with one resource
test
void sqlTest2a() {
    value sqlMap = getSqlHelper(dsBindings);

    nextKey = runTxn(tx_ROLLBACK, false, sqlMap, nextKey);
    nextKey = runTxn(tx_COMMIT, false, sqlMap, nextKey);
}

// Test XA transactions with multiple resources
test
void sqlTest2b() {
    value sqlMap = getSqlHelper(dsBindings);

    nextKey = runTxn(tx_ROLLBACK, true, sqlMap, nextKey);
    nextKey = runTxn(tx_COMMIT, true, sqlMap, nextKey);
}

// same as sqlTest2b but with a callable
test
void sqlTest3() {
    value sqlMap = getSqlHelper(dsBindings);
    value counts1 = countRows(sqlMap);

    // run a transaction but have the callable request an abort
    transactionManager.transaction {
        function do() {
            for (sql in sqlMap.items) {
                sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").
                            execute( "k" + nextKey.string, "v" + nextKey.string);
            }

            enlistDummyXAResources(transactionManager.currentTransaction);

            return false; // abort transaction
        }
    };

    // check that the number of rows has not changed
    value counts2 = countRows(sqlMap);

    for (entry in counts1) {
        assert (exists c = counts2[entry.key]);
        assert(entry.item == c);
    }

    // repeat but have the callable commit
    transactionManager.transaction {
        function do() {
            for (sql in sqlMap.items) {
                sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").
                            execute( "k" + nextKey.string, "v" + nextKey.string);
            }
            
            enlistDummyXAResources(transactionManager.currentTransaction);

            return true; // commit transaction
        }
    };

    // check that the number of rows have changed
    value counts3 = countRows(sqlMap);
    for (entry in counts1) {
        assert (exists c = counts3[entry.key]);
        assert(entry.item + 1 == c);
    }

    nextKey = nextKey + 1;
}

test
void localTxnTest() {
    MutableSet<Sql> sqlSet = HashSet<Sql>();
    value ds = JdbcDataSource();

    ds.url=dbloc;
    ds.user="sa";
    ds.password="sa";

    Sql sql = Sql(newConnectionFromDataSource(ds));

    sqlSet.add(sql);

    updateTable(sql, "DROP TABLE CEYLONKV", true);
    updateTable(sql, "CREATE TABLE CEYLONKV (key VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY (key))", true);

    Integer rows = insertTable(sqlSet);

    if (exists count = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer?>()) {
        assert (count == rows);
    }

    updateTable(sql, "DROP TABLE CEYLONKV", true);
}
