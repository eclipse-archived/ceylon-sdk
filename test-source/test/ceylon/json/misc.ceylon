import ceylon.json { ... }
import ceylon.test { ... }

shared object miscJsonTests {
    shared test void equalObjects() {
        assertTrue(JsonObject { "1"->1,"2"->2,"3"->3 } == map { "1"->1,"2"->2,"3"->3 });
        assertTrue(map { "1"->1,"2"->2,"3"->3 } == JsonObject { "1"->1,"2"->2,"3"->3 });
        assertFalse(JsonObject { "1"->1,"2"->2 } == map { "1"->1,"2"->2,"3"->3 });
        assertFalse(map { "1"->1,"2"->2,"3"->3 } == JsonObject { "1"->1,"2"->2 });
    }
    shared test void equalArrays() {
        assertTrue(JsonArray { 1, 2, 3 } == [1, 2, 3]);
        assertTrue([1, 2, 3] == JsonArray { 1, 2, 3 });
        assertFalse(JsonArray { 1, 2 } == [1, 2, 3]);
        assertFalse([1, 2, 3] == JsonArray { 1, 2 });
    }
}
