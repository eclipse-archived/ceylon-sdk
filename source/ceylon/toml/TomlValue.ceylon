import ceylon.time {
    Time, Date, DateTime
}
import ceylon.time.timezone {
    ZoneDateTime
}

shared alias TomlValue
    =>  TomlTable | TomlArray | Time | Date | DateTime | ZoneDateTime
            | Boolean | Float | Integer | String;
