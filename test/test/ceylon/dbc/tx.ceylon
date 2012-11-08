import com.redhat.ceylon.sdk.test{...}

void transactionTests() {
    if (exists count0 = sql.queryForInteger("SELECT count(*) FROM test1")) {
        //Rollback
        sql.transaction {
            function do() {
                value erased = sql.update("DELETE FROM test1");
                assertEquals(count0, erased, "deleted all rows");
                return false;
            }
        };
        if (exists count1 = sql.queryForInteger("SELECT count(*) FROM test1")) {
            assertEquals(count0, count1, "rollback");
        }
        sql.transaction(() sql.update("DELETE FROM test1")==count0);
        if (exists count1 = sql.queryForInteger("SELECT count(*) FROM test1")) {
            assertEquals(0, count1, "commit");
        }
    }
}
