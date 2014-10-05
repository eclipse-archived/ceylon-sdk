shared interface Transaction {
    shared formal void markRollbackOnly();
    shared formal void commit();
    shared formal void rollback();
    shared formal Status status;
    shared formal void setTimeout(Integer timeout);
    shared formal void callBeforeCompletion(void beforeCompletion());
    shared formal void callAfterCompletion(void afterCompletion(Status status));
}
