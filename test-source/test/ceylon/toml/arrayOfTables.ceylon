import ceylon.test {
    test, assertEquals, assertTrue
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object arrayOfTables {

    shared test void empty() {
        assertEquals {
            actual = parseToml {
                 """[[table_1]]""";
            };
            expected = map {
                "table_1" -> [map {}]
            };
        };

        assertEquals {
            actual = parseToml {
                 """[[table_1]]
                    [[table_1]]
                 """;
            };
            expected = map {
                "table_1" -> [map {}, map {}]
            };
        };
    }

    shared test void notEmpty() {
        assertEquals {
            actual = parseToml {
                 """[[table]]
                    t11 = 11
                    t12 = 12
                    [[table]]
                    t21 = 21
                    t22 = 22
                 """;
            };
            expected = map {
                "table" -> [
                    map {
                        "t11" -> 11,
                        "t12" -> 12
                    },
                    map {
                        "t21" -> 21,
                        "t22" -> 22
                    }
                ]
            };
        };
    }

    shared test void twoArraysMixedOrder() {
        assertEquals {
            actual = parseToml {
                 """[[table_a]]
                    ta11 = 11
                    ta12 = 12

                    [[table_b]]
                    tb11 = 11
                    tb12 = 12

                    [[table_a]]
                    ta21 = 21
                    ta22 = 22

                    [[table_b]]
                    tb21 = 21
                    tb22 = 22
                 """;
            };
            expected = map {
                "table_a" -> [
                    map {
                        "ta11" -> 11,
                        "ta12" -> 12
                    },
                    map {
                        "ta21" -> 21,
                        "ta22" -> 22
                    }
                ],
                "table_b" -> [
                    map {
                        "tb11" -> 11,
                        "tb12" -> 12
                    },
                    map {
                        "tb21" -> 21,
                        "tb22" -> 22
                    }
                ]
            };
        };
    }

    shared test void nested() {
        assertEquals {
            actual = parseToml {
                 """[outer]
                    o = 0

                    [[outer.table_a]]
                    ta11 = 11
                    ta12 = 12

                    [[outer.table_a]]
                    ta21 = 21
                    ta22 = 22
                 """;
            };
            expected = map {
                "outer" -> map {
                    "o" -> 0,
                    "table_a" -> [
                        map {
                            "ta11" -> 11,
                            "ta12" -> 12
                        },
                        map {
                            "ta21" -> 21,
                            "ta22" -> 22
                        }
                    ]
                }
            };
        };
    }

    shared test void nestedArrayFirst() {
        assertEquals {
            actual = parseToml {
                 """[[outer.table_a]]
                    ta11 = 11
                    ta12 = 12

                    [outer]
                    o = 0

                    [[outer.table_a]]
                    ta21 = 21
                    ta22 = 22
                 """;
            };
            expected = map {
                "outer" -> map {
                    "o" -> 0,
                    "table_a" -> [
                        map {
                            "ta11" -> 11,
                            "ta12" -> 12
                        },
                        map {
                            "ta21" -> 21,
                            "ta22" -> 22
                        }
                    ]
                }
            };
        };
    }

    shared test void addToTableInArray() {
        assertEquals {
            actual = parseToml {
                 """
                    [[k1.k2]]
                    a = 1
                    [[k1.k2.k3]]
                    a = 2
                 """;
            };
            expected = map {
                "k1" -> map {
                    "k2" -> [
                        map {
                            "a" -> 1,
                            "k3" -> [
                                map {
                                    "a" -> 2
                                }
                            ]
                        }
                    ]
                }
            };
        };
    }

    shared test void addToTableInArray2() {
        assertEquals {
            actual = parseToml {
                 """
                    [[k1.k2]]
                    a = 1
                    [[k1.k2.k3]]
                    a = 2
                    [[k1.k2]]
                    a = 3
                    [[k1.k2.k3]]
                    a = 4
                 """;
            };
            expected = map {
                "k1" -> map {
                    "k2" -> [
                        map {
                            "a" -> 1,
                            "k3" -> [
                                map {
                                    "a" -> 2
                                }
                            ]
                        },
                        map {
                            "a" -> 3,
                            "k3" -> [
                                map {
                                    "a" -> 4
                                }
                            ]
                        }
                    ]
                }
            };
        };
    }

    shared test void addToTableInArray22() {
        assertEquals {
            actual = parseToml {
                 """
                    [[k1.k2]]
                    a = 1
                    [[k1.k2.k3]]
                    a = 2
                    [[k1.k2]]
                    a = 3
                    [[k1.k2.k3]]
                    a = 4
                    [[k1.k2.k3]]
                    a = 5
                 """;
            };
            expected = map {
                "k1" -> map {
                    "k2" -> [
                        map {
                            "a" -> 1,
                            "k3" -> [
                                map {
                                    "a" -> 2
                                }
                            ]
                        },
                        map {
                            "a" -> 3,
                            "k3" -> [
                                map {
                                    "a" -> 4
                                },
                                map {
                                    "a" -> 5
                                }
                            ]
                        }
                    ]
                }
            };
        };
    }

    "Attempting to append to a statically defined array, even if that array is empty or
     of compatible type, must produce an error at parse time."
    shared test void cantAppend()
        =>  assertTrue {
                parseToml {
                     """
                        # INVALID TOML DOC
                        fruit = []

                        [[fruit]] # Not allowed
                     """;
                } is TomlParseException;
            };

    shared test void canAppend()
        =>  assertEquals {
                actual = parseToml {
                     """
                        [[fruit]]
                        a=1
                        [[fruit]]
                        b=2
                     """;
                };
                expected = map {
                    "fruit" -> [
                        map { "a" -> 1 },
                        map { "b" -> 2 }
                    ]
                };
            };

    shared test void cantAppend2()
        =>  assertTrue {
                parseToml {
                     """
                        fruit = []

                        [[fruit.whatever]]
                     """;
                } is TomlParseException;
            };

    shared test void canAppend2()
        =>  assertEquals {
                actual = parseToml {
                     """
                        [[fruit]]
                        a=1
                        [[fruit.whatever]]
                        b=2
                     """;
                };
                expected = map {
                    "fruit" -> [
                        map {
                            "a" -> 1,
                            "whatever" -> [ map { "b" -> 2 } ]
                        }
                    ]
                };
            };

    "Attempting to define a normal table with the same name as an already established
     array must produce an error at parse time."
    shared test void tableNameAlreadyUsed()
        =>  assertTrue {
                parseToml {
                     """
                        # INVALID TOML DOC
                        [[fruit]]
                        name = "apple"

                        [[fruit.variety]]
                            name = "red delicious"

                        # This table conflicts with the previous table
                        [fruit.variety]
                            name = "granny smith"
                     """;
                } is TomlParseException;
            };

    shared void test() {
        empty();
        notEmpty();
        twoArraysMixedOrder();
        nested();
        nestedArrayFirst();
        addToTableInArray();
        addToTableInArray2();
        addToTableInArray22();
        cantAppend();
        canAppend();
        cantAppend2();
        canAppend2();
    }
}
