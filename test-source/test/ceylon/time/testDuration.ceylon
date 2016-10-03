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
