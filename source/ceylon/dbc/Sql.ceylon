import ceylon.collection {
    HashMap
}
import ceylon.dbc {
    newConnectionFromDatasource
}
import ceylon.math.decimal {
    Decimal,
    parseDecimal
}
import ceylon.math.whole {
    parseWhole
}

import java.lang {
    Long,
    JString=String
}
import java.math {
    BigDecimal,
    BigInteger
}
import java.sql {
    PreparedStatement,
    CallableStatement,
    ResultSet,
    ResultSetMetaData,
    Timestamp,
    SqlDate=Date,
    Statement {
        returnGeneratedKeys=RETURN_GENERATED_KEYS
    },
    Connection
}
import java.util {
    Date
}

"A row of results is represented as a [[Map]] with column
 names as keys, and values as items."
shared alias Row=>Map<String,Object>;

"An object that exposes operations for executing SQL DML or
 DDL queries against JDBC connections obtained by calling a 
 given [[function|newConnection]]."
by ("Enrique Zamudio", "Gavin King")
shared class Sql(newConnection) {
    
    "Obtain a JDBC connection."
    see (`function newConnectionFromDatasource`,
        `function newConnectionFromDatasourceWithCredentials`)
    Connection newConnection();
    
    value connection = ThreadLocalConnection(newConnection);
    
    PreparedStatement prepareStatement(ConnectionStatus conn, String sql, {Object*} arguments) {
        value stmt = conn.connection().prepareStatement(sql);
        setParameters(stmt, arguments);
        return stmt;
    }
    
    void setParameters(PreparedStatement stmt, {Object*} arguments) {
        variable value i=1;
        for (argument in arguments) {
            switch (argument)
            case (is Integer) { stmt.setLong(i,argument); }
            case (is Boolean) { stmt.setBoolean(i,argument); }
            case (is String)  { stmt.setString(i,argument); }
            case (is Decimal) {
                assert (is BigDecimal bd = argument.implementation);
                stmt.setBigDecimal(i,bd); 
            }
            case (is Date) {
                if (is Timestamp argument) {
                    stmt.setTimestamp(i,argument);
                } else if (is SqlDate argument) {
                    stmt.setDate(i, argument);
                } else {
                    stmt.setDate(i, SqlDate(argument.time));
                }
            }
            case (is Float) { stmt.setDouble(i, argument); }
            case (is SqlNull) { stmt.setNull(i, argument.sqlType); }
            //TODO reader, inputStream, byte array
            else { stmt.setObject(i,argument); }
            i++;
        }
    }
    
    CallableStatement prepareCall(ConnectionStatus conn, String sql, {Object*} arguments) {
        value stmt = conn.connection().prepareCall(sql);
        setParameters(stmt, arguments);
        return stmt;
    }
    
    "Define a SQL [[statement|sql]] with parameters
     indicated by `?` placeholders."
    shared class Statement(String sql) {
        "Execute this statement with the given [[arguments]] 
         to its parameters."
        shared void execute(Object* arguments) {
            value connectionStatus = connection.get();
            try {
                value stmt = prepareStatement(connectionStatus, sql, arguments);
                try {
                    stmt.execute();
                } finally {
                    stmt.close();
                }
            } finally {
                connectionStatus.close();
            }
        }
    }
    
    "Define a SQL `update` or `delete` [[statement|sql]] 
     with parameters indicated by `?` placeholders."
    shared class Update(String sql) {
        "Execute this statement with the given [[arguments]] 
         to its parameters, returning the number of affected 
         rows."
        shared Integer execute(Object* arguments) {
            value connectionStatus = connection.get();
            try {
                value stmt = prepareStatement(connectionStatus, sql, arguments);
                try {
                    return stmt.executeUpdate();
                } finally {
                    stmt.close();
                }
            } finally {
                connectionStatus.close();
            }
        }
        
        "Execute this statement in a batch with the given batch of supplied arguments,
         returning the sequence containing the numbers of rows affected by each update in the batch."
        shared Integer[] executeBatch(Integer batchSize, {{Object*}*} batchArguments) {
            value connectionStatus = connection.get();
            try {
                value stmt = prepareStatement(connectionStatus, sql, []);
                try {
                    value affectedRows = SequenceBuilder<Integer>();
                    
                    variable value i = 0;
                    for(arguments in batchArguments) {
                        setParameters(stmt, arguments);
                        stmt.addBatch();
                        
                        i++;
                        if( i % batchSize == 0 || i == batchArguments.size) {
                            value results = stmt.executeBatch();
                            affectedRows.appendAll({for(result in results.array) result.intValue()});
                        }
                    }
                    
                    return affectedRows.sequence;
                }
                finally {
                    stmt.close();
                }
            }
            finally {
                connectionStatus.close();
            }
        }
        
    }
    
    "Define a SQL `insert` [[statement|sql]] with parameters 
     indicated by `?` placeholders."
    shared class Insert(String sql) {
        "Execute this statement with the given [[arguments]] 
         to its parameters, returning number of rows 
         inserted, and the generated keys, if any."
        shared [Integer,Row[]] execute(Object* arguments) {
            value connectionStatus = connection.get();
            try {
                value stmt = connectionStatus.connection()
                        .prepareStatement(sql, returnGeneratedKeys);
                try {
                    setParameters(stmt, arguments);
                    value updateCount = stmt.executeUpdate();
                    value resultSet = stmt.generatedKeys;
                    try {
                        value meta = resultSet.metaData;
                        value range = 1..meta.columnCount;
                        value builder = SequenceBuilder<Row>();
                        while (resultSet.next()) {
                            builder.append(HashMap { for (i in range) columnEntry(resultSet, meta, i) });
                        }
                        return [updateCount, builder.sequence];
                    }
                    finally {
                        resultSet.close();
                    }
                }
                finally {
                    stmt.close();
                }
            }
            finally {
                connectionStatus.close();
            }
        }
    }
    
    "Define a SQL callable [[statement|sql]], with 
     parameters indicated by `?` placeholders. Intended for 
     calling database functions or stored procedures that 
     update or delete rows."
    shared class Call(String sql) {
        "Execute this statement with the given [[arguments]] 
         to its parameters, returning the number of affected 
         rows."
        shared Integer execute(Object* arguments) {
            value connectionStatus = connection.get();
            try {
                value stmt = prepareCall(connectionStatus, sql, arguments);
                try {
                    return stmt.executeUpdate();
                } finally {
                    stmt.close();
                }
            } finally {
                connectionStatus.close();
            }
        }
    }
    
    "Define a SQL `select` [[query|sql]] with parameters 
     indicated by `?` placeholders."
    shared class Select(String sql) {
        
        "An optional limit to the number of rows to return."
        shared variable Integer? limit=null;
        
        "Execute this query with the given [[arguments]] 
         to its parameters, returning a sequence of [[Row]]s."
        shared Row[] execute(Object* arguments) {
            try (results = Results(*arguments)) {
                return results.sequence;
            }
        }
        
        "Execute this query with the given [[arguments]] 
         to its parameters, and for each resulting [[Row]],
         call the given [[function|do]]."
        shared void forEachRow(Object* arguments)(void do(Row row)) {
            try (results = Results(*arguments)) {
                for (row in results) {
                    do(row);
                }
            }
        }
        
        "Execute this query with the given [[arguments]] 
         to its parameters. The resulting instance of 
         `Results` may be iterated, producing [[Row]]s 
         lazily.
         
         Should be instantiated using `try`:
         
             try (results = sql.Select(\"select * from table\").Results()) {
                 for (row in results) {
                     //read the row here
                 }
             }"
        shared class Results(Object* arguments)
                satisfies Closeable & {Row*} {
            
            variable ConnectionStatus? connectionStatus=null;
            variable PreparedStatement? preparedStatement=null;
            variable {Object*} resultSets={}; //TODO: should be ResultSet, nasty hack to work around backend bug!
            
            shared actual void open() {
                value connectionStatus = connection.get();
                this.connectionStatus = connectionStatus;
                value preparedStatement = prepareStatement(connectionStatus, sql, arguments);
                this.preparedStatement = preparedStatement;
                if (exists maxRows = limit) {
                    preparedStatement.maxRows=maxRows;
                }
            }
            
            shared actual Iterator<Row> iterator() {
                object iterator
                        satisfies Iterator<Row> {
                    //TODO: nasty hack to work around backend bug!
                    value preparedStatement {
                        assert (exists ps = outer.preparedStatement);
                        return ps;
                    }
                    value resultSet = preparedStatement.executeQuery();
                    resultSets = resultSets.following(resultSet);
                    value meta = resultSet.metaData;
                    value range = 1..meta.columnCount;
                    shared actual Row|Finished next() {
                        if (resultSet.next()) {
                            return HashMap { for (i in range) columnEntry(resultSet, meta, i) };
                        }
                        else {
                            return finished;
                        }
                    }
                }
                return iterator;
            }
            
            shared actual void close(Exception? exception) {
                for (resultSet in this.resultSets) {
                    try {
                        assert (is ResultSet resultSet); //TODO: should not be necessary, nasty hack to work around backend bug!
                        resultSet.close();
                    }
                    catch (e) {}
                }
                this.resultSets = [];
                if (exists preparedStatement = this.preparedStatement) {
                    try {
                        preparedStatement.close();
                    }
                    catch (e) {}
                }
                this.preparedStatement = null;
                if (exists connectionStatus = this.connectionStatus) {
                    try {
                        connectionStatus.close();
                    }
                    catch (e) {}
                }
                this.connectionStatus = null;
            }
            
        }
        
    }
    
    "Begin a new database transaction. If [[rollbackOnly]]
     is called, or if an exception propagates out of `try`, 
     the transaction will be rolled back. Otherwise, the 
     transaction will be committed.
     
     Should be instantiated using `try`:
     
         try (tx = sql.Transaction()) {
             //do work here
             if (something) {
                 tx.rollbackOnly();
             }
         }"
    shared class Transaction() satisfies Closeable {
        
        variable value rollback = false;
        
        "Set the transaction to roll back."
        shared void rollbackOnly() {
            rollback=true;
        }
        
        variable ConnectionStatus? connectionStatus=null;
        
        shared actual void open() {
            value connectionStatus = connection.get();
            this.connectionStatus = connectionStatus;
            connectionStatus.beginTransaction();
        }
        
        shared actual void close(Exception? exception) {
            if (exists connectionStatus = this.connectionStatus) {
                try {
                    if (rollback||exception exists) {
                        connectionStatus.rollback();
                    }
                    else {
                        connectionStatus.commit();
                    }
                }
                finally {
                    connectionStatus.close();
                }
            }
            this.connectionStatus = null;
        }
        
    }
    
    "Execute the given [[function|do]] in a new database 
     transaction. If the function returns `false`, or if an 
     exception is thrown by the function, the transaction 
     will be rolled back."
    shared void transaction(Boolean do()) {
        try (tx = Transaction()) {
            if (!do()) {
                tx.rollbackOnly();
            }
        }
    }
    
    "An [[Entry]] with the column data at the specified 
     index."
    String->Object columnEntry(ResultSet rs, ResultSetMetaData meta, Integer idx) {
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
        return columnName -> (v else SqlNull(meta.getColumnType(idx)));
    }

}
