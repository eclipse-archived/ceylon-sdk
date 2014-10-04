import ceylon.collection {
    HashMap,
    MutableMap,
    HashSet,
    MutableSet
}
import ceylon.dbc {
    Sql,
    newConnectionFromDataSource
}
import ceylon.test {
    ...
}
import ceylon.transaction {
    tm=transactionManager
}
import ceylon.transaction.datasource {
    registerDataSourceUrl,
    registerDriver
}

import java.lang {
    System {
        setProperty
    }
}

import javax.sql {
    DataSource
}
import javax.transaction {
    UserTransaction
}

import org.h2.jdbcx {
    JdbcDataSource
}

variable Integer nextKey = 1;
String dbloc = "jdbc:h2:ceylondb";

void init() {
    setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", "tmp");
    setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", "tmp");
    
    tm.start();
    
    assertFalse (tm.transactionActive, "Old transaction still associated with thread");
    registerDriver("org.h2.Driver", ["org.h2", "1.3.168"], "org.h2.jdbcx.JdbcDataSource");
    registerDataSourceUrl("h2", "org.h2.Driver", dbloc, ["sa", "sa"]);
}

void fini() {
    tm.stop();
}

Boolean updateTable(Sql sq, String dml, Boolean ignoreErrors) {
    try {
        sq.Update(dml).execute();
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
        sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").execute( "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
    for (sql in dbs) {
        sql.Update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)").execute( "k" + nextKey.string, "v" + nextKey.string);
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
    Integer rows = insertTable(sqlMap.items);

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
        Sql sql = Sql(newConnectionFromDataSource(ds));
        sqlMap.put(dsName, sql);
        initDb(sql);
    }

    return sqlMap;
}

// Test XA transactions with one resource
test
void sqlTest1() {
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings2);

    // local commit
    transactionalWork(false, true, sqlMap);
    // XA commit
    transactionalWork(true, true, sqlMap);
}

// Test XA transactions with multiple resources
void sqlTest2(Boolean doInTxn) {
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);

    // XA abort
    transactionalWork(doInTxn, false, sqlMap);

    // XA commit
    transactionalWork(doInTxn, true, sqlMap);
}

test
void sqlTest2a() {
    sqlTest2(false);
}

test
void sqlTest2b() {
    sqlTest2(true);
}

// same as sqlTest2 with a callable
test
void sqlTest3() {
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);
    variable MutableMap<String,Integer> counts = getRowCounts(sqlMap);

    // run a transaction but have the callable request an abort
    tm.transaction {
        function do() {
            insertTable(sqlMap.items);
    
            return false; // abort transaction
        }
    };

    checkRowCounts(counts, getRowCounts(sqlMap), 0);

    // repeat but have the callable commit
    counts = getRowCounts(sqlMap);

    tm.transaction {
        function do() {
            insertTable(sqlMap.items);
    
            nextKey = nextKey - 2;

            return true; // commit transaction
        }
    };

    checkRowCounts(counts, getRowCounts(sqlMap), 2);
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
    updateTable(sql, "CREATE TABLE CEYLONKV (key VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY ( key ))", true);

    Integer rows = insertTable(sqlSet);
	Integer? count = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer>();
    

    if (exists count ) {
        assert (count == rows);
    }

    updateTable(sql, "DROP TABLE CEYLONKV", true);
}

MutableMap<String,Integer> getRowCounts(MutableMap<String,Sql> sqlMap) {
    MutableMap<String,Integer> values = HashMap<String,Integer>();

    for (entry in sqlMap) {
      Sql sql = entry.item;
	  Integer? count = sql.Select("SELECT COUNT(*) FROM CEYLONKV").singleValue<Integer>();

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

