/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"""This module offers some components for JDBC-based
   database connectivity. The main component is the class 
   [[Sql]], an instance of which may be obtained for any 
   given [[javax.sql::DataSource]].
   
       value sql = Sql(newConnectionFromDataSource(dataSource));

   You can easily get a query result as a `Sequence` where 
   each row is a [[Map]]:
   
       value rows = sql.Select("select * from mytable").execute();
       for (row in rows) {
           assert (is String name = rows["name"]);
           assert (is Integer count = rows["count"]);
           ...
       }
   
   You can define parameters to the query, using the `?` 
   notation:
   
       value rows = sql.Select("select * from mytable where col1=? and col2=?")
                       .execute(arg1, arg2);
   
   The [[Sql.Select.Results]] class lets results be iterated 
   lazily:
   
       try (results = sql.Select("select * from mytable where date>?")
                         .Results(date)) {
           results.limit = 50;
           for (row in results) {
               ...
           }
       }
   
   Alternatively, [[Sql.Select.forEachRow]] is a little less 
   verbose:
   
       sql.Select("select * from mytable where date>?")
          .forEachRow(date)((row) {
           ...
       });
   
   A [[Sql.Select]] is reusable:
   
       value query = sql.Select("select * from mytable where col=?");
       value result1 = query.execute(value1);
       value result2 = query.execute(value2);
   
   And of course you can execute `update` and `insert` 
   statements, using [[Sql.Update]] and [[Sql.Insert]]:
   
       sql.Update("update table SET col=? where key=?")
          .execute(newValue, key);
   
       sql.Insert("insert into table (key,col) values (?, ?)")
          .execute(key, initialValue);
   
   If you need to perform several operations within a single
   transaction, you can pass a function to the method
   [[Sql.transaction]]. All statements of the function will
   be executed within a transaction, using the same JDBC
   connection, and finally the transaction is committed iff
   the function returns `true`:
   
       sql.transaction {
           function do() {
               sql.Insert("insert ... ").execute();
               sql.Update("update ... ").execute();
               sql.Update("delete ... ").execute();
               //return true to commit the transaction
               //return false or throw to roll it back
               return true;
           }
       };
   
   To pass a null value as an argument, use a [[SqlNull]] 
   with the right SQL type (defined by the JDBC class 
   [[java.sql::Types]]):
   
       sql.Update("update table set col=? where key=?")
          .execute(SqlNull(Types.integer));
   
   If a column is null on a result row, it will be 
   represented as a `SqlNull` instance under the column's 
   name."""

by ("Enrique Zamudio")
license ("Apache Software License 2.0")
native("jvm")
label("Ceylon Relational Database Access API")
module ceylon.dbc maven:"org.ceylon-lang" "1.3.4-SNAPSHOT" {
    import ceylon.collection "1.3.4-SNAPSHOT";
    shared import ceylon.decimal "1.3.4-SNAPSHOT";
    shared import ceylon.whole "1.3.4-SNAPSHOT";
    import java.base "7";
    shared import java.jdbc "7";
    import ceylon.time "1.3.4-SNAPSHOT";
}
