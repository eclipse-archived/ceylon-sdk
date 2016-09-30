package ceylon.transaction.internal;

import java.sql.SQLException;

import javax.sql.ConnectionEvent;
import javax.sql.ConnectionEventListener;
import javax.sql.XAConnection;
import javax.sql.XADataSource;
import javax.transaction.xa.XAResource;

import com.arjuna.ats.jta.recovery.XAResourceRecovery;
import com.arjuna.ats.jta.recovery.XAResourceRecoveryHelper;

public class RecoveryHelper implements XAResourceRecoveryHelper, XAResourceRecovery {
//    private String _binding;
//    private String _user;
//    private String _password;
    private XAConnection _connection;
    private XADataSource _dataSource;
    private LocalConnectionEventListener _connectionEventListener;
    private boolean _hasMoreResources;

    public RecoveryHelper(XADataSource dataSource) {
        this._dataSource = dataSource;
    }

    public RecoveryHelper(XADataSource dataSource, String bindingOrURL, String user, String password) {
        this._dataSource = dataSource;
//        this._binding = bindingOrURL;
//        this._user = user;
//        this._password = password;

        _hasMoreResources        = false;
        _connectionEventListener = new LocalConnectionEventListener();
    }

    @Override // XAResourceRecovery and XAResourceRecoveryHelper
    public boolean initialise(String p) throws SQLException {
        return true;
    }

    @Override // XAResourceRecoveryHelper
    public XAResource[] getXAResources() throws Exception {
        return new XAResource[] {getXAResource()};
    }

    @Override
    public synchronized XAResource getXAResource() throws SQLException {
        if (_dataSource == null)
            return null;

        return new RecoveryXAResource(_dataSource);
    }

    @Override // XAResourceRecovery
    public boolean hasMoreResources()
    {
        if (_dataSource == null) {
            return false;
        }

        _hasMoreResources = ! _hasMoreResources;

         return _hasMoreResources;
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
