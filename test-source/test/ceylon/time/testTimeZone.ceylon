import ceylon.test {
    assertEquals,
    assertTrue,
    assertFalse,
    test
}
import ceylon.time {
    date,
    time,
    dateTime,
    Instant,
    Period
}
import ceylon.time.base {
    september
}
import ceylon.time.timezone {
    timeZone,
    OffsetTimeZone
}

test void testDateTimeToInstantUsesOffset() {
    value localDate = date(2013, september, 02);
    
    assertEquals( localDate.at(time(12, 00)).instant( timeZone.utc ), 
                  localDate.at(time(15, 00)).instant( timeZone.offset( +3 ) ),
                  "Should apply positive timezone offset" );
    
    assertEquals( localDate.at(time(12, 00)).instant( timeZone.utc ), 
                  localDate.at(time( 9, 00)).instant( timeZone.offset( -3 ) ),
                  "Should apply negative timezone offset" );
}

test void testInstantToTimeUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals( time(12, 00), instant.time( timeZone.utc ) );
    assertEquals( time(15, 00), instant.time( timeZone.offset( 3) ) );
    assertEquals( time( 9, 00), instant.time( timeZone.offset(-3) ) );
}


test void testInstantToDateUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals( date(2013, september, 02), instant.date( timeZone.utc ) );
    assertEquals( date(2013, september, 03), instant.plus( Period{ hours = 2; }).date( timeZone.offset( 12) ) );
    assertEquals( date(2013, september, 01), instant.minus(Period{ hours = 2; }).date( timeZone.offset(-12) ) );
}

test void testInstantToDateTimeUsesOffset() {
    value instant = Instant( 1378123200000 ); // September 2. 2013 12:00 UTC
    
    assertEquals( dateTime(2013, september, 02, 12, 00), instant.dateTime( timeZone.utc ) );
    assertEquals( dateTime(2013, september, 03,  2, 00), instant.plus( Period{ hours = 2; }).dateTime( timeZone.offset( 12) ) );
    assertEquals( dateTime(2013, september, 01, 22, 00), instant.minus(Period{ hours = 2; }).dateTime( timeZone.offset(-12) ) );
}

test void testEqualsAndHashOffsetTimeZone() {
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
