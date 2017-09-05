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
        case (Boolean) TomlValueType.boolean
        case (Float) TomlValueType.float
        case (Integer) TomlValueType.integer
        case (String) TomlValueType.str
        case (Map<Anything, Anything>) TomlValueType.table
        else case (List<Anything>) TomlValueType.array
        else case (ZoneDateTime) TomlValueType.zoneDateTime
        else case (DateTime) TomlValueType.dateTime
        else case (Date) TomlValueType.date
        else case (Time) TomlValueType.time;
