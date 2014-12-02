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

shared test void testEnumeratedDayOfWeek() {
    value resultMondayToSunday = [for(day in monday..sunday) day];
    assertEquals(resultMondayToSunday[0], monday);
    assertEquals(resultMondayToSunday[1], tuesday);
    assertEquals(resultMondayToSunday[2], wednesday);
    assertEquals(resultMondayToSunday[3], thursday);
    assertEquals(resultMondayToSunday[4], friday);
    assertEquals(resultMondayToSunday[5], saturday);
    assertEquals(resultMondayToSunday[6], sunday);
    assertEquals(resultMondayToSunday[7], null);
    
    value resultSundayToMonday = [for(day in sunday..monday) day];
    assertEquals(resultSundayToMonday[0], sunday);
    assertEquals(resultSundayToMonday[1], monday);
    assertEquals(resultSundayToMonday[2], null);
    
    value resultSundayToSunday = [for(day in sunday..sunday) day];
    assertEquals(resultSundayToSunday[0], sunday);
    assertEquals(resultSundayToSunday[1], null);
    
    value resultSundayToSaturday = [for(day in sunday..saturday) day];
    assertEquals(resultSundayToSaturday[0], sunday);
    assertEquals(resultSundayToSaturday[1], monday);
    assertEquals(resultSundayToSaturday[2], tuesday);
    assertEquals(resultSundayToSaturday[3], wednesday);
    assertEquals(resultSundayToSaturday[4], thursday);
    assertEquals(resultSundayToSaturday[5], friday);
    assertEquals(resultSundayToSaturday[6], saturday);
    assertEquals(resultSundayToSaturday[7], null);
    
    value resultSaturdayToSunday = [for(day in saturday..sunday) day];
    assertEquals(resultSaturdayToSunday[0], saturday);
    assertEquals(resultSaturdayToSunday[1], sunday);
    assertEquals(resultSaturdayToSunday[2], null);
    
    assertEquals(sunday.offset(sunday),     0);
    assertEquals(sunday.offset(monday),     1);
    assertEquals(sunday.offset(tuesday),    2);
    assertEquals(sunday.offset(wednesday),  3);
    assertEquals(sunday.offset(thursday),   4);
    assertEquals(sunday.offset(friday),     5);
    assertEquals(sunday.offset(saturday),   6);
    
    assertEquals(saturday.offset(sunday),    6);
    assertEquals(saturday.offset(monday),    5);
    assertEquals(saturday.offset(tuesday),   4);
    assertEquals(saturday.offset(wednesday), 3);
    assertEquals(saturday.offset(thursday),  2);
    assertEquals(saturday.offset(friday),    1);
    assertEquals(saturday.offset(saturday),  0);
    
    value i = 1;
    assertEquals(sunday.neighbour(0), sunday);
    assertEquals(sunday.neighbour(i+1), sunday.neighbour(i).successor);
    assertEquals(sunday.neighbour(i-1), sunday.neighbour(i).predecessor);
}

