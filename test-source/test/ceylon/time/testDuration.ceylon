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
        => assertEquals (Duration.zero, Duration(-4567) + Duration(4567));

shared test void testInv()
        => assertEquals (Duration(-99), -Duration(99));

shared test void testInvZero()
        => assertEquals (Duration.zero, -Duration.zero);

shared test void testMinus()
        => assertEquals (Duration.zero, Duration(4567) - Duration(4567));
        
shared test void testCompare()
        => assertEquals (Comparison.smaller, Duration(345) <=> Duration(4567));
            
shared test void testCompare()
        => assertEquals (Comparison.greater, Duration(3450) <=> Duration(456));
                
shared test void testCompare()
        => assertEquals (Comparison.equal, Duration(345) <=> Duration(345));
