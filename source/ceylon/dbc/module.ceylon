"This module offers some components for JDBC-based
 database connectivity. The main component is simply
 called Sql and is meant to be used with a `DataSource`
 that has been already been configured. "
by("Enrique Zamudio")
license("Apache Software License 2.0")
module ceylon.dbc "1.0.0" {
    import ceylon.collection "1.0.0";
    shared import ceylon.math "1.0.0";
    import java.base '7';
    shared import java.jdbc '7';
}
