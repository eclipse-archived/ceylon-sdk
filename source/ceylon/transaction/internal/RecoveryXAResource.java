package ceylon.transaction.internal;

import java.sql.SQLException;

import javax.sql.XAConnection;
import javax.sql.XADataSource;
import javax.transaction.xa.XAException;
import javax.transaction.xa.XAResource;
import javax.transaction.xa.Xid;

public class RecoveryXAResource implements XAResource {
    private XADataSource dataSource;
    private XAConnection connection;
    private String user;
    private String password;

    private XAResource xar;

    public RecoveryXAResource(XADataSource dataSource, String user, String password) {
        this.dataSource = dataSource;
        this.user = user;
        this.password = password;
    }

    public RecoveryXAResource(XADataSource dataSource) {
        this(dataSource, null, null);
    }

    @Override
    public void commit(Xid xid, boolean onePhase) throws XAException {
        if (xar != null)
            xar.commit(xid, onePhase);
    }

    @Override
    public void end(Xid xid, int flags) throws XAException {
        if (xar != null)
            xar.end(xid,flags);
    }

    @Override
    public void forget(Xid xid) throws XAException {
        if (xar != null)
            xar.forget(xid);
    }

    @Override
    public int getTransactionTimeout() throws XAException {
        return xar == null ? 0 : xar.getTransactionTimeout();
    }

    @Override
    public boolean isSameRM(XAResource xaResource) throws XAException {
        return xar != null && xar.isSameRM(xaResource);
    }

    @Override
    public int prepare(Xid xid) throws XAException {
        return xar == null ? 0 : xar.prepare(xid);
    }

    private XAResource getXAResource() throws XAException {
        if (xar != null)
            return xar;

        if (connection == null) {
            try {
                if ((user == null) && (password == null))
                    connection = dataSource.getXAConnection();
                else
                    connection = dataSource.getXAConnection(user, password);
            } catch (SQLException e) {
                // An error occurred in determining the XIDs to return
                xar = null;

                throw new XAException(XAException.XAER_RMERR);
            }
        }

        try {
            xar = connection.getXAResource();

            return xar;
        } catch (SQLException e) {
            xar = null;

            closeConnection();

            throw new XAException(XAException.XAER_RMERR);
        }
    }

    private void closeConnection() {
        try {
            if (connection != null)
                connection.close();
        } catch (SQLException e) {
        } finally {
            xar = null;
            connection = null;
        }
    }

    @Override
    public Xid[] recover(int flag) throws XAException {
        if (flag == TMSTARTRSCAN) {

            return getXAResource().recover(flag);

        } else if (flag == TMNOFLAGS) {

            if (xar == null) {
                // TMNOFLAGS requires a recovery scan to already be in progress
                closeConnection();

                throw new XAException(XAException.XAER_INVAL);
            }

            try {
                return xar.recover(flag);
            } catch (XAException e) {
                closeConnection();

                throw e;
            }
        } else if (flag == TMENDRSCAN) {
            try {
                if (xar == null) // either TMSTARTRSCAN must not have been called or it failed
                   throw new XAException(XAException.XAER_INVAL);

                return xar.recover(flag);
            } finally {
                closeConnection();
            }
        } else {
            closeConnection();
            // invalid flag
            throw new XAException(XAException.XAER_INVAL);
        }
    }

    @Override
    public void rollback(Xid xid) throws XAException {
        if (xar != null)
            xar.rollback(xid);
    }

    @Override
    public boolean setTransactionTimeout(int seconds) throws XAException {
        return xar != null && xar.setTransactionTimeout(seconds);
    }

    @Override
    public void start(Xid xid, int flags) throws XAException {
        if (xar != null)
            xar.start(xid, flags);
    }
}
