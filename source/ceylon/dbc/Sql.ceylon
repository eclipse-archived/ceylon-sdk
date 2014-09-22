import ceylon.collection {
    HashMap,
    ArrayList
}
import ceylon.dbc {
    newConnectionFromDataSource
}
import ceylon.interop.java {
    toIntegerArray,
    createJavaObjectArray,
    javaByteArray
}
import ceylon.language.meta.model {
    Type
}
import ceylon.math.decimal {
    Decimal,
    parseDecimal
}
import ceylon.math.whole {
    parseWhole
}
import ceylon.time {
    today,
    Instant,
    Time,
    DateTime,
    Date
}
import ceylon.time.internal {
    GregorianDateTime,
    GregorianDate,
    TimeOfDay
}

import java.io {
    ByteArrayInputStream
}
import java.lang {
    JBoolean=Boolean,
    JInteger=Integer,
    JLong=Long,
    JString=String,
    ObjectArray,
    ByteArray
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
    SqlArray=Array,
    SqlTimestamp=Timestamp,
    SqlTime=Time,
    SqlDate=Date,
    Statement {
        returnGeneratedKeys=RETURN_GENERATED_KEYS
    },
    Connection
}
import java.util {
    JDate=Date,
    UUID
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
    see (`function newConnectionFromDataSource`,
        `function newConnectionFromDataSourceWithCredentials`)
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
            case (is Integer) { 
                stmt.setLong(i,argument); 
            }
            case (is Boolean) { 
                stmt.setBoolean(i,argument); 
            }
            case (is String)  { 
                stmt.setString(i,argument); 
            }
            case (is Decimal) {
                assert (is BigDecimal bd = argument.implementation);
                stmt.setBigDecimal(i,bd); 
            }
            case (is JDate) {
                if (is SqlTimestamp argument) {
                    stmt.setTimestamp(i, argument);
                } 
                else if (is SqlTime argument) {
                    stmt.setTime(i, argument);
                }
                else if (is SqlDate argument) {
                    stmt.setDate(i, argument);
                }
                else {
                    stmt.setTimestamp(i, SqlTimestamp(argument.time));
                }
            }
            case (is Float) { 
                stmt.setDouble(i, argument); 
            }
            case (is SqlNull) { 
                stmt.setNull(i, argument.sqlType); 
            }
            case (is GregorianDateTime) {
                stmt.setTimestamp(i, 
                    SqlTimestamp(argument.instant().millisecondsOfEpoch));
            }
            case (is GregorianDate) {
                stmt.setDate(i, 
                    SqlDate(argument.at(TimeOfDay(0)).instant().millisecondsOfEpoch));
            }
            case (is TimeOfDay) {
                stmt.setTime(i, 
                    SqlTime(today().at(argument).instant().millisecondsOfEpoch));
            }
            // UUID conversion works in the else also, this is a placeholder in case Ceylon gets a native UUID type.
            case(is UUID) {
                stmt.setObject(i, argument);
            }
            case(is ObjectArray<Object>) {
                stmt.setArray(i, connection.get().createSqlArray( argument, sqlArrayType(argument)));
            }
            case(is Array<String>) {
                setArray(i, argument, stmt);
            }
            case(is Array<Integer>) {
                setArray(i, argument, stmt);
            }
            case(is Array<UUID>) {
                setArray(i, argument, stmt);
            }
            case(is Array<Date>) {
                setArray(i, argument, stmt);
            }
            case(is Array<Boolean>) {
                setArray(i, argument, stmt);
            }
            case(is Array<Float>) {
                setArray(i, argument, stmt);
            }
            case(is Array<Time>) {
                setArray(i, argument, stmt);
            }
            case(is Array<DateTime>) {
                setArray(i, argument, stmt);
            }
            case(is Array<GregorianDate>) {
                setArray(i, argument, stmt);
            }
            case(is Array<TimeOfDay>) {
                setArray(i, argument, stmt);
            }
            case(is ByteArray) {
                setBinaryStream(i, argument, stmt);
            }
            case(is Array<Byte>) {
                setBinaryStream(i, argument, stmt);
            }
            //TODO reader, inputStream, byte array
            else { stmt.setObject(i,argument); }
            i++;
        }
    }

    void setArray<in ArrayType>(Integer position, Array<ArrayType> array, PreparedStatement stmt) 
            given ArrayType satisfies Object { 
        Type<ArrayType> type = `ArrayType`;
        
        String sqlArrayType;

        if (type.exactly(`String`)) {
            sqlArrayType = "varchar";
        } else if (type.exactly(`Integer`)) {
            sqlArrayType = "integer";
        } else if (type.exactly(`Decimal`)) {
            sqlArrayType = "decimal";
        } else if (type.exactly(`Boolean`)) {
            sqlArrayType = "boolean";
        } else if (type.exactly(`Float`)) {
            sqlArrayType = "float";
        } else if (type.exactly(`Date`)) {
            sqlArrayType = "date";
        } else if (type.exactly(`Time`)) {
            sqlArrayType = "time";
        } else if (type.exactly(`DateTime`)) {
            sqlArrayType = "timestamp";
        } else if (type.exactly(`GregorianDate`)) {
            sqlArrayType = "date";
        } else if (type.exactly(`TimeOfDay`)) {
            sqlArrayType = "time";
        // This is a special case not part of JDBCTypes but is supported by H2 and PostgreSQL.
        } else if (type.exactly(`UUID`)) {
            sqlArrayType = "uuid";
        } else {
            throw Exception("Unknown or unsupported array type for SQL array conversion: ``array``");
        }

        stmt.setArray(position, 
            connection.get().createSqlArray(createJavaObjectArray<Object>(array), sqlArrayType));
    }
    
    void setBinaryStream(Integer position, ByteArray|Array<Byte> array, PreparedStatement stmt ) {
        ByteArray byteArray;
        
        switch (array)
            case (is ByteArray) {
                byteArray = array;
            }
            case (is Array<Byte>) {
                byteArray = javaByteArray(array);
            }

        stmt.setBinaryStream(position, ByteArrayInputStream(byteArray), byteArray.size); 
    }
    
    String sqlArrayType(ObjectArray<Object> argument) {
        if (argument.size > 0) {
            value first = argument.get(0);
            
            /*
             TODO:  Due to https://github.com/ceylon/ceylon-compiler/issues/1753, we need to check the type of 
                    first element of the array to determine the type of the database array.
                    There is also the question of non-standard behaviour for at least on database, PostgreSQL,
                    which will only accept lowercase versions of the types below.  (ex varchar, but not VARCHAR).
                    As well, JDK 8 has java.sql.JDBCType that contains these String values, but JDK 7 does not,
                    which is why the values below are hard-coded.
                    
             */
            switch (first)
            case (is String) {
                return "varchar";
            }
            case (is Integer) {
                return "integer";
            }
            case (is Boolean) {
                return "boolean";
            }
            case (is Decimal) {
                return "decimal";
            }
            case (is Float) {
                return "float";
            }
            case (is JDate) {
                if (is SqlTimestamp first) {
                    return "timestamp";
                } 
                else if (is SqlTime first) {
                    return "time";
                }
                else if (is SqlDate first) {
                    return "date";
                }
                else {
                    return "timestamp";
                }
            }
            case (is GregorianDateTime) {
                return "timestamp";
            }
            case (is GregorianDate) {
                return "date";
            }
            case (is TimeOfDay) {
                return "time";
            }
            // This is a special case not part of JDBCTypes but is supported by H2 and PostgreSQL.
            case (is UUID) {
                return "uuid";
            }
            else {
                // TODO:  All other possible array types
                throw Exception("Unsupported array data type");
            }
        }

        // TODO: This is a bug.  If it's the user's intent to provide an empty array, it is impossible to know
        // which type that array is for.  Fixing this is blocked by: 
        // https://github.com/ceylon/ceylon-compiler/issues/1753
        throw Exception("Cannot infer the type of an empty array so it will be impossible to insert or update it");
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
        
        "Execute this statement multiple times, as a batch
         update, once for each given sequence of arguments, 
         returning a sequence containing the numbers of rows 
         affected by each update in the batch."
        shared Integer[] executeBatch({[Object*]*} batchArguments,
                "The maximum number of inserts that will be
                 batched into memory before being sent to
                 the database."
                Integer maxBatchSize=250) {
            "maximum batch size must be strictly positive"
            assert (maxBatchSize>0);
            if (exists firstArgs = batchArguments.first) {
                assert (batchArguments.fold(true) 
                    ((consistent, args) => 
                        consistent && args.size==firstArgs.size));
                value connectionStatus = connection.get();
                try {
                    value stmt = connectionStatus.connection()
                            .prepareStatement(sql);
                    value result = ArrayList<Integer>();
                    void runBatch()
                            => result.addAll(toIntegerArray(stmt.executeBatch()));
                    variable value count=0;
                    try {                    
                        for (arguments in batchArguments) {
                            setParameters(stmt, arguments);
                            stmt.addBatch();
                            if (++count>maxBatchSize) {
                                runBatch();
                                count=0;
                            }
                        }
                        if (count!=0) {
                            runBatch();
                        }
                        return result.sequence();
                    }
                    finally {
                        stmt.close();
                    }
                }
                finally {
                    connectionStatus.close();
                }
            }
            else {
                return [];
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
                        value builder = ArrayList<Row>();
                        while (resultSet.next()) {
                            builder.add(HashMap { for (i in range) columnEntry(resultSet, meta, i) });
                        }
                        return [updateCount, builder.sequence()];
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
        
        "Execute this statement multiple times, as a batch
         insert, once for each given sequence of arguments, 
         returning a sequence containing the numbers of rows 
         affected by each insert in the batch."
        shared void executeBatch({[Object*]*} batchArguments,
                "The maximum number of inserts that will be
                 batched into memory before being sent to
                 the database."
                Integer maxBatchSize=250) {
            "maximum batch size must be strictly positive"
            assert (maxBatchSize>0);
            if (exists firstArgs = batchArguments.first) {
                assert (batchArguments.fold(true) 
                    ((consistent, args) => 
                        consistent && args.size==firstArgs.size));
                value connectionStatus = connection.get();
                try {
                    value stmt = connectionStatus.connection()
                            .prepareStatement(sql);
                    value result = ArrayList<Integer>();
                    void runBatch()
                            => result.addAll(toIntegerArray(stmt.executeBatch()));
                    variable value count=0;
                    try {                    
                        for (arguments in batchArguments) {
                            setParameters(stmt, arguments);
                            stmt.addBatch();
                            if (++count>maxBatchSize) {
                                runBatch();
                                count=0;
                            }
                        }
                        if (count!=0) {
                            runBatch();
                        }
                        //TODO: generated keys?
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
                return results.sequence();
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
        
        "Execute this query with the given [[arguments]] to 
         its parameters, returning a single value. The query 
         result must be single row/single column containing
         a value assignable to the given type.
         
             value count = sql.Select(\"select count(*) from table\")
                     .singleValue<Integer>();"
        shared Value singleValue<Value>(Object* arguments) {
            value rows = execute(*arguments);
            "SQL query must return a single row containing a 
             single value of the given type"
            assert(exists row = rows[0], 
                   rows.size == 1, 
                   row.size == 1, 
                   is Value v = row.items.first);
            return v;
        }        
        
        "Execute this query with the given [[arguments]] to 
         its parameters. The resulting instance of `Results` 
         may be iterated, producing [[Row]]s lazily.
         
         Should be instantiated using `try`:
         
             try (results = sql.Select(\"select * from table\").Results()) {
                 for (row in results) {
                     //read the row here
                 }
             }"
        shared class Results(Object* arguments) 
                satisfies Destroyable & {Row*} {
            variable ConnectionStatus connectionStatus=connection.get();
            variable PreparedStatement preparedStatement;
            variable {Object*} resultSets; //TODO: should be ResultSet, nasty hack to work around backend bug!
            try {
                preparedStatement=prepareStatement(connectionStatus, sql, arguments);
                if (exists maxRows = limit) {
                    preparedStatement.maxRows=maxRows;
                }
                resultSets={}; //TODO: should be ResultSet, nasty hack to work around backend bug!
            } catch (Exception e) {
                try {
                    connectionStatus.close();
                } catch (Exception e2) {
                    e.addSuppressed(e2);
                }
                throw e;
            }
            
            shared actual Iterator<Row> iterator() {
                object iterator
                        satisfies Iterator<Row> {
                    value resultSet = preparedStatement.executeQuery();
                    resultSets = resultSets.follow(resultSet);
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
            
            shared actual void destroy(Throwable? exception) {
                for (resultSet in this.resultSets) {
                    try {
                        assert (is ResultSet resultSet); //TODO: should not be necessary, nasty hack to work around backend bug!
                        resultSet.close();
                    }
                    catch (e) {}
                }
                this.resultSets = [];
                try {
                    preparedStatement.close();
                }
                catch (e) {}
                try {
                    connectionStatus.close();
                }
                catch (e) {}
            
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
    shared class Transaction() satisfies Destroyable {
        variable value rollback = false;
        
        variable ConnectionStatus connectionStatus=connection.get();
        try {
            connectionStatus.beginTransaction();
        } catch (Exception e) {
            try {
                connectionStatus.rollback();
            } catch (Exception e2) {
                e.addSuppressed(e2);
            }
            try {
                connectionStatus.close();
            } catch (Exception e2) {
                e.addSuppressed(e2);
            }
            throw e;
        }
        
        "Set the transaction to roll back."
        shared void rollbackOnly() {
            rollback=true;
        }
        
        shared actual void destroy(Throwable? exception) {
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
        String columnName = meta.getColumnLabel(idx).lowercased;
        Object? x = rs.getObject(idx);
        Object? v;
        
        // Can't put this in the switch statement because Array is an interface so there will be a disjoint
        // types error with the other types in the switch statement below.
        if (is SqlArray x) {
            value javaArray = x.array;
            assert(is ObjectArray<Object> javaArray);
            v = javaArray.array.sequence();
        }
        else {
            //TODO optimize these conversions
            switch (x)
            case (is JBoolean) { v = x.booleanValue(); }
            case (is JInteger) { v = x.intValue(); }
            case (is JLong) { v = x.longValue(); }
            case (is JString) { v = x.string; }
            case (is BigDecimal) { v = parseDecimal(x.toPlainString()); }
            case (is BigInteger) { v = parseWhole(x.string); }
            case (is SqlTimestamp) { v = Instant(x.time).dateTime(); }
            case (is SqlTime) { v = Instant(x.time).time(); }
            case (is SqlDate) { v = Instant(x.time).date(); }
            // UUID conversion works in the else also, this is a placeholder in case Ceylon gets a native UUID type.
            case (is UUID) { v = x; }
            case (is ByteArray) {v = x.byteArray; }
            else { v = x; }
        }

        return columnName -> (v else SqlNull(meta.getColumnType(idx)));
    }
}

