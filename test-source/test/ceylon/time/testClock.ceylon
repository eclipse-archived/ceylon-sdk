import ceylon.test { test, assertEquals }
import ceylon.time { systemTime, Instant, fixedTime, offsetTime, Duration }
import ceylon.time.base { milliseconds }

test shared void testSystemTimeString() {
    assertEquals("System time", systemTime.string);
}

test shared void testFixedTimeString() {
    assertEquals("Fixed to 2013-11-07T20:52:10.000Z", fixedTime(Instant(1383857530000)).string);
    assertEquals("Fixed to 2013-11-07T20:52:10.000Z", fixedTime(1383857530000).string);
}

test shared void testOffsetTimeString() {
    assertEquals("Offset of PT1H from ``systemTime.string``", offsetTime(systemTime, Duration(milliseconds.perHour)).string);
}
