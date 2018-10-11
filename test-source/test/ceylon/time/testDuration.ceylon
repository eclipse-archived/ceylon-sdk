import ceylon.test {
    assertEquals,
    test,
    parameters
}
import ceylon.time {
    Duration
}

[[Duration, Integer]*] scalableDurationTests = [
    for (i in { -1, 0, 1, 2, 4 })
        [Duration(i*1000), i]
];
parameters (`value scalableDurationTests`)
shared test void testScalableDuration(Duration expectedDuration, Integer scale)
        => assertEquals { expected = expectedDuration; actual = scale ** Duration(1000); };

shared test void testPlus()
        => assertEquals (Duration(-4567) + Duration(4567), Duration.zero);

shared test void testInv()
        => assertEquals (-Duration(99), Duration(-99));

shared test void testInvZero()
        => assertEquals (-Duration.zero, Duration.zero);

shared test void testMinus()
        => assertEquals (Duration(4567) - Duration(4567), Duration.zero);
        
shared test void testCompare()
        => assertEquals (Duration(345) <=> Duration(4567), Comparison.smaller);
            
shared test void testCompare()
        => assertEquals (Duration(3450) <=> Duration(456), Comparison.greater);
                
shared test void testCompare()
        => assertEquals (Duration(345) <=> Duration(345), Comparison.equal);
