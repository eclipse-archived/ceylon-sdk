import ceylon.test {
    test, assertEquals, assertTrue, ignore
}
import ceylon.toml {
    parseToml, TomlParseException
}

shared object tables {
    // TODO tests for errors, like redefining tables

    shared test void empty() {
        assertEquals {
            actual = parseToml {
                 """[table_1]""";
            };
            expected = map {
                "table_1" -> map {}
            };
        };
    }

    shared test void oneTable() {
        assertEquals {
            actual = parseToml {
                 """[table_1]
                    t1k1 = 11
                    t1k2 = 12
                 """;
            };
            expected = map {
                "table_1" -> map {
                    "t1k1" -> 11,
                    "t1k2" -> 12
                }
            };
        };
    }

    shared test void twoTables() {
        assertEquals {
            actual = parseToml {
                 """[table_1]
                    t1k1 = 11
                    t1k2 = 12

                    [table_2]
                    t2k1 = 21
                    t2k2 = 22
                 """;
            };
            expected = map {
                "table_1" -> map {
                    "t1k1" -> 11,
                    "t1k2" -> 12
                },
                "table_2" -> map {
                    "t2k1" -> 21,
                    "t2k2" -> 22
                }
            };
        };
    }

    shared test void nestedTable() {
        assertEquals {
            actual = parseToml {
                 """[table_1]
                    t1k1 = 11

                    [table_1.sub1]
                    t11k1 = 111

                    [table_1.sub2]
                    t12k1 = 121
                 """;
            };
            expected = map {
                "table_1" -> map {
                    "t1k1" -> 11,
                    "sub1" -> map {
                        "t11k1" -> 111
                    },
                    "sub2" -> map {
                        "t12k1" -> 121
                    }
                }
            };
        };
    }

    shared test void nestedTableSubFirst() {
        assertEquals {
            actual = parseToml {
                 """[table_1.sub1]
                    t11k1 = 111

                    [table_1]
                    t1k1 = 11

                    [table_1.sub2]
                    t12k1 = 121
                 """;
            };
            expected = map {
                "table_1" -> map {
                    "t1k1" -> 11,
                    "sub1" -> map {
                        "t11k1" -> 111
                    },
                    "sub2" -> map {
                        "t12k1" -> 121
                    }
                }
            };
        };
    }

    shared test void nestedTable3Deep() {
        assertEquals {
            actual = parseToml {
                 """[table_1]
                    t1k1 = 11

                    [table_1.sub1]
                    t11k1 = 111

                    [table_1.sub1.subsub1]
                    t111k1 = 1111
                 """;
            };
            expected = map {
                "table_1" -> map {
                    "t1k1" -> 11,
                    "sub1" -> map {
                        "t11k1" -> 111,
                        "subsub1" -> map {
                            "t111k1" -> 1111
                        }
                    }
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
                    [k1.k2.k3]
                    a = 2
                 """;
            };
            expected = map {
                "k1" -> map {
                    "k2" -> [
                        map {
                            "a" -> 1,
                            "k3" -> map {
                                "a" -> 2
                            }
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
                    [k1.k2.k3]
                    a = 2
                    [[k1.k2]]
                    a = 1
                    [k1.k2.k3]
                    a = 2
                 """;
            };
            expected = map {
                "k1" -> map {
                    "k2" -> [
                        map {
                            "a" -> 1,
                            "k3" -> map {
                                "a" -> 2
                            }
                        },
                        map {
                            "a" -> 1,
                            "k3" -> map {
                                "a" -> 2
                            }
                        }
                    ]
                }
            };
        };
    }

    shared test void addToTableInArrayError() {
        assertTrue {
            parseToml {
                 """
                    [[k1.k2]]
                    a = 1
                    [k1.k2.k3]
                    a = 2
                    [k1.k2.k3] # key already exists
                    a = 3
                 """;
            } is TomlParseException;
        };
    }

    shared test void redefineKey()
        =>  assertTrue {
                parseToml {
                     """
                        [k1.k2]
                        k3 = 1
                        [k1]
                        k2 = 0 # should error
                     """;
                } is TomlParseException;
            };

    shared test void redefineKey2()
        =>  assertTrue {
                parseToml {
                     """
                        [k1]
                        k2 = 0
                        k2 = 1 # should error
                     """;
                } is TomlParseException;
            };

    shared void test() {
        empty();
        oneTable();
        twoTables();
        nestedTable();
        nestedTableSubFirst();
        nestedTable3Deep();
        addToTableInArray();
        addToTableInArray2();
        addToTableInArrayError();
        redefineKey();
    }
}
