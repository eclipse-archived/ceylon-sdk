import ceylon.test {
    assertTrue,
    assertEquals,
    test
}
import ceylon.time {
    date,
    Date
}
import ceylon.time.base {
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
    january,
    december, parseDayOfWeek
}

shared test void testSucessors_Weekday() {
    assertEquals{ expected = tuesday; actual = monday.successor; compare = same; };
    assertEquals{ expected = wednesday; actual = tuesday.successor; compare = same; };
    assertEquals{ expected = thursday; actual = wednesday.successor; compare = same; };
    assertEquals{ expected = friday; actual = thursday.successor; compare = same; };
    assertEquals{ expected = saturday; actual = friday.successor; compare = same; };
    assertEquals{ expected = sunday; actual = saturday.successor; compare = same; };
    assertEquals{ expected = monday; actual = sunday.successor; compare = same; };
}

shared test void testPredecessors_Weekday() {
    assertEquals{ expected = saturday; actual = sunday.predecessor; compare = same; };
    assertEquals{ expected = friday; actual = saturday.predecessor; compare = same; };
    assertEquals{ expected = thursday; actual = friday.predecessor; compare = same; };
    assertEquals{ expected = wednesday; actual = thursday.predecessor; compare = same; };
    assertEquals{ expected = tuesday; actual = wednesday.predecessor; compare = same; };
    assertEquals{ expected = monday; actual = tuesday.predecessor; compare = same; };
    assertEquals{ expected = sunday; actual = monday.predecessor; compare = same; };
}

shared test void testComparable_monday_Weekday() {
    assertTrue( monday < tuesday, "monday < tuesday" );
    assertTrue( monday < wednesday, "monday < wednesday" );
    assertTrue( monday < thursday, "monday < thursday" );
    assertTrue( monday < friday, "monday < friday" );
    assertTrue( monday < saturday, "monday < saturday" );
    assertTrue( monday > sunday, "monday > sunday" );
}

shared test void testComparable_tuesday_Weekday() {
    assertTrue( tuesday > monday, "tuesday > monday" );
    assertTrue( tuesday < wednesday, "tuesday < wednesday" );
    assertTrue( tuesday < thursday, "tuesday < thursday" );
    assertTrue( tuesday < friday, "tuesday < friday" );
    assertTrue( tuesday < saturday, "tuesday < saturday" );
    assertTrue( tuesday > sunday, "tuesday > sunday" );
}

shared test void testComparable_wednesday_Weekday() {
    assertTrue( wednesday > monday, "wednesday > monday" );
    assertTrue( wednesday > tuesday, "wednesday > tuesday" );
    assertTrue( wednesday < thursday, "wednesday < thursday" );
    assertTrue( wednesday < friday, "wednesday < friday" );
    assertTrue( wednesday < saturday, "wednesday < saturday" );
    assertTrue( wednesday > sunday, "wednesday > sunday" );
}

shared test void testComparable_thursday_Weekday() {
    assertTrue( thursday > monday, "thursday > monday" );
    assertTrue( thursday > tuesday, "thursday > tuesday" );
    assertTrue( thursday > wednesday, "thursday > wednesday" );
    assertTrue( thursday < friday, "thursday < friday" );
    assertTrue( thursday < saturday, "thursday < saturday" );
    assertTrue( thursday > sunday, "thursday > sunday" );
}

shared test void testComparable_friday_Weekday() {
    assertTrue( friday > monday, "friday > monday" );
    assertTrue( friday > tuesday, "friday > tuesday" );
    assertTrue( friday > wednesday, "friday > wednesday" );
    assertTrue( friday > thursday, "friday > thursday" );
    assertTrue( friday < saturday, "friday < saturday" );
    assertTrue( friday > sunday, "friday > sunday" );
}

shared test void testOrdinal_Weekday() {
    value data_1982_12_13 = date( 1982, december, 13);
    value data_1983_01_01 = date( 1983, january, 1 );
    variable value dow = data_1982_12_13.dayOfWeek;
    for ( Date date in data_1982_12_13..data_1983_01_01 ) {
        assertEquals( date.dayOfWeek, dow++ );
    }
}

shared test void testParseDayOfWeek() {
    assertEquals(sunday, parseDayOfWeek("sunday"));
    assertEquals(monday, parseDayOfWeek("monday"));
    assertEquals(tuesday, parseDayOfWeek("tuesday"));
    assertEquals(wednesday, parseDayOfWeek("wednesday"));
    assertEquals(thursday, parseDayOfWeek("thursday"));
    assertEquals(friday, parseDayOfWeek("friday"));
    assertEquals(saturday, parseDayOfWeek("saturday"));

    assertEquals(null, parseDayOfWeek("saturdayyy"));
    assertEquals(monday, parseDayOfWeek("MoNdAy"));
}

// Range test
shared test void dayOfWeekRangeWrapsAroundSaturday() => assertEquals {
    actual = [for (dow in monday..sunday) dow];
    expected = [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
};

// Enumerable tests:
shared test void dayOfWeekOffsetsAlwaysIncreasing1() => assertEquals {
    actual = [for (dow in monday..sunday) dow.offset(monday)];
    expected = [0, 1, 2, 3, 4, 5, 6];
};

shared test void dayOfWeekOffsetsAlwaysIncreasing2() => assertEquals {
    actual = [for (dow in monday..sunday) dow.offset(sunday)];
    expected = [1, 2, 3, 4, 5, 6, 0];
};

shared test void dayOfWeekOffsetsAlwaysIncreasing3() => assertEquals {
    actual = [for (dow in monday..sunday) monday.offset(dow)];
    expected = [0, 6, 5, 4, 3, 2, 1];
};

shared test void dayOfWeekOffsetsAlwaysIncreasing4() => assertEquals {
    actual = [for (dow in monday..sunday) sunday.offset(dow)];
    expected = [6, 5, 4, 3, 2, 1, 0];
};

shared test void dayOfWeekNeigbours() => assertEquals {
    actual = [for (i in -7..7) monday.neighbour(i)];
    expected = [monday, tuesday, wednesday, thursday, friday, saturday, sunday, monday, tuesday, wednesday, thursday, friday, saturday, sunday, monday];
};

shared void run() {
    print((monday..sunday).size);
    print([for (dow in monday..sunday) monday.offset(dow)]);
    print([for (dow in monday..sunday) dow.offset(monday)]);
}
