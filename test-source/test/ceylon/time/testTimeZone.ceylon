import ceylon.time { now, fixedTime, Clock, date, time, dateTime, Instant }
import ceylon.test { assertEquals }
import ceylon.time.base { may, ms = milliseconds }
import ceylon.time.timezone { timeZone, OffsetTimeZone, TimeZone }

Clock utc_may_11_2013_18_30_30_500 = fixedTime {
    instant = date{ 
                    day = 11; 
                    month = may; 
                    year= 2013;
              }.at( 
                time{ 
                        hours = 18; 
                        minutes = 30;
                        seconds = 30; 
                        milliseconds = 500; 
                    } ).instant(timeZone.utc).millisecondsOfEpoch;};

Clock utc_may_12_2013_02_30_30_500 = fixedTime {
    instant = date{ 
                    day = 12; 
                    month = may; 
                    year= 2013;
              }.at( 
                      time{ 
                      hours = 02; 
                      minutes = 30;
                      seconds = 30; 
                      milliseconds = 500; 
                   } ).instant(timeZone.utc).millisecondsOfEpoch;};

TimeZone manaus = OffsetTimeZone(-4 * ms.perHour);

shared void testManausZoneInstantTimeZone() {
    assertEquals( time(14, 30, 30, 500),  now( utc_may_11_2013_18_30_30_500 ).time(manaus) );
    assertEquals( date(2013, may, 11),  now( utc_may_11_2013_18_30_30_500 ).date(manaus) );
    assertEquals( dateTime(2013, may, 11, 14, 30, 30, 500),  now( utc_may_11_2013_18_30_30_500 ).dateTime(manaus) );
    
    assertEquals( time(22, 30, 30, 500),  now( utc_may_12_2013_02_30_30_500 ).time(manaus) );
    assertEquals( date(2013, may, 11),  now( utc_may_12_2013_02_30_30_500 ).date(manaus) );
    assertEquals( dateTime(2013, may, 11, 22, 30, 30, 500),  now( utc_may_12_2013_02_30_30_500 ).dateTime(manaus) );
    
    
    assertEquals( date(2013, may, 11), Instant( utc_may_12_2013_02_30_30_500.milliseconds() ).date(manaus) );
    
    assertEquals( Instant( utc_may_12_2013_02_30_30_500.milliseconds() ), utc_may_12_2013_02_30_30_500.instant().dateTime(manaus).instant(manaus) );
}

shared void testUtcInstantTimeZone() {
    assertEquals( time(18, 30, 30, 500),  now( utc_may_11_2013_18_30_30_500 ).time(timeZone.utc) );
    assertEquals( date(2013, may, 11),  now( utc_may_11_2013_18_30_30_500 ).date(timeZone.utc) );
    assertEquals( dateTime(2013, may, 11, 18, 30, 30, 500),  now( utc_may_11_2013_18_30_30_500 ).dateTime(timeZone.utc) );
    
    assertEquals( time(02, 30, 30, 500),  now( utc_may_12_2013_02_30_30_500 ).time(timeZone.utc) );
    assertEquals( date(2013, may, 12),  now( utc_may_12_2013_02_30_30_500 ).date(timeZone.utc) );
    assertEquals( dateTime(2013, may, 12, 02, 30, 30, 500),  now( utc_may_12_2013_02_30_30_500 ).dateTime(timeZone.utc) );
    
    
    assertEquals( date(2013, may, 12), Instant( utc_may_12_2013_02_30_30_500.milliseconds() ).date(timeZone.utc) );
    
    assertEquals( Instant( utc_may_12_2013_02_30_30_500.milliseconds() ), utc_may_12_2013_02_30_30_500.instant().dateTime(timeZone.utc).instant(timeZone.utc) );
}
