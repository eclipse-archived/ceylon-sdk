"Represents a NULL value from the database, 
 with its corresponding SQL type."
by("Enrique Zamudio")
shared class SqlNull(sqlType) {
    shared Integer sqlType;
    string => "<null>";
}

deprecated ("Renamed to [[SqlNull]].")
shared class DbNull(Integer sqlType) 
        => SqlNull(sqlType);