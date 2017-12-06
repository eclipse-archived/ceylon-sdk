/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module provides everything necessary to parse and generate Tom's Obvious,
    Minimal Language (TOML) documents.

    As described in the [TOML documentation](https://github.com/toml-lang/toml/blob/master/versions/en/toml-v0.4.0.md):

    > TOML aims to be a minimal configuration file format that's easy to read due to
    obvious semantics. TOML is designed to map unambiguously to a hash table. TOML should
    be easy to parse into data structures in a wide variety of languages.

    # Example TOML Document

    ```toml
    # This is a TOML document.

    title = "TOML Example"

    [owner]
    name = "Tom Preston-Werner"
    dob = 1979-05-27T07:32:00-08:00 # First class dates

    [database]
    server = "192.168.1.1"
    ports = [ 8001, 8001, 8002 ]
    connection_max = 5000
    enabled = true

    [servers]

    # Indentation (tabs and/or spaces) is allowed but not required
    [servers.alpha]
    ip = "10.0.0.1"
    dc = "eqdc10"

    [servers.beta]
    ip = "10.0.0.2"
    dc = "eqdc10"

    [clients]
    data = [ ["gamma", "delta"], [1, 2] ]

    # Line breaks are OK when inside arrays
    hosts = [
    "alpha",
    "omega"
    ]
    ```

    # Parsing

    Use the [[parseToml]] top-level function to parse a TOML document into a
    [[TomlTable]]:

    ```ceylon
    import ceylon.toml {
        parseToml, TomlTable, TomlParseException
    }
    import ceylon.time.timezone {
        ZoneDateTime
    }

    value sampleDocument = ...;
    TomlTable|TomlParseException table = parseToml(sampleDocument);
    if (is TomlParseException table) {
        throw table;
    }
    assert (is TomlTable owner = table["owner"]);
    assert (is String ownerName = owner["name"]);
    assert (is ZoneDateTime ownerDOB = owner["dob"]);
    print("``ownerName`` was born at ``ownerDOB``");
    ```

    Convenience getters such as [[TomlTable.getString]] and
    [[TomlTable.getZoneDateTimeOrNull]] can be used when the item type is known:

    ```ceylon
    TomlTable owner = table.getTomlTable("owner");
    String ownerName = owner.getString("name");
    ZoneDateTime? ownerDOB = owner.getZoneDateTimeOrNull("dob");
    print("``ownerName`` was born at ``ownerDOB else "an unknown time!"``");
    ```

    [[TomlTable]]s are also [[ceylon.collection::MutableList]]s, and [[TomlTable]]s are
    also [[ceylon.collection::MutableMap]]s, and can be iterated and modified as
    regular collections:

    ```ceylon
    String people =
       "[[people]]
            firstName = \"Joe\"
            lastName = \"Blow\"
            
        [[people]]
            firstName = \"John\"
            lastName = \"Smith\"
       ";
    assert (is TomlTable data = parseToml(people));
    data.getTomlArray("people").add {
        TomlTable {
            "firstName" -> "Jane",
            "lastName" -> "Doe"
        };
    };
    for (person in data.getTomlArray("people")) {
        assert (is TomlTable person);
        print("``person.getString("lastName")``, \
               ``person.getString("firstName")``");
    }
    ```
    outputs:
    ```
    Blow, Joe
    Smith, John
    Doe, Jane
    ```

    # Error Handling
    [[parseToml]] returns the union [[TomlTable]]`|`[[TomlParseException]]. If a
    [[TomlParseException]] is returned, it will contain:

    - a brief [[description|Exception.message]] of the *first* error that was found and a
      count of the total number of errors,

    - a [[listing|TomlParseException.errors]] of all errors, including line number
      information, and

    - a [[TomlTable|TomlParseException.partialResult]] containing the portions of the
      document that could be parsed without error.

    The following program can be used to parse a document and report all errors, if any:

    ```ceylon
    import ceylon.toml {
        parseToml, TomlTable, TomlParseException
    }

    String tomlDocument = ...;
    switch (result = parseToml(tomlDocument))
    case (TomlParseException) {
        printAll {
            separator = "\n";
            result.errors.map((e) => "error: ``e``");
        };
        print("\n``result.errors.size`` errors\n");
    }
    case (TomlTable) {
        // process(result);
    }
    ```

    # Generating TOML Documents

    [[formatToml]] can be used to generate a TOML document from a [[TomlTable]] or a
    `Map<Anything, Anything>`. In either case, the argument must represent a valid TOML
    document, with [[String]]s for keys and [[TomlValue]]s, ``Map``s, or ``List``s for
    values.

    The code below produces a portion of the "Exampe TOML Document":

     ```ceylon
        import ceylon.time.timezone {
            zoneDateTime, timeZone
        }
        import ceylon.toml {
            TomlTable, TomlArray, formatToml
        }

        shared void run() {
            value document = TomlTable {
                "title" -> "TOML Example",
                "owner" -> TomlTable {
                    "name" -> "Tom Preston-Werner",
                    "dob" -> zoneDateTime {
                        timeZone = timeZone.offset {
                            hours = -8;
                        };
                        year = 1979;
                        month = 5;
                        date = 27;
                        hour = 7;
                        minutes = 32;
                    }
                },
                "hosts" -> TomlArray {
                    "alpha", "omega"
                }
            };
            print(formatToml(document));
        }
     ```
 """
suppressWarnings("doclink")
module ceylon.toml maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    shared import ceylon.time "1.3.4-SNAPSHOT";
    shared import ceylon.collection "1.3.4-SNAPSHOT";
}
