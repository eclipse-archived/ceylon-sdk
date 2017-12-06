import ceylon.test { test, assertEquals }
import ceylon.time { systemTime, Instant, fixedTime, offsetTime, Duration }
import ceylon.time.base { milliseconds }

test shared void testSystemTimeString() {
    assertEquals { expected = "System time"; actual = systemTime.string; };
}

test shared void testFixedTimeString() {
    assertEquals { expected = "Fixed to 2013-11-07T20:52:10.000Z"; actual = fixedTime(Instant(1383857530000)).string; };
    assertEquals { expected = "Fixed to 2013-11-07T20:52:10.000Z"; actual = fixedTime(1383857530000).string; };
}

test shared void testOffsetTimeString() {
    assertEquals { expected = "Offset of PT1H from ``systemTime.string``"; actual = offsetTime(systemTime, Duration(milliseconds.perHour)).string; };
}
