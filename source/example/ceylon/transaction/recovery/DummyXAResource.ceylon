import java.lang {
    ObjectArray
}

import ceylon.interop.java {
    createJavaObjectArray
}

import java.io {
    Serializable
}

import javax.transaction.xa {
    XAException, XAResource{ xa_ok=XA_OK }, Xid
}

shared class DummyXAResource() satisfies XAResource & Serializable {
    variable Integer txnTimeout = 0;

    throws(`class XAException`)
    shared actual void commit(Xid xid, Boolean arg1) {}

    throws(`class XAException`)
    shared actual Integer transactionTimeout
        => 0;
 
    throws(`class XAException`)
    shared actual Boolean isSameRM(XAResource arg0)
        => false; //this.equals(arg0);

    throws(`class XAException`)
    shared actual Integer prepare(Xid xid)
        => xa_ok;

    throws(`class XAException`)
    shared actual ObjectArray<Xid> recover(Integer arg0)
        => createJavaObjectArray<Xid>([]);

    throws(`class XAException`)
    shared actual void rollback(Xid xid) {} 

    throws(`class XAException`)
    shared actual void start(Xid xid, Integer arg1) {}

    throws(`class XAException`)
    shared actual Boolean setTransactionTimeout(Integer arg0) {
        txnTimeout = arg0;
        return true;
    }

    throws(`class XAException`)
    shared actual void forget(Xid xid) {}

    throws(`class XAException`)
    shared actual void end(Xid xid, Integer arg1) {}

}
