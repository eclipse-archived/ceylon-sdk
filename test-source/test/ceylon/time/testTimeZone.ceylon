import ceylon.test { assertEquals, assertTrue, assertFalse, test }
import ceylon.time { date, time, dateTime, Instant, Period, now }
import ceylon.time.base { september, milliseconds }
import ceylon.time.timezone { timeZone, OffsetTimeZone }


shared test void offsetTimeZoneAlwaysReturnsConstantOffset() {
    value timeZone = OffsetTimeZone(2222);
    
    assertEquals { expected = 2222; actual = timeZone.offset(now()); };
}

shared test void testDateTimeToInstantUsesOffset() {
    value localDate = date(2013, september, 02);

    assertEquals {
        expected = localDate.at(time(12, 00)).instant( timeZone.utc );
        actual = localDate.at(time(15, 00)).instant( timeZone.offset( +3 ) );
        "Should apply positive timezone offset";
    };
    
    assertEquals {
        expected = localDate.at(time(12, 00)).instant( timeZone.utc );
        actual = localDate.at(time( 9, 00)).instant( timeZone.offset( -3 ) );
        "Should apply negative timezone offset";
    };
}

shared test void testInstantToTimeUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals { expected = time(12, 00); actual = instant.time( timeZone.utc ); };
    assertEquals { expected = time(15, 00); actual = instant.time( timeZone.offset( 3) ); };
    assertEquals { expected = time( 9, 00); actual = instant.time( timeZone.offset(-3) ); };
}

shared test void testInstantToDateUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals { expected = date(2013, september, 02); actual = instant.date( timeZone.utc ); };
    assertEquals { expected = date(2013, september, 03); actual = instant.plus( Period{ hours = 2; }).date( timeZone.offset( 12) ); };
    assertEquals { expected = date(2013, september, 01); actual = instant.minus(Period{ hours = 2; }).date( timeZone.offset(-12) ); };
}

shared test void testInstantToDateTimeUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals { expected = dateTime(2013, september, 02, 12, 00); actual = instant.dateTime( timeZone.utc ); };
    assertEquals { expected = dateTime(2013, september, 03,  2, 00); actual = instant.plus( Period{ hours = 2; }).dateTime( timeZone.offset( 12) ); };
    assertEquals { expected = dateTime(2013, september, 01, 22, 00); actual = instant.minus(Period{ hours = 2; }).dateTime( timeZone.offset(-12) ); };
}

shared test void testEqualsAndHashOffsetTimeZone() {
    OffsetTimeZone instanceA_1 = OffsetTimeZone(2000);
    OffsetTimeZone instanceA_2 = OffsetTimeZone(2000);
    OffsetTimeZone instanceB_1 = OffsetTimeZone(1);
    OffsetTimeZone instanceB_2 = OffsetTimeZone(1);

    assertTrue(instanceA_1 == instanceA_2);
    assertTrue(instanceA_1.hash == instanceA_2.hash);

    assertTrue(instanceB_1 == instanceB_2);
    assertTrue(instanceB_1.hash == instanceB_2.hash);

    assertFalse(instanceA_1 == instanceB_1);
    assertFalse(instanceA_2 == instanceB_1);
    assertFalse(instanceA_1.hash == instanceB_1.hash);
    assertFalse(instanceA_2.hash == instanceB_1.hash);
}

shared test void testTimeZoneString() {
    assertEquals { expected = "+10:09"; actual = OffsetTimeZone(10 * milliseconds.perHour + 9 * milliseconds.perMinute).string; };
    assertEquals { expected = "-05:20"; actual = OffsetTimeZone(-5 * milliseconds.perHour - 20 * milliseconds.perMinute).string; };
    assertEquals { expected = "+00:00"; actual = OffsetTimeZone(0).string; };
}

shared test void offsetTimeZoneToString(){
    assertEquals { expected = "Z"; actual = timeZone.utc.string; };
}
