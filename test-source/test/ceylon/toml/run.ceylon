import ceylon.toml {
    parseToml, TomlTable
}

shared void run() {
    value sb = StringBuilder();
    while (exists line = process.readLine()) {
        sb.append(line);
        sb.appendCharacter('\n');
    }
    switch (result = parseToml(sb.string))
    case (is TomlTable) {
        print(result);
    }
    else {
        printAll {
            separator = "\n";
            result.errors.map((e) => "error: ``e``");
        };
        print("\n``result.errors.size`` errors\n");
        print(result.partialResult);
    }
}
