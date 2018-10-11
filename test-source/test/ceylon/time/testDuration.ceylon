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
        => assertEquals { actual = scale ** Duration(1000); expected = expectedDuration; };

shared test void testPlus()
        => assertEquals { actual = Duration(-4567) + Duration(4567); expected= Duration.zero; };

shared test void testInv()
        => assertEquals { actual = -Duration(99); expected= Duration(-99); };

shared test void testInvZero()
        => assertEquals { actual = -Duration.zero; expected= Duration.zero; };

shared test void testMinus()
        => assertEquals { actual = Duration(4567) - Duration(4567); expected= Duration.zero; };
        
shared test void testCompare()
        => assertEquals { actual = Duration(345) <=> Duration(4567); expected= Comparison.smaller; };
            
shared test void testCompare()
        => assertEquals { actual = Duration(3450) <=> Duration(456); expected= Comparison.greater; };
                
shared test void testCompare()
        => assertEquals { actual = Duration(345) <=> Duration(345); expected= Comparison.equal; };
