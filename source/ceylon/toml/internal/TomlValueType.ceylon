shared class TomlValueType
        of table | array | time | date | dateTime| zoneDateTime
            | boolean | float | integer | str {

    shared actual String string;

    shared new table {
        string = "Table";
    }
    shared new array {
        string = "Array";
    }
    shared new time {
        string = "Local Time";
    }
    shared new date {
        string = "Local Date";
    }
    shared new dateTime {
        string = "Local Date-Time";
    }
    shared new zoneDateTime {
        string = "Offset Date-Time";
    }
    shared new boolean {
        string = "Boolean";
    }
    shared new float {
        string = "Float";
    }
    shared new integer {
        string = "Integer";
    }
    shared new str {
        string = "String";
    }
}
