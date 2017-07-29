import ceylon.time {
    Time, Date, DateTime, today, now
}
import ceylon.time.timezone {
    ZoneDateTime, OffsetTimeZone, zoneDateTime, timeZone
}
import ceylon.toml {
    TomlTable, TomlArray
}

void parseAndPrint(String tomlDocument) {
    switch (result = parseToml(tomlDocument))
    case (is TomlParseException) {
        printAll {
            separator = "\n";
            result.errors.map((e) => "error: ``e``");
        };
        print("\n``result.errors.size`` error``result.errors.size.unit then "" else "s"``\n");
        print("");
        print(result.partialResult);
    }
    case (is TomlTable) {
        print(result);
    }
}

shared void run() {
    parseAndPrint(
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
         """
    );

    // value document
    //     =   TomlTable {
    //             "title" -> "TOML Example",
    //             "owner" -> TomlTable {
    //                 "name" -> "Tom Preston-Werner",
    //                 "dob" -> zoneDateTime {
    //                     timeZone = timeZone.offset {
    //                         hours = -8;
    //                     };
    //                     year = 1979;
    //                     month = 5;
    //                     date = 27;
    //                     hour = 7;
    //                     minutes = 32;
    //                 }
    //             },
    //             "hosts" -> TomlArray {
    //                 "alpha", "omega"
    //             }
    //         };

    // print(document);
    // print {
    //     generateToml {
    //         map {
    //             "someString" -> "he\nll\to",
    //             "key with spaces" -> 99,
    //             "arrayWithInlineTable" -> [ [ map { "x"->1, "y"->2 } ] ],
    //             "first" -> 1,
    //             "someArray" -> [1,2,3],
    //             "sub" -> map {
    //                 "first" -> 1,
    //                 "today" -> today(),
    //                 "timeNow" -> (now().time() of Time),
    //                 "dateTimeNow" -> (now().dateTime() of DateTime),
    //                 "exactlyNow" -> (now().zoneDateTime() of ZoneDateTime),
    //                 "exactlyNowZulu" -> (now().zoneDateTime(OffsetTimeZone(0)) of ZoneDateTime)
    //             },
    //             "sub2" -> map {
    //                 "sub2sub" -> map {
    //                     "sub2subsub" -> map {
    //                         "first" -> 1
    //                     }
    //                 },
    //                 "sub2aot" -> [
    //                     map {
    //                         "t1_1" -> 11,
    //                         "t1_1" -> 12
    //                     },
    //                     map {
    //                         "t2_1" -> 21,
    //                         "t2_1" -> 22
    //                     },
    //                     map { },
    //                     map { }
    //                 ]
    //             },
    //             "aot" -> [
    //                 map {
    //                     "t1_1" -> 11,
    //                     "t1_1" -> 12
    //                 },
    //                 map {
    //                     "t2_1" -> 21,
    //                     "t2_1" -> 22
    //                 },
    //                 map { },
    //                 map { }
    //             ]
    //         };
    //     };
    // };
}
