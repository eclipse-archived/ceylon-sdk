import javax.transaction.xa {
    XAException,
    XAResource,
    Xid
}
import java.lang {
    ObjectArray,
    Runtime
}

class FaultType of halt|ex|none {
    shared actual String string;
    shared new halt { string = "HALT"; }
    shared new ex { string = "EX"; }
    shared new none { string = "NONE"; }
}

shared class DummyXAResource() satisfies XAResource {
    
    suppressWarnings("unusedDeclaration")
    Integer serialVersionUID = 1;
    
    variable FaultType fault = FaultType.none;
    
    variable Integer commitRequests = 0;
    variable ObjectArray<Xid> recoveryXids = ObjectArray<Xid>(0);
    
    shared variable Boolean startCalled = false;
    shared variable Boolean endCalled = false;
    shared variable Boolean prepareCalled = false;
    shared variable Boolean commitCalled = false;
    shared variable Boolean rollbackCalled = false;
    shared variable Boolean forgetCalled = false;
    shared variable Boolean recoverCalled = false;
    
    this.fault = FaultType.none;
    
    shared actual void commit(Xid xid, Boolean b) {
        print("DummyXAResource commit() called, fault: ``fault`` xid: ``xid``");
        commitCalled = true;
        commitRequests += 1;
        //if (exists fault) {
        if (fault==FaultType.ex) {
            throw XAException(XAException.\iXA_RBTRANSIENT);
        }
        else if (fault==FaultType.halt) {
            recoveryXids = ObjectArray<Xid>(1);
            recoveryXids.set(0, xid);
            Runtime.runtime.halt(1);
        }
        //}
    }
    
    end(Xid xid, Integer i) => endCalled = true;
    
    forget(Xid xid) => forgetCalled = true;
    
    transactionTimeout => 0;
    
    isSameRM(XAResource resource) => this==resource;
    
    shared actual Integer prepare(Xid xid) {
        prepareCalled = true;
        return XAResource.\iXA_OK;
    }
    
    shared actual ObjectArray<Xid> recover(Integer i) {
        recoverCalled = true;
        return recoveryXids;
    }
    
    rollback(Xid xid) => rollbackCalled = true;
    
    start(Xid xid, Integer i) => startCalled = true;
    
    setTransactionTimeout(Integer timeout) => false;
    
}
