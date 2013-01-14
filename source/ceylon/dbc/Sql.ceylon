import javax.sql { DataSource }
import java.lang { Long, JString=String }
import java.sql {
    PreparedStatement, CallableStatement,
    ResultSet, ResultSetMetaData,
    Timestamp, SqlDate=Date,
    Statement {
        returnGeneratedKeys=RETURN_GENERATED_KEYS
    }
}
import java.util { Date }
import java.math { BigDecimal, BigInteger }
import ceylon.math.decimal { Decimal, parseDecimal }
import ceylon.math.whole { Whole, fromImplementation, parseWhole }

doc "A component that can perform queries and execute SQL statements on a
     database, via connections obtained from a JDBC DataSource.

     You can easily get a query result as a `Sequence` where each row is
     a `Map`:

         value rows = sql.rows(\"SELECT * FROM mytable\")({});

     You can pass parameters to the query, using the '?' notation:

         sql.rows(\"SELECT * FROM mytable WHERE col1=? AND col2=?\")({val1, val2});

     And you can even limit the number of rows obtained, as well as the starting
     offset (the number of rows to skip before the first retrieved result):

         sql.rows(\"SELECT * FROM mytable WHERE date>?\", 5, 2)({date});

     The `rows` method has two parameter lists because you can actually create
     reusable queries:

         value query = sql.rows(\"SELECT * FROM mytable WHERE col=?\");
         value result1 = query({value1});
         value result2 = query({value2});
         for (row in query({\"X\"}) {
             if (is String c=row[\"some_column\"]) {
                 //do something with this
             }
             if (is DbNull c=row[\"other_column\"]) {
                 //nulls are represented with DbNull instances
             }
         }

     There are methods to retrieve just the first row, and even only one
     value. All these methods handle the SQL connection for you; it will be
     closed even if an exception is thrown:

         value row = sql.firstRow(\"SELECT * FROM mytable WHERE key=?\", key);
         value count = sql.queryForInt(\"SELECT count(*) FROM mytable\");
         value name = sql.queryForString(\"SELECT name FROM table WHERE key=?\", key);

     And of course you can execute update and insert statements:

         Integer changed = sql.update(\"UPDATE table SET col=? WHERE key=?\", newValue, key);
         value newKeys = sql.insert(\"INSERT INTO table (key,col) VALUES (?, ?)\", key, col);

     If you need to perform several operations within a transaction, you can pass a function
     to the `transaction` method; it will be executed within a transaction, everything will
     be performed using the same connection, and at the end the commit is performed if your
     method returns `true`, or rolled back if you return `false`:

         sql.transaction {
             Boolean do() {
                 sql.insert(\"INSERT...\");
                 sql.update(\"UPDATE...\");
                 sql.update(\"DELETE...\");
                 //This will cause a commit - return false or throw to cause rollback
                 return true;
             }
         };

     To pass a NULL value in an update or insert statement, use a `DbNull` with the proper
     SQL type (from the `java.sql.Types` class):

          sql.update(\"UPDATE table SET col=? WHERE key=?\", DbNull(Types.INTEGER));

     If a column is NULL on a row from the `rows`, `firstRow` or `eachRow` methods, it will
     get mapped to a DbNull instance under the column's key.
     "
by "Enrique Zamudio"
shared class Sql(DataSource ds) {

    value conns = ThreadLocalConnection(ds);

    PreparedStatement prepareStatement(ConnectionStatus conn, String sql, Iterable<Object> params) {
        value stmt = conn.connection().prepareStatement(sql);
        return prepareExistingStatement(stmt, params);
    }

    PreparedStatement prepareExistingStatement(PreparedStatement stmt, Iterable<Object> params) {
        //Set parameters
        variable value i=1;
        for (p in params) {
            switch (p)
            case (is Integer) { stmt.setLong(i,p); }
            case (is Boolean) { stmt.setBoolean(i,p); }
            //case (is Decimal) { stmt.setBigDecimal(i,p); }
            case (is String)  { stmt.setString(i,p); }
            case (is Date)    {
                if (is Timestamp p) {
                    stmt.setTimestamp(i,p);
                } else if (is SqlDate p) {
                    stmt.setDate(i, p);
                } else {
                    stmt.setDate(i, SqlDate(p.time));
                }
            }
            case (is Float)   { stmt.setDouble(i, p); }
            case (is DbNull)  { stmt.setNull(i, p.sqlType); }
            //TODO reader, inputStream, byte array
            else { stmt.setObject(i,p); }
            i++;
        }
        return stmt;
    }

    CallableStatement prepareCall(ConnectionStatus conn, String sql, Iterable<Object> params) {
        value cs = conn.connection().prepareCall(sql);
        variable value i=1;
        /*for (p in params) {
            switch (p)
            case (is Integer) { cs.setLong(i,p); }
            case (is Boolean) { cs.setBoolean(i,p); }
            //case (is Decimal) { cs.setBigDecimal(i,p); }
            case (is String)  { cs.setString(i,p); }
            case (is Date)    {
                if (is Timestamp p) {
                    cs.setTimestamp(i,p, null);
                } else if (is SqlDate p) {
                    cs.setDate(i, p, null);
                } else {
                    cs.setDate(i, SqlDate(p.time), null);
                }
            }
            case (is Float)   { cs.setDouble(i, p); }
            case (is DbNull)  { cs.setNull(i, p.sqlType); }
            //TODO reader, inputStream, byte array
            else { cs.setObject(i,p); }
            i++;
        }*/
        return cs;
    }

    doc "Execute a SQL statement, with the given parameters. The SQL string
         must use the '?' parameter placeholders."
    shared default Boolean execute(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            try {
                return stmt.execute();
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL statement with the given parameters, and return
         the number of rows that were affected. This is useful for
         DELETE or UPDATE statements. The SQL string must use the '?'
         parameter placeholders."
    shared default Integer update(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            try {
                return stmt.executeUpdate();
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL INSERT statement with the given parameters, and return
         the generated keys (if the JDBC driver supports it). The SQL string
         must use the '?' parameter placeholders."
    shared default Object[][] insert(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = conn.connection().prepareStatement(sql, returnGeneratedKeys);
            try {
                prepareExistingStatement(stmt, params);
                value count = 1..stmt.executeUpdate();
                value rs = stmt.generatedKeys;
                try {
                    value meta = rs.metaData;
                    value rango = 1..meta.columnCount;
                    return count.collect {
                        function collecting(Integer i) {
                            rs.next();
                            return [ for (c in rango) mapColumn(rs, meta, c).item ];
                        }
                    };
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL callable statement, returning the number of rows
         that were affected. This is useful to call database functions or
         stored procedures that update or delete rows. The SQL string must
         use the '?' parameter placeholers."
    shared default Integer callUpdate(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareCall(conn, sql, params);
            try {
                return stmt.executeUpdate();
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    shared default Map<Integer, Object>? call(String sql, Object* params) {
        return null;
    }

    doc "Execute a SQL query with the given parameters and return the
         resulting rows. The SQL string must use the '?' parameter placeholders."
    shared default Map<String, Object>[] rows(
            doc "The SQL query."
            String sql,
            doc "The limit of rows to return. Default is -1 which means return all rows."
            Integer limit=-1,
            doc "The number of rows to skip from the result. Default is 0."
            Integer offset=0)
            (doc "The parameters passed to the SQL query."
            Object[] params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            if (limit > 0 && offset <= 0) {
                stmt.maxRows=limit;
            }
            try {
                value rs = stmt.executeQuery();
                try {
                    value meta = rs.metaData;
                    value range = 1..meta.columnCount;
                    value cont = offset > 0 then (1..offset).every((Integer x) => rs.next()) else true;
                    value sb = SequenceBuilder<Map<String, Object>>();
                    if (limit > 0) {
                        variable value count = 0;
                        while (count < limit && rs.next()) {
                            sb.append(LazyMap({for (i in range) mapColumn(rs, meta, i)}));
                            count++;
                        }
                    } else if (cont) {
                        while (rs.next()) {
                            sb.append(LazyMap({for (i in range) mapColumn(rs, meta, i)}));
                        }
                    }
                    return sb.sequence;
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         row from the result only. The SQL string must use the '?' parameter
         placeholders."
    shared default Map<String, Object>? firstRow(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    value meta = rs.metaData;
                    value range = 1..meta.columnCount;
                    if (rs.next()) {
                        return LazyMap({ for (i in range) mapColumn(rs, meta, i) });
                    }
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
        return null;
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as an Integer value. The SQL string must
         use the '?' parameter placeholders."
    shared default Integer? queryForInteger(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    return rs.getLong(1);
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a Float. The SQL string must
         use the '?' parameter placeholders."
    shared default Float? queryForFloat(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    return rs.getDouble(1);
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a Boolean. The SQL string must
         use the '?' parameter placeholders."
    shared default Boolean? queryForBoolean(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    return rs.getBoolean(1);
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a Decimal. The SQL string must
         use the '?' parameter placeholders."
    shared default Decimal? queryForDecimal(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    if (exists d=rs.getBigDecimal(1)) {
                        //TODO optimize this
                        return parseDecimal(d.toPlainString());
                    }
                    return null;
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a Whole. The SQL string must
         use the '?' parameter placeholders."
    shared default Whole? queryForWhole(String sql, Object* params) {
        return null;
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a String. The SQL string must
         use the '?' parameter placeholders."
    shared default String? queryForString(String sql, Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    if (exists s=rs.getString(1)) {
                        return s;
                    }
                    return null;
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute a SQL query with the given parameters, and return the first
         column of the first result, as a Float. The SQL string must
         use the '?' parameter placeholders."
    shared default Value? queryForValue<Value>(String sql, Object* params)
            given Value satisfies Object {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            stmt.maxRows=1;
            try {
                value rs = stmt.executeQuery();
                try {
                    rs.next();
                    /*if (is Value s=rs.getObject(1)) {
                        return s;
                    }*/
                    return null;
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Execute the passed Callable within a database transaction. If any
         exception is thrown from within the Callable, the transaction will
         be rolled back; otherwise it is committed."
    shared default void transaction(Boolean do()) {
        value conn = conns.get();
        conn.beginTransaction();
        variable value ok = false;
        try {
            ok = do();
        } finally {
            try {
                if (ok) {
                    conn.commit();
                } else {
                    conn.rollback();
                }
            } finally {
                conn.close();
            }
        }
    }

    doc "Execute a SQL query with the given parameters, and call the specified method
         with each obtained row."
    shared default void eachRow(
            doc "The SQL query to execute."
            String sql,
            doc "The method to call with each row."
            void body(Map<String, Object> row),
            doc "The maximum number of rows to process. Default -1 which means all rows."
            Integer limit=-1,
            doc "The number of rows to skip from the result before starting processing. Default 0."
            Integer offset=0,
            doc "The parameters to pass to the SQL query."
            Object* params) {
        value conn = conns.get();
        try {
            value stmt = prepareStatement(conn, sql, params);
            if (limit > 0 && offset <= 0) {
                stmt.maxRows=limit;
            }
            try {
                value rs = stmt.executeQuery();
                try {
                    value meta = rs.metaData;
                    value range = 1..meta.columnCount;
                    value cont = offset > 0 then (1..offset).every((Integer x) => rs.next()) else true;
                    if (limit > 0) {
                        variable value count = 0;
                        while (count < limit && rs.next()) {
                            body(LazyMap({for (i in range) mapColumn(rs, meta, i)}));
                            count++;
                        }
                    } else if (cont) {
                        while (rs.next()) {
                            body(LazyMap({for (i in range) mapColumn(rs, meta, i)}));
                        }
                    }
                    return;
                } finally {
                    rs.close();
                }
            } finally {
                stmt.close();
            }
        } finally {
            conn.close();
        }
    }

    doc "Create an `Entry` from the column data at the specified index."
    String->Object mapColumn(ResultSet rs, ResultSetMetaData meta, Integer idx) {
        String columnName = meta.getColumnName(idx).lowercased;
        Object? x = rs.getObject(idx);
        Object? v;
        //TODO optimize these conversions
        switch (x)
        case (is Long) { v = x.longValue(); }
        case (is JString) { v = x.string; }
        case (is BigDecimal) { v = parseDecimal(x.toPlainString()); }
        case (is BigInteger) { v = parseWhole(x.string); }
        else { v = x; }
        return columnName -> (v else DbNull(meta.getColumnType(idx)));
    }

}
