import java.lang {
    ObjectArray
}

import javax.sql {
    ConnectionEvent,
    ConnectionEventListener,
    XAConnection,
    XADataSource
}
import javax.transaction.xa {
    XAResource
}
shared class RecoveryHelper satisfies XAResourceRecoveryHelper {
    
    variable String _binding;
    variable String _user;
    variable String _password;
    variable XAConnection? _connection = null;
    variable XADataSource? _dataSource = null;
    variable ConnectionEventListener? _connectionEventListener = null;
    variable Boolean _hasMoreResources = false;
    
    shared new (XADataSource dataSource) {
        this._dataSource = dataSource;
    }
    
    shared new (
            XADataSource dataSource, String bindingOrURL, 
            String user, String password) {
        this._dataSource = dataSource;
        this._binding = bindingOrURL;
        this._user = user;
        this._password = password;
        _hasMoreResources = false;
        _connectionEventListener 
                = object satisfies ConnectionEventListener {
            shared actual void connectionErrorOccurred(
                ConnectionEvent connectionEvent) {
                assert (exists listener = _connectionEventListener,
                    exists connection = _connection);
                connection.removeConnectionEventListener(listener);
                _connection = null;
            }
            shared actual void connectionClosed(
                ConnectionEvent connectionEvent) {
                assert (exists listener = _connectionEventListener,
                    exists connection = _connection);
                connection.removeConnectionEventListener(_connectionEventListener);
                _connection = null;
            }
            
        };
    }
    
    shared actual Boolean initialise(String p) => true;
    
    shared actual ObjectArray<XAResource> xaResources 
            => ObjectArray<XAResource>(1, xaResource);
    
    shared actual XAResource? xaResource {
        if (exists ds = _dataSource) {
            return RecoveryXAResource(ds);
        }
        return null;
    }
    
    shared actual Boolean hasMoreResources() {
        if (exists ds = _dataSource) {
            _hasMoreResources = !_hasMoreResources;
            return _hasMoreResources;
        }
        return false;
    }
    
}
