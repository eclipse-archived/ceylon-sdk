import ceylon.test {
    ...
}
import java.util {
    Date
}

test void insertTests() {
    assertEquals(1, sql.Update("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)")
            .execute("First", Date(), 1), "sql.update (inserting)");
    assertEquals(1, sql.Update("INSERT INTO test1(name,when,count,price,flag) VALUES (?, ?, ?, ?, ?)")
            .execute("Third", Date(), 3, 12.34, true), "sql.update (inserting)");
    
    value result = sql.Insert("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)")
            .execute("Second", Date(0), 2);
    assertEquals(1, result[0]);
    value keys = result[1];
    assertEquals(1, keys.size);
    print(keys[0]);
    if (exists k=keys[0]) {
        assertEquals(1, k.size);
        if (is Integer v=k.values.first) {
            assertTrue(v>0);
        } else { fail("No key!!!"); }
    } else { fail("No insertion keys!"); }
}