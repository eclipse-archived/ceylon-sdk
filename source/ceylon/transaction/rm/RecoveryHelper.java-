package ceylon.transaction.rm;

import com.arjuna.ats.jdbc.common.jdbcPropertyManager;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.ConnectionEvent;
import javax.sql.ConnectionEventListener;
import javax.sql.XAConnection;
import javax.sql.XADataSource;

import javax.transaction.xa.XAResource;
import java.util.*;

import java.sql.SQLException;

import com.arjuna.ats.jdbc.logging.jdbcLogger;
import com.arjuna.ats.jta.recovery.XAResourceRecovery;
import com.arjuna.ats.jta.recovery.XAResourceRecoveryHelper;

public class RecoveryHelper implements XAResourceRecoveryHelper, XAResourceRecovery {
    private String _binding;
    private String _user;
    private String _password;
    private XAConnection _connection;
    private XADataSource _dataSource;
    private LocalConnectionEventListener _connectionEventListener;
    private boolean _hasMoreResources;

    public RecoveryHelper(String binding, String user, String password) {
        this._binding = binding;
        this._user = user;
        this._password = password;

        _hasMoreResources        = false;
        _connectionEventListener = new LocalConnectionEventListener();
    }

    @Override
    public boolean initialise(String p) throws SQLException {
        return true;
    }

    @Override
    public XAResource[] getXAResources() throws Exception {
        return new XAResource[0];
        //return new XAResource[] {getXAResource()};
    }

    @Override
    public synchronized XAResource getXAResource()
        throws SQLException
    {
        createConnection();

        return _connection.getXAResource();
    }

    @Override
    public boolean hasMoreResources()
    {
        if (_dataSource == null) {
            try {
                createDataSource();
            } catch (SQLException sqlException) {
                return false;
            }
        }

        _hasMoreResources = ! _hasMoreResources;

         return _hasMoreResources;
    }

    /**
     * Lookup the XADataSource in JNDI (the relevant information was provided in the constructor
     */
    private final void createDataSource()
        throws SQLException
    {
        try
        {
            if (_dataSource == null) {
                Hashtable env = jdbcPropertyManager.getJDBCEnvironmentBean().getJndiProperties();
                Context context = new InitialContext(env);
                _dataSource = (XADataSource) context.lookup(_binding);

                if (_dataSource == null)
                    throw new SQLException(jdbcLogger.i18NLogger.get_xa_recjndierror());
            }
        } catch (SQLException ex) {
            ex.printStackTrace();

            throw ex;
        } catch (Exception e) {
            e.printStackTrace();

            SQLException sqlException = new SQLException(e.toString());
            sqlException.initCause(e);
            throw sqlException;
        }
    }

    /**
     * Create the XAConnection from the XADataSource.
     */
    private final void createConnection()
        throws SQLException
    {
        try
        {
            if (_dataSource == null)
                createDataSource();

            if (_connection == null)
            {
                if ((_user == null) && (_password == null))
                    _connection = _dataSource.getXAConnection();
                else
                    _connection = _dataSource.getXAConnection(_user, _password);

                _connection.addConnectionEventListener(_connectionEventListener);
            }
        }
        catch (SQLException ex)
        {
            ex.printStackTrace();

            throw ex;
        }
        catch (Exception e)
        {
            e.printStackTrace();

            SQLException sqlException = new SQLException(e.toString());
            sqlException.initCause(e);
            throw sqlException;
        }
    }

    private class LocalConnectionEventListener implements ConnectionEventListener
    {
        public void connectionErrorOccurred(ConnectionEvent connectionEvent)
        {
            _connection.removeConnectionEventListener(_connectionEventListener);
            _connection = null;
        }

        public void connectionClosed(ConnectionEvent connectionEvent)
        {
            _connection.removeConnectionEventListener(_connectionEventListener);
            _connection = null;
        }
    }
}
