import ceylon.test {
    ...
}
import java.util { Date }

test void transactionTests() {
    sql.transaction(() {
        sql.Insert("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)")
                    .execute("Hello", Date(0), 3);
        value count = sql.Update("UPDATE test1 set count=? WHERE name=?").execute(5, "Hello");
        assert (count==1);
        return true;
    });
    try (sql.Transaction()) {
        value count = sql.Update("DELETE FROM test1 WHERE name=?").execute("Hello");
        assert (count==1);
    }
}
