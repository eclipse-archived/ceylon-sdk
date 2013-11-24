import ceylon.test { ... }

import ceylon.transaction.tm { TM, getTM }
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

void insertTable(Collection<Sql> dbs) {
	for (sql in dbs) {
        sql.update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)", "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
	for (sql in dbs) {
        sql.update("INSERT INTO CEYLONKV(key,val) VALUES (?, ?)", "k" + nextKey.string, "v" + nextKey.string);
    }
    nextKey = nextKey + 1;
}

void printRows(String message, MutableMap<String,Sql> sqlMap) {
    print(message);

	for (entry in sqlMap) {
	    Map<String,Object>[] rows = entry.item.rows("SELECT * FROM CEYLONKV")({});
        print("\t" + entry.key + " contents:");

        for (row in rows) {
            Object k = row["key"] else "";
            Object v = row["val"] else "";

            print("\t\tkey=``k`` val=``v`` (``row``)");
        }
	}
}

void transactionalWork(Boolean doInTxn, Boolean commit, Collection<Sql> dbs) {
    UserTransaction? transaction;

    if (doInTxn) {
        transaction = tm.beginTransaction();
    } else {
        transaction = null;
    }

    insertTable(dbs);

    if (exists transaction) {
        if (commit) {
            transaction.commit();
        } else {
            transaction.rollback();
            nextKey = nextKey - 2;
        }
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
void sqlTest1(Boolean doInTxn) {
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings2);

    transactionalWork(doInTxn, true, sqlMap.values);
    printRows("====== contents after commit:", sqlMap);
}

// Test XA transactions with multiple resources
test
void sqlTest2(Boolean doInTxn) {
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);

    printRows("====== contents before test:", sqlMap);

    transactionalWork(doInTxn, false, sqlMap.values);
    printRows("====== contents after abort:", sqlMap);

    transactionalWork(doInTxn, true, sqlMap.values);
    printRows("====== contents after commit:", sqlMap);
}

// same as sqlTest2 with a callable
test
void sqlTest3() {
    tm.start();
    MutableMap<String,Sql> sqlMap = getSqlHelper(dsBindings);

    printRows("====== contents before test3:", sqlMap);

	tm.transaction {
	    function do() {
            insertTable(sqlMap.values);
    
			return false;
        }
	};

    printRows("====== contents after test3 abort:", sqlMap);

	tm.transaction {
	    function do() {
            insertTable(sqlMap.values);
    
	        nextKey = nextKey - 2;

			return true;
        }
	};

    printRows("====== contents after test3 commit:", sqlMap);
}

test
void localTxnTest() {
    MutableSet<Sql> sqlSet = HashSet<Sql>();
    value ds = JdbcDataSource();
    ds.url="jdbc:h2:~/test";
    ds.user="sa";
    ds.password="sa";

    Sql sql = Sql(ds);

	sqlSet.add(sql);

    updateTable(sql, "DROP TABLE CEYLONKV", true);
    updateTable(sql, "CREATE TABLE CEYLONKV (key VARCHAR(255) not NULL, val VARCHAR(255), PRIMARY KEY ( key ))", true);

    insertTable(sqlSet);

	if (exists count = sql.queryForInteger("SELECT count(*) FROM CEYLONKV")) {
        assert (count == 2);
	}

    updateTable(sql, "DROP TABLE CEYLONKV", true);
}
