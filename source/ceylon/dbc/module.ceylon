"""This module offers some components for JDBC-based
   database connectivity. The main component is the class 
   [[Sql]], an instance of which may be obtained for any 
   given [[javax.sql::DataSource]].
   
       value sql = Sql(datasource);

   You can easily get a query result as a `Sequence` where 
   each row is a `Map`:
   
       value rows = sql.rows("select * from mytable")([]);
   
   You can pass parameters to the query, using the `?` 
   notation:
   
       value result = sql.rows("select * from mytable where col1=? and col2=?")
                       ([val1, val2]);
   
   And you can even limit the number of rows obtained, as 
   well as the starting offset (the number of rows to skip 
   before the first retrieved result):
   
       value result = sql.rows("select * from mytable where date>?", 5, 2)([date]);
   
   The `rows` method has two parameter lists because you can 
   actually create reusable queries:
   
       value query = sql.rows("select * from mytable where col=?");
       value result1 = query([value1]);
       value result2 = query([value2]);
       for (row in query(["X"]) {
           if (is String c=row["some_column"]) {
               //do something with this
           }
           if (is DbNull c=row["other_column"]) {
               //nulls are represented with DbNull instances
           }
       }
   
   There are methods to retrieve just the first row, and even 
   only one value. All these methods handle the SQL connection 
   for you; it will be closed even if an exception is thrown:
   
       value row = sql.firstRow("select * from mytable where key=?", key);
       value count = sql.queryForInt("select count(*) from mytable");
       value name = sql.queryForString("select name from table where key=?", key);
   
   And of course you can execute update and insert statements:
   
       Integer changed = sql.update("update table SET col=? where key=?", newValue, key);
       value newKeys = sql.insert("insert into table (key,col) values (?, ?)", key, col);
   
   If you need to perform several operations within a transaction, 
   you can pass a function to the `transaction` method; it will 
   be executed within a transaction, everything will be performed 
   using the same connection, and at the end the commit is performed 
   if your method returns `true`, or rolled back if you return 
   `false`:
   
       sql.transaction {
           Boolean do() {
               sql.insert("insert ... ");
               sql.update("update ... ");
               sql.update("delete ... ");
               //This will cause a commit - return false or throw to cause rollback
               return true;
           }
       };
   
   To pass a null value in an update or insert statement, use a 
   `SqlNull` with the right SQL type (defined by the JDBC class 
   [[java.sql::Types]]):
   
       sql.update("update table set col=? where key=?", SqlNull(Types.\iINTEGER));
   
   If a column is null on a row from the `rows`, `firstRow` or 
   `eachRow` methods, it will get mapped to a `SqlNull` instance 
   under the column's key."""

by("Enrique Zamudio")
license("Apache Software License 2.0")
module ceylon.dbc "1.0.0" {
    import ceylon.collection "1.0.0";
    shared import ceylon.math "1.0.0";
    import java.base "7";
    shared import java.jdbc "7";
}
