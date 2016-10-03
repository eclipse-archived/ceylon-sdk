import ceylon.test {
    assertEquals,
    test,
    parameters
}
import ceylon.time.internal {
    overlap,
    gap
}

Integer a = 1;
Integer b = 2;
Integer c = 3;
Integer d = 4;

[<Integer[2]|[]->[Integer[2][2]*]>*] overlap_tests = [
    empty->[
        [[a, b], [c, d]],
        [[b, a], [c, d]],
        [[a, b], [d, c]],
        [[b, a], [d, c]],
        [[c, d], [a, b]],
        [[d, c], [a, b]],
        [[c, d], [b, a]],
        [[d, c], [b, a]]
    ],
    [b, c]->[
        [[a, c], [b, d]],
        [[c, a], [b, d]],
        [[a, c], [d, b]],
        [[c, a], [d, b]],
        [[b, d], [a, c]],
        [[d, b], [a, c]],
        [[b, d], [c, a]],
        [[d, b], [c, a]]
    ],
    [b, b]->[
        [[a, b], [b, c]],
        [[b, a], [b, c]],
        [[a, b], [c, b]],
        [[b, a], [c, b]],
        [[b, c], [a, b]],
        [[c, b], [a, b]],
        [[b, c], [b, a]],
        [[c, b], [b, a]]
    ],
    [b, c]->[
        [[a, d], [b, c]],
        [[d, a], [b, c]],
        [[a, d], [c, b]],
        [[d, a], [c, b]],
        [[b, c], [a, d]],
        [[c, b], [a, d]],
        [[b, c], [d, a]],
        [[c, b], [d, a]]
    ]
];
[[Integer[2]|[], Integer[2], Integer[2]]*] overlap_tests_params
        => [for (overlap->ranges in overlap_tests) for ([first, second] in ranges) [overlap, first, second]];

parameters (`value overlap_tests_params`)
shared test void test_overlap(Integer[2]|[] expectedOverlap, Integer[2] first, Integer[2] second)
        => assertEquals {
            expected = expectedOverlap;
            actual = overlap(first, second);
        };

[<Integer[2]|[]->[Integer[2][2]*]>*] gap_tests = [
    empty->[
        [[a, c], [b, d]],
        [[c, a], [b, d]],
        [[a, c], [d, b]],
        [[c, a], [d, b]],
        [[b, d], [a, c]],
        [[d, b], [a, c]],
        [[b, d], [c, a]],
        [[d, b], [c, a]]
    ],
    [b, c]->[
        [[a, b], [c, d]],
        [[b, a], [c, d]],
        [[a, b], [d, c]],
        [[b, a], [d, c]],
        [[c, d], [a, b]],
        [[d, c], [a, b]],
        [[c, d], [b, a]],
        [[d, c], [b, a]]
    ],
    empty->[
        [[a, b], [b, c]],
        [[b, a], [b, c]],
        [[a, b], [c, b]],
        [[b, a], [c, b]],
        [[b, c], [a, b]],
        [[c, b], [a, b]],
        [[b, c], [b, a]],
        [[c, b], [b, a]]
    ]
];
[[Integer[2]|[], Integer[2], Integer[2]]*] gap_tests_params
        => [for (gap->ranges in gap_tests) for ([first, second] in ranges) [gap, first, second]];

parameters (`value gap_tests_params`)
shared test void test_gap(Integer[2]|[] expectedGap, Integer[2] first, Integer[2] second)
        => assertEquals {
            expected = expectedGap;
            actual = gap(first, second);
        };
