import java.sql {
    SQLException
}
import javax.sql {
    XAConnection,
    XADataSource
}
import javax.transaction.xa {
    XAException,
    XAResource,
    Xid
}
import java.lang {
    ObjectArray
}
shared class RecoveryXAResource satisfies XAResource {
    
    variable XADataSource dataSource;
    variable XAConnection? connection = null;
    variable String? user;
    variable String? password;
    variable XAResource? xar = null;
    
    shared new (XADataSource dataSource, 
            String user, String password) {
        this.dataSource = dataSource;
        this.user = user;
        this.password = password;
    }
    
    shared new (XADataSource dataSource) {
        this.dataSource = dataSource;
        this.user = null;
        this.password = null;
    }
        
        shared actual void commit(Xid xid, Boolean onePhase) 
                => xar?.commit(xid, onePhase);
        
        shared actual void end(Xid xid, Integer flags) 
                => xar?.end(xid, flags);
        
        shared actual void forget(Xid xid) 
                => xar?.forget(xid);
        
        shared actual Integer transactionTimeout 
                => xar?.transactionTimeout else 0;
        
        shared actual Boolean isSameRM(XAResource xaResource) 
                => xar?.isSameRM(xaResource) else false;
        
        shared actual Integer prepare(Xid xid) 
                => xar?.prepare(xid) else 0;
        
        shared actual void rollback(Xid xid) 
                => xar?.rollback(xid);
        
        shared actual Boolean setTransactionTimeout(Integer seconds) 
                => xar?.setTransactionTimeout(seconds) else false;
        
        shared actual void start(Xid xid, Integer flags) 
                => xar?.start(xid, flags);
        
        XAResource? xaResource {
            if (exists r=xar) {
                return r;
            }
            if (!connection exists) {
                try {
                    if (exists u=user, exists p=password) {
                        connection = dataSource.getXAConnection(u, p);
                    }
                    else {
                        connection = dataSource.xaConnection;
                    }
                }
                catch (SQLException e) {
                    xar = null;
                    throw XAException(XAException.\iXAER_RMERR);
                }
            }
            assert (exists c=connection);
            try {
                xar = c.xaResource;
                return xar;
            }
            catch (SQLException e) {
                xar = null;
                closeConnection();
                throw XAException(XAException.\iXAER_RMERR);
            }
        }
        
        void closeConnection() {
            try {
                connection?.close();
            }
            catch (SQLException e) {
                //swallow it?
            }
            finally {
                xar = null;
                connection = null;
            }
        }
        
        shared actual ObjectArray<Xid> recover(Integer flag) {
            if (flag == \iTMSTARTRSCAN) {
                assert (exists r=xaResource);
                return r.recover(flag);
            }
            else if (flag == \iTMNOFLAGS) {
                if (exists r=xar) {
                    try {
                        return r.recover(flag);
                    }
                    catch (XAException e) {
                        closeConnection();
                        throw e;
                    }
                }
                else {
                    closeConnection();
                    throw XAException(XAException.\iXAER_INVAL);
                }
            }
            else if (flag == \iTMENDRSCAN) {
                try {
                    if (exists r=xar) {
                        return r.recover(flag);
                    }
                    else {
                        throw XAException(XAException.\iXAER_INVAL);
                    }
                }
                finally {
                    closeConnection();
                }
            }
            else {
                closeConnection();
                throw XAException(XAException.\iXAER_INVAL);
            }
        }
        
    }
