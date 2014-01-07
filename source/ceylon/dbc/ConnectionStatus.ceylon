import java.sql {
    Connection
}

class ConnectionStatus(Connection() connectionSource) {

    variable value tx=false;
    variable Connection? conn=null;
    variable value use=0;

    "Creates a new connection if needed and returns it."
    shared Connection connection() {
        if (exists c=conn) {
            if (!c.closed) {
				use++;
                return c;
            }
        }
        conn = connectionSource();
        if (exists c=conn) {
			use++;
            return c;
        }
        throw;
    }

    "Closes the connection if it's not being used anymore."
    shared void close() {
        if (exists c=conn) {
			use--;
            if (!tx && use==0) {
                c.close();
            }
        }
    }

    "Begins a transaction in the current connection."
    shared void beginTransaction() {
        connection().autoCommit=false;
        tx = true;
    }

    "Commits the current transaction, clearing the 
     transaction flag. If an exception is thrown, the 
     transaction will be rolled back and the exception 
     rethrown."
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

    "Rolls back the current transaction, clearing the 
     transaction flag."
    shared void rollback() {
        connection().rollback();
        tx = false;
    }
}
