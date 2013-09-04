import ceylon.test { assertEquals }
import ceylon.time { Duration }

shared void testScalableDuration() {
    //Rules suggested by scalable interface
    Duration duration = Duration(1000);    
    assertEquals(Duration(1000),   1 ** duration);
    assertEquals(Duration(-1000), -1 ** duration);
    assertEquals(Duration(0),      0 ** duration);
    assertEquals(Duration(2000),   2 ** duration);

    assertEquals( Duration(4000), 4 ** duration);
}