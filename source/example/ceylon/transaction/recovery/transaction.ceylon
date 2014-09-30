import ceylon.collection {
    HashMap,
    MutableMap
}

import ceylon.dbc {
    Sql,
    newConnectionFromDataSource
}

import ceylon.transaction.tm {
    TransactionManager,
    transactionManager,
    jndiServer
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
    Transaction,
    UserTransaction,
    JavaTransactionManager=TransactionManager
}

TransactionManager tm = transactionManager;
String dbloc = "jdbc:h2:tmp/ceylondb";
variable Integer nextKey = 5;

//{String+} dsBindings2 = { "db2", "postgresql", "oracle_thin", "hsqldb" };
// a list of datasource (JNDI names) to enlist into a transaction
{String+} dsBindings = { "h2" };

MutableMap<String,Sql> getSqlHelper({String+} bindings) {
    MutableMap<String,Sql> sqlMap = HashMap<String,Sql>();

    for (dsName in bindings) {
        DataSource? ds = getXADataSource(dsName);
        assert (is DataSource ds);
        Sql sql = Sql(newConnectionFromDataSource(ds));
        sqlMap.put(dsName, sql);
        initDb(sql);
        print("db ``dsName`` registered");
    }

    return sqlMap;
}

DataSource? getXADataSource(String binding) {
    Object? ds = jndiServer.lookup(binding);

    if (is DataSource ds) {
        return ds;
    } else {
        return null;
    }
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
    updateTable(sql, "CREATE TABLE CEYLONKV (rkey VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY ( rkey ))",
	    true);
    sql.Update("DELETE FROM CEYLONKV").execute();
}


// insert two values into each requested dbs
Integer insertTable(Collection<Sql> dbs) {
    for (sql in dbs) {
        print("inserting key ``nextKey`` using ds ``sql``");
        sql.Update("INSERT INTO CEYLONKV(rkey,val) VALUES (?, ?)").
		    execute( "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
    for (sql in dbs) {
        print("inserting key ``nextKey`` using ds ``sql``");
        sql.Update("INSERT INTO CEYLONKV(rkey,val) VALUES (?, ?)").
		    execute( "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;

    return 2;
}

void transactionalWork(Boolean doInTxn, Boolean commit, MutableMap<String,Sql> sqlMap) {
    UserTransaction? transaction;

    if (doInTxn) {
        transaction = tm.beginTransaction();
        enlistDummyXAResources();
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

void init() {
    setProperty("com.arjuna.ats.arjuna.objectstore.objectStoreDir", "tmp");
    setProperty("com.arjuna.ats.arjuna.common.ObjectStoreEnvironmentBean.objectStoreDir", "tmp");

    tm.start(false);

    if (tm.transactionActive) {
        print("Old transaction still associated with thread");
        throw;
    }

    // programatic method of registering datasources (the alternative is to use a config file)
    jndiServer.registerDriverSpec("org.h2.Driver", "org.h2", "1.3.168", "org.h2.jdbcx.JdbcDataSource");
    jndiServer.registerDSUrl("h2", "org.h2.Driver", dbloc, "sa", "sa");

    // if you have postgresql db then you would register is as follows:
//    jndiServer.registerDriverSpec(
//        "org.postgresql.Driver", "org.postgresql", "9.2-1002", "org.postgresql.xa.PGXADataSource");
//    jndiServer.registerDSName(
//        "postgresql", "org.postgresql.Driver", "ceylondb", "localhost", 5432, "sa", "sa");
}

void fini() {
    tm.stop();
}

void enlistDummyXAResources() {
    JavaTransactionManager? transactionManager = tm.transactionManager;
    assert (exists transactionManager);

    Transaction txn = transactionManager.transaction;

    DummyXAResource dummyResource1 = DummyXAResource();

    txn.enlistResource(dummyResource1);
}

"The runnable method of the module."
by("Mike Musgrove")
shared void run() {
    init();
 
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);

    transactionalWork(true, true, sqlMap);

    fini();
}

