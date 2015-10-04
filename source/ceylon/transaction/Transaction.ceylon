import javax.transaction.xa {
    XAResource
}

shared interface Transaction {
    shared formal void enlistResource(XAResource xar);
    shared formal void markRollbackOnly();
    shared formal void commit();
    shared formal void rollback();
    shared formal Status status;
    shared formal void callBeforeCompletion(void beforeCompletion());
    shared formal void callAfterCompletion(void afterCompletion(Status status));
}
