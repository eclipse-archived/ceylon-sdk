import ceylon.test { ... }
import ceylon.math.decimal { decimalNumber }
import java.util { Date }

void queryTests() {
    value q1 = sql.rows("SELECT * FROM test1 WHERE name=?");
    value r1 = q1(["First"]);
    assertTrue(r1.size > 0, "Rows with 'First");
    value r2 = q1(["Second"]);
    assertTrue(r2.size > 0, "Rows with 'Second'");
    assertFalse(q1(["whatever"]) nonempty, "'whatever' should return empty");
    assertTrue(sql.rows("SELECT * FROM test1")({}).size>=3, "all rows");
    value q2 = sql.rows("SELECT * FROM test1", 1, 2)({});
    assertEquals(1, q2.size, "rows with limit and offset");
    if (exists row1 = sql.firstRow("SELECT * FROM test1 ORDER BY row_id")) {
        if (exists c=row1["name"]) {
            assertEquals("First", c, "firstRow");
        } else { fail("first row"); }
    } else { fail("firstRow"); }
    if (exists v = sql.queryForInteger("SELECT count FROM test1 WHERE count>0")) {
        assertTrue(v > 0, "queryForInteger");
    } else { fail("queryForInteger"); }
    if (exists v = sql.queryForFloat("SELECT price FROM test1 WHERE price >12")) {
        assertTrue(v > 12.30, "queryForFloat");
    } else { fail("queryForFloat"); }
    if (exists v = sql.queryForBoolean("SELECT flag FROM test1 WHERE flag=true")) {
        assertTrue(v, "queryForBoolean");
    } else { fail("queryForBoolean"); }
    if (exists v = sql.queryForDecimal("SELECT price FROM test1 WHERE price IS NOT NULL")) {
        assertTrue(v > decimalNumber(0), "queryForDecimal");
    } else { fail("queryForDecimal"); }
    /*if (exists v = sql.queryForWhole("SELECT count FROM test1 WHERE count>0")) {
        assertTrue(v > 0, "queryForWhole");
    } else { fail("queryForWhole"); }*/
    if (exists v = sql.queryForString("SELECT name FROM test1 WHERE name like 'Fir%'")) {
        assertEquals("First", v, "queryForString");
    } else { fail("queryForString"); }
    /*if (exists v = sql.queryForValue<String>("SELECT name FROM test1 WHERE name IS NOT NULL")) {
        assertTrue(v.size>0, "queryForValue");
    } else { fail("queryForValue"); }*/
}
