import ceylon.interop.java {
    createJavaObjectArray
}

import java.io {
    Serializable
}
import java.lang {
    ObjectArray
}

import javax.transaction.xa {
    XAResource {
        xa_ok=XA_OK
    },
    Xid
}

shared class DummyXAResource() 
        satisfies XAResource & Serializable {
    
    variable Integer txnTimeout = 0;

    shared actual void commit(Xid xid, Boolean arg1) {}

    shared actual Integer transactionTimeout
        => 0;
 
    shared actual Boolean isSameRM(XAResource arg0)
        => false; //this.equals(arg0);

    shared actual Integer prepare(Xid xid)
        => xa_ok;

    shared actual ObjectArray<Xid> recover(Integer arg0)
        => createJavaObjectArray<Xid>([]);

    shared actual void rollback(Xid xid) {} 

    shared actual void start(Xid xid, Integer arg1) {}

    shared actual Boolean setTransactionTimeout(Integer arg0) {
        txnTimeout = arg0;
        return true;
    }

    shared actual void forget(Xid xid) {}

    shared actual void end(Xid xid, Integer arg1) {}

}
