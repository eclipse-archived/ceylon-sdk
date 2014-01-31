import ceylon.test {
    ...
}
import java.util { 
    Date 
}

test void batchUpdateTest() {
    value millisPerDay = 24*60*60*1000;
    for (i in 1..10) {
        sql.Insert("INSERT INTO test1(name, when, count) VALUES (?, ?, ?)")
                .execute("name``i``", Date(i*millisPerDay), i);
    }
    
    value count = sql.Select("SELECT COUNT(*) FROM test1")
            .execute()[0]?.values?.first;
    assert (is Integer count, count == 10);
    
    value count2 = sql.Select("SELECT COUNT(*) FROM test1")
            .singleValue<Integer>();
    assert (count2 == 10);
    
    value result = sql.Update("UPDATE test1 SET name = ? WHERE count = ?")
            .executeBatch { for(i in 1..10) ["name``i*i``", i] };
    assertEquals(result.size, 10);
    assertEquals(result[0], 1);
    assertEquals(result[1], 1);
    assertEquals(result[2], 1);
    
    value rows = sql.Select("SELECT * FROM test1 ORDER BY count")
            .execute();
    assertEquals(rows.size, 10);
    assertEquals(rows[0]?.get("name"), "name1");
    assertEquals(rows[1]?.get("name"), "name4");
    assertEquals(rows[2]?.get("name"), "name9");
}