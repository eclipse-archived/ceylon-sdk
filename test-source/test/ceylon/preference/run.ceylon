import ceylon.preference { userPreferences, Preference }
import ceylon.test { test, assertEquals, assertNull, assertNotNull, fail, assertTrue }
test void run() {
    
    // TODO Tests for JS - EphemeralPreferencesMap
    assertEquals(runtime.name, "jvm");
    
    variable Preference? p;
    userPreferences(`module ceylon.preference`).clear();
    
    p = userPreferences(`module ceylon.preference`).put("test", "one");
    assertNull(p); // no previous value
    p = userPreferences(`module ceylon.preference`).get("test");
    assertEquals(p, "one");
    p = userPreferences(`module ceylon.preference`).put("test", "two");
    assertNotNull(p);
    assertEquals(p, "one"); // ejected previous value

    p = userPreferences(`module ceylon.preference`).put("testB", true);
    Preference? q = userPreferences(`module ceylon.preference`).get("testB");
    if (exists q, is Boolean q) {
        assert(true, q);
    } else {
        fail();
    }
    
    Float? testF = parseFloat("8");
    if (exists testF) {
        userPreferences(`module ceylon.preference`).put("testF", testF);
        assertEquals(testF, userPreferences(`module ceylon.preference`).get("testF"));
    }

    Integer? testI = parseInteger("33");
    if (exists testI) {
        userPreferences(`module ceylon.preference`).put("testI", testI);
        assertEquals(testI, userPreferences(`module ceylon.preference`).get("testI"));
    }
            
    value iter = userPreferences(`module ceylon.preference`).iterator();
    variable Integer count = 0;
    while (! is Finished e = iter.next()) {
       count++;
    }
    assertEquals(4, count);
    userPreferences(`module ceylon.preference`).clear();
    assertTrue(userPreferences(`module ceylon.preference`).iterator().next() is Finished );
}