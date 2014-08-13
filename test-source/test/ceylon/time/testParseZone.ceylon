import ceylon.test {
    test,
    assertTrue,
    assertEquals
}
import ceylon.time.timezone.model {
    ZoneTimeline,
    standardZoneRule,
    standardTimeDefinition,
    ZoneUntil,
    AbbreviationZoneFormat,
    ReplacedZoneFormat
}
import ceylon.time {
    Instant,
    Period
}

List<ZoneTimeline>? americaManausZone = provider.zones.get("America/Manaus");
List<ZoneTimeline>? americaArgentinaUshuaiaZone = provider.zones.get("America/Argentina/Ushuaia");

//Zone America/Manaus    -4:00:04 -    LMT    1914
        //              -4:00    Brazil    AM%sT    1988 Sep 12
        //              -4:00    -    AMT    1993 Sep 28
        //              -4:00    Brazil    AM%sT    1994 Sep 22
        //              -4:00    -    AMT
test void testParseZoneAmericaManaus() {
    assert (exists americaManausZone);
    assertEquals(americaManausZone.size, 5);
    
    value zone1 =
            ZoneTimeline {
        offset = Period{ hours = -4; seconds = -4; };
        zoneRule = standardZoneRule;
        format = AbbreviationZoneFormat("LMT");
        ZoneUntil(Instant(-1767225600000), standardTimeDefinition); // 1914 jan 01
    };
    
    value zone2 =
            ZoneTimeline {
        offset = Period{ hours = -4; };
        zoneRule = standardZoneRule;
        format = ReplacedZoneFormat("AM%sT");
        ZoneUntil(Instant(590025600000), standardTimeDefinition); // 1988 Sep 12
    };
    
    value zone3 =
            ZoneTimeline {
        offset = Period{ hours = -4; };
        zoneRule = standardZoneRule;
        format = AbbreviationZoneFormat("AMT");
        ZoneUntil(Instant(749174400000), standardTimeDefinition); // 1993 Sep 28
    };
    
    value zone4 =
            ZoneTimeline {
        offset = Period{ hours = -4; };
        zoneRule = standardZoneRule;
        format = ReplacedZoneFormat("AM%sT");
        ZoneUntil(Instant(780192000000), standardTimeDefinition); // 1994 Sep 22
    };
    
    value zone5 =
            ZoneTimeline {
        offset = Period{ hours = -4; };
        zoneRule = standardZoneRule;
        format = AbbreviationZoneFormat("AMT");
        ZoneUntil(Instant(9007174598400000), standardTimeDefinition); // maximumYear january 1
    };
    
    assertTrue(americaManausZone.contains(zone1));
    assertTrue(americaManausZone.contains(zone2));
    assertTrue(americaManausZone.contains(zone3));
    assertTrue(americaManausZone.contains(zone4));
    assertTrue(americaManausZone.contains(zone5));
    
    
    
}

//Zone America/Argentina/Ushuaia -4:33:12 - LMT 1894 Oct 31
//                                 -4:16:48 -    CMT    1920 May # Cordoba Mean Time
//                                 -4:00    -    ART    1930 Dec
//                                 -4:00    Arg    AR%sT    1969 Oct  5
//                                 -3:00    Arg    AR%sT    1999 Oct  3
//                                 -4:00    Arg    AR%sT    2000 Mar  3
//                                 -3:00    -    ART    2004 May 30
//                                 -4:00    -    WART    2004 Jun 20
//                                 -3:00    Arg    AR%sT    2008 Oct 18
//                                 -3:00    -    ART
test void testParseZoneAmericaArgentinaUshuaia() {
    assert (exists americaArgentinaUshuaiaZone);
    
    value zone =
            ZoneTimeline {
        offset = Period{ hours = -4; minutes = -33; seconds = -12; };
        zoneRule = standardZoneRule;
        format = AbbreviationZoneFormat("LMT");
        ZoneUntil(Instant(-2372112000000), standardTimeDefinition); // 1894 Oct 31
    };
    
    assertTrue(americaArgentinaUshuaiaZone.contains(zone));
}
