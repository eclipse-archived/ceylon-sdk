import ceylon.test { ... }
import java.util { Date }

void insertTests() {
    assertEquals(1, sql.update("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)", "First", Date(), 1), "sql.update (inserting)");
    assertEquals(1, sql.update("INSERT INTO test1(name,when,count,price,flag) VALUES (?, ?, ?, ?, ?)", "Third", Date(), 3, 12.34, true), "sql.update (inserting)");
    value keys = sql.insert("INSERT INTO test1(name,when,count) VALUES (?, ?, ?)", "Second", Date(0), 2);
    assertEquals(1, keys.size);
    if (exists k=keys[0]) {
        assertEquals(1, k.size);
        if (is Integer v=k[0]) {
            assertTrue(v>0);
        } else { fail("No key!!!"); }
    } else { fail("No insertion keys!"); }
}
