import java.sql { Connection }
import javax.sql { DataSource }
import java.lang { ThreadLocal }

class ConnectionStatus(DataSource ds) {

    variable value tx=false;
    variable Connection? conn=null;
    variable value use=0;

    doc "Creates a new connection if needed and returns it."
    shared Connection connection() {
        if (exists c=conn) {
            if (!c.closed) {
				use++;
                return c;
            }
        }
        conn = ds.connection;
        if (exists c=conn) {
			use++;
            return c;
        }
        throw;
    }

    doc "Closes the connection if it's not being used anymore."
    shared void close() {
        if (exists c=conn) {
			use--;
            if (!tx && use==0) {
                c.close();
            }
        }
    }

    doc "Begins a transaction in the current connection."
    shared void beginTransaction() {
        connection().autoCommit=false;
        tx = true;
    }

    doc "Commits the current transaction, clearing the transaction flag.
         If an exception is thrown, the transaction will be rolled back
         and the exception rethrown."
    shared void commit() {
        try {
            connection().commit();
        } catch (Exception ex) {
            connection().rollback();
            throw ex;
        } finally {
            tx = false;
        }
    }

    doc "Rolls back the current transaction, clearing the transaction flag."
    shared void rollback() {
        connection().rollback();
        tx = false;
    }
}

class ThreadLocalConnection(DataSource ds) extends ThreadLocal<ConnectionStatus>() {
    shared ConnectionStatus initialValue() {
        return ConnectionStatus(ds);
    }
}
