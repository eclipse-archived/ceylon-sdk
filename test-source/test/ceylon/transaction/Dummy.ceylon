import java.lang {
    ObjectArray,
    Runtime
}

import javax.transaction.xa {
    XAException,
    XAResource,
    Xid
}

abstract class FaultType
    (shared actual String string) 
        of halt | ex | none {}
object halt extends FaultType("HALT") {}
object ex extends FaultType("EX") {}
object none extends FaultType("NONE") {}

shared class DummyXAResource() satisfies XAResource {
    
    suppressWarnings("unusedDeclaration")
    Integer serialVersionUID = 1;
    
    variable FaultType fault = none;
    
    variable Integer commitRequests = 0;
    variable ObjectArray<Xid> recoveryXids = ObjectArray<Xid>(0);
    
    shared variable Boolean startCalled = false;
    shared variable Boolean endCalled = false;
    shared variable Boolean prepareCalled = false;
    shared variable Boolean commitCalled = false;
    shared variable Boolean rollbackCalled = false;
    shared variable Boolean forgetCalled = false;
    shared variable Boolean recoverCalled = false;
    
    this.fault = none;
    
    shared actual void commit(Xid xid, Boolean b) {
        print("DummyXAResource commit() called, fault: ``fault`` xid: ``xid``");
        commitCalled = true;
        commitRequests += 1;
        switch (fault)
        case (ex) {
            throw XAException(XAException.\iXA_RBTRANSIENT);
        }
        case (halt) {
            recoveryXids = ObjectArray<Xid>(1);
            recoveryXids[0] = xid;
            Runtime.runtime.halt(1);
        }
        case (none) {}
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
