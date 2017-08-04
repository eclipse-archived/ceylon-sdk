import ceylon.toml {
    TomlValue
}
import ceylon.time.timezone {
    ZoneDateTime
}
import ceylon.time {
    Time, Date, DateTime
}

shared TomlValueType elementTypeOf(TomlValue | Map<Anything, Anything> | List<Anything> tv)
    =>  switch (tv)
        case (is Boolean) TomlValueType.boolean
        case (is Float) TomlValueType.float
        case (is Integer) TomlValueType.integer
        case (is String) TomlValueType.str
        case (is Map<Anything, Anything>) TomlValueType.table
        else case (is List<Anything>) TomlValueType.array
        else case (is ZoneDateTime) TomlValueType.zoneDateTime
        else case (is DateTime) TomlValueType.dateTime
        else case (is Date) TomlValueType.date
        else case (is Time) TomlValueType.time;
