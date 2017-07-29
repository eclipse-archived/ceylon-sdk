import ceylon.collection {
    ArrayList
}
import ceylon.time {
    Time, Date, DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}

"Generate a TOML document from the given `Map`. For added type safety, it is recommended
 that the argument be a [[TomlTable]], although any `Map` with valid content can be used.

 Note that all keys must be [[String]]s, and all values must be [[TomlValue]]s, [[Map]]s,
 or [[List]]s. No type coercion is performed by this function."
throws(`class AssertionError`, "if the argument represents an invalid TOML document")
shared String formatToml(Map<String, Object> tomlTable)
        => object satisfies Producer<String> {

    value tablePath = ArrayList<String>();

    value sb = StringBuilder();

    AssertionError error(String message) {
        value location
            =   if (tablePath.empty)
                then ""
                else " at key path '``formatKeyPath()``'";
        return AssertionError(message + location);
    }

    Boolean isArrayOfTables(Anything item)
        =>  if (!is List<Anything> item)
            then false
            else item.first is Map<Anything, Anything>;

    Boolean isSimpleValue(Anything item)
        =>     !item is Map<Anything, Anything>
            && !isArrayOfTables(item);

    void emitNewline()
        =>  sb.append(operatingSystem.newline);

    String escapeKey(String key) {
        if (key.every(isValidKeyCharacter)) {
            return key;
        }
        value sb = StringBuilder();
        emitBasicString(key, sb);
        return sb.string;
    }

    void emitKeyPath(StringBuilder sb = this.sb) {
        variable value first = true;
        for (path in tablePath) {
            if (!first) {
                sb.appendCharacter('.');
            }
            else {
                first = false;
            }
            sb.append(path);
        }
    }

    String formatKeyPath() {
        value sb = StringBuilder();
        emitKeyPath(sb);
        return sb.string;
    }

    void emitTableHeading(Boolean isArray = false) {
        if (!tablePath.empty) {
            if (!sb.empty) {
                emitNewline();
            }
            sb.append(isArray then "[[" else "[");
            emitKeyPath();
            sb.append(isArray then "]]" else "]");
            emitNewline();
        }
    }

    void emitStringValue(String item) {
        // TODO analyze item and choose best encoding type?
        //      (multiline & literal combos)
        emitBasicString(item);
    }

    void emitBasicString(String item, StringBuilder sb = this.sb) {
        sb.appendCharacter('"');
        for (char in item) {
            switch (char)
            case ('\{#08}') { sb.append("\\b"); }
            case ('\{#09}') { sb.append("\\t"); }
            case ('\{#0a}') { sb.append("\\n"); }
            case ('\{#0c}') { sb.append("\\f"); }
            case ('\{#0d}') { sb.append("\\r"); }
            case ('\{#22}') { sb.append("\\\""); }
            case ('\{#5c}') { sb.append("\\\\"); }
            else if (char < '\{#20}') {
                sb.append("\\u");
                sb.append(char.integer.string.padLeading(4, '0'));
            }
            else {
                sb.appendCharacter(char);
            }
        }
        sb.appendCharacter('"');
    }

    void emitArrayValue(List<Anything> array) {
        // TODO error if not homogeneous
        variable value first = true;
        sb.append("[ ");
        for (item in array) {
            if (!first) {
                sb.append(", ");
            }
            else {
                first = false;
            }
            emitValue(item);
        }
        sb.append(" ]");
    }

    void emitInlineTableValue(Map<Anything, Anything> table) {
        variable value first = true;
        sb.append("{ ");
        for (key->item in table) {
            if (!first) {
                sb.append(", ");
            }
            else {
                first = false;
            }
            if (!is String key) {
                throw error("Keys must be Strings; found ``className(key)``");
            }
            value escapedKey = escapeKey(key);
            sb.append(escapedKey);
            sb.append(" = ");
            emitValue(item);
        }
        sb.append(" }");
    }

    void emitValue(Anything item) {
        switch (item)
        case (is String) {
            emitStringValue(item);
        }
        case (is Float) {
            if (item.infinite) {
                throw error("infinite floating point values not allowed");
            }
            if (item.undefined) {
                throw error("undefined (NaN) floating point values not allowed");
            }
            sb.append(item.string);
        }
        case (is Integer | Boolean) {
            sb.append(item.string);
        }
        else if (is Time | Date | DateTime | ZoneDateTime item) {
            sb.append(item.string); // `string` is documented to be ISO 8601
        }
        else if (is List<Anything> item) {
            emitArrayValue(item);
        }
        else if (is Map<Anything, Anything> item) {
            emitInlineTableValue(item);
        }
        else {
            throw error("not a valid TOML value type '``className(item)``'");
        }
    }

    void emitTable(Map<Anything, Anything> table, Boolean isArray = false) {
        if (table.empty) {
            emitTableHeading(isArray);
            return;
        }

        variable value headingEmitted = false;

        // simple values
        for (key->item in table) {
            if (!isSimpleValue(item)) {
                continue;
            }
            if (!headingEmitted) {
                emitTableHeading(isArray);
                headingEmitted = true;
            }
            if (!is String key) {
                throw error("Keys must be Strings; found ``className(key)``");
            }
            try {
                value escapedKey = escapeKey(key);
                // add to path to make avail. for error messages
                tablePath.add(escapedKey);
                sb.append(escapedKey);
                sb.append(" = ");
                emitValue(item);
                emitNewline();
            }
            finally {
                tablePath.deleteLast();
            }
        }

        // tables
        for (key->item in table) {
            if (!is Map<Anything, Anything> item) {
                continue;
            }
            if (!is String key) {
                throw error("Keys must be Strings; found ``className(key)``");
            }
            try {
                tablePath.add(escapeKey(key));
                emitTable(item);
            }
            finally {
                tablePath.deleteLast();
            }
        }

        // arrays of tables
        for (key->item in table) {
            if (!isArrayOfTables(item)) {
                continue;
            }
            if (!is String key) {
                throw error("Keys must be Strings; found ``className(key)``");
            }
            // previous checked by isArrayOfTables(), ugly I know!
            assert (is List<Anything> item);
            try {
                tablePath.add(escapeKey(key));
                for (t in item) {
                    if (!is Map<Anything, Anything> t) {
                        throw error("all values in an Array of Tables must be Tables; \
                                     ``className(t)`` is not allowed");
                    }
                    emitTable(t, true);
                }
            }
            finally {
                tablePath.deleteLast();
            }
        }
    }

    shared actual String get() {
        emitTable(tomlTable);
        return sb.string;
    }
}.get();

interface Producer<T> {
    shared formal T get();
}

Boolean(Character) isValidKeyCharacter = set(
    concatenate('a'..'z', 'A'..'Z', '0'..'9', "_-")
).contains;
